//
//  AudioPlayer.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/29.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit
import AVFoundation

//笔记，将功能和业务分开

//新建数组或字典
class AudioHandler: NSObject,AVAudioPlayerDelegate {
    var audioPlayers:[String: AVAudioCustomPlayer] = [String: AVAudioCustomPlayer]()
    
    func playSoundWithSoundType(path:String, kRepeat:Bool) ->String?  {
    let url = URL(fileURLWithPath: path)
        do {
            let sound = try AVAudioCustomPlayer(contentsOf: url)
            sound.audioRepeat = kRepeat
            sound.delegate = self;
            sound.play()
            let playerKey = String.getUUID()
            sound.uuid = playerKey
            audioPlayers[playerKey] = sound
            return playerKey
        } catch{
            print("\(path) 不能播放!")
        }
        return nil
    }
    
    func stopSoundWithSoundType(soundID:String) {
        let audioPlayer = audioPlayers[soundID]
        audioPlayer?.stop();
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        let customPlayer:AVAudioCustomPlayer = player as! AVAudioCustomPlayer
        //音乐循环播放
        if customPlayer.audioRepeat{
            player.play()
        }else{
            player.stop()
            audioPlayers.removeValue(forKey:customPlayer.uuid!)
        }
    }
    
    /* if an error occurs while decoding it will be reported to the delegate. */
     public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
     {}

}
