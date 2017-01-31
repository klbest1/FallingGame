//
//  AudioPlayer.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/29.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit
import AVFoundation

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

class AudioPlayer: NSObject,AVAudioPlayerDelegate {
    private var audioBackGourndMusicPlayer:AVAudioPlayer!
    private var audioInstantMusicPlayer:AVAudioPlayer!
    public var  instantMusicRrepeateTime:Int = 0;
    
    func playSoundWithSoundType(soundType:GameAudioType )  {
        let soundName = soundType.getStateMusicName()
        let path = Bundle.main.path(forResource: soundName, ofType: nil)
        let url = URL(fileURLWithPath: path!)
        
        do {
            if soundType  == .backround_one ||
                soundType == .backround_two ||
                soundType == .backround_three ||
                soundType == .backround_four{
                let sound = try AVAudioPlayer(contentsOf: url)
                sound.delegate = self;
                if audioBackGourndMusicPlayer != nil{
                    audioBackGourndMusicPlayer.stop();
                    audioBackGourndMusicPlayer = nil;
                }
               audioBackGourndMusicPlayer = sound
               audioBackGourndMusicPlayer.play()
            }else{
                if audioInstantMusicPlayer == nil{
                    let sound = try AVAudioPlayer(contentsOf: url)
                    sound.delegate = self;
                    audioInstantMusicPlayer = sound
                    audioInstantMusicPlayer.play()
                }
            }
        } catch{
            print("\(soundName) 不能播放!")
        }
    }
    
    func stopSoundWithSoundType(soundType:GameAudioType) {
        if soundType  == .backround_one ||
            soundType == .backround_two ||
            soundType == .backround_three ||
            soundType == .backround_four{
            if audioBackGourndMusicPlayer != nil{
                audioBackGourndMusicPlayer.stop();
                audioBackGourndMusicPlayer = nil;
            }
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if instantMusicRrepeateTime > 0 {
            audioInstantMusicPlayer.play()
            instantMusicRrepeateTime -= 1;
        }else {
            audioInstantMusicPlayer = nil;
        }
        
        //背景音乐循环播放
        if player == audioBackGourndMusicPlayer{
            player.play()
        }
    }
    
    /* if an error occurs while decoding it will be reported to the delegate. */
     public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
     {}

}
