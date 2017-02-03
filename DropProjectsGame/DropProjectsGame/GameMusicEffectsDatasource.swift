//
//  GameMusicEffectsDatasource.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/3.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

enum GameAudioType{
    case backround_one,
    backround_two,
    backround_three,
    backround_four,
    collison,
    fallingon,
    gameOver,
    gameWin
    
    func getStateMusicName() -> String! {
        switch self {
        case .backround_one:
            return "backGroundMusic_1.mp3";
        case .backround_two:
            return "backGroundMusic_2.mp3"
        case .backround_three:
            return "backGroundMusic_3.mp3"
        case .backround_four:
            return "backGroundMusic_4.mp3"
        case .collison:
            return "collision.wav"
        case .fallingon:
            return "fallingOn.mp3"
        case .gameOver:
            return "gameOver.wav"
        case .gameWin:
            return "gameWin.wav"
        }
    }
}

class GameMusicEffectsDatasource: NSObject {
    let audioHandler:AudioHandler = AudioHandler()
    var musicIDs:[String:String] = [String:String]()
    
    func playMusic(musicType:GameAudioType)  {
        let soundName = musicType.getStateMusicName()
        let path = Bundle.main.path(forResource: soundName, ofType: nil)
        var kRepeat:Bool = false
        if  (musicType == .backround_one
            || musicType == .backround_two
            || musicType == .backround_three
            || musicType == .backround_four){
            kRepeat = true
        }
        if (path != nil){
           let uuid =  audioHandler.playSoundWithSoundType(path: path! as String, kRepeat: kRepeat)
            if uuid != nil{
                musicIDs[musicType.getStateMusicName()] = uuid
            }
        }
        else{
            print("不存在音乐文件\(soundName)")
        }
    }
    
    func stopMusic(musicType:GameAudioType) {
        let uuid = musicIDs[musicType.getStateMusicName()]
        audioHandler.stopSoundWithSoundType(soundID: uuid!)
    }
}
