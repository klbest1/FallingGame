//
//  GameEngine.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/24.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

struct PathNames{
    static let paddleBundryName = "paddleName"
    static let ballBundaryName = "ballViewName"
}

private let shareInstance = GameEngine()

class GameEngine: NSObject,FallingObjectDatasourceDelegate,BreakBehaviorDataSourceDelegate {
    class var share: GameEngine {
        return shareInstance
    }
    
    public var score:Int = 0
    private let audioPlayer:AudioPlayer = AudioPlayer()
    
    var breakBehaviorDataSource:BreakBehaviorDataSource?
    var fallingBehaviorDataSource:FallingObjectDatasource?
    var fallingDropsSetting:FallingDropSetting = FallingDropSetting()
    let leveManager:LevelManager = LevelManager()
    var gameFinish:Bool = false
    
    var referenceView:GameSceneView? {
        didSet{
            //这里先写死，随后要改成根据用户来获取
            self.fallingDropsSetting.fallingSpeed = 1.5
            self.fallingDropsSetting.numberOfDrops = 500;
            self.breakBehaviorDataSource = BreakBehaviorDataSource(referenceView:self.referenceView!);
            fallingBehaviorDataSource = FallingObjectDatasource(referenceView: self.referenceView!, fallingDropsSetting: self.fallingDropsSetting)
            fallingBehaviorDataSource?.delegate = self
            breakBehaviorDataSource?.delegate = self
        }
    }
    
    override init(){
        super.init()
        
    }
    
    func gameStart(withReferenceView _referenceView:GameSceneView) {
        if referenceView == nil {
            referenceView = _referenceView
        }
        breakBehaviorDataSource!.startAnimator()
        fallingBehaviorDataSource!.startAnimator()
        audioPlayer.playSoundWithSoundType(soundType: .backround_one)
    }
    
    func gameStop() {
        breakBehaviorDataSource!.stopAnimator();
        fallingBehaviorDataSource!.stopAnimator()

    }
    
    func gameRefresh()  {
        fallingBehaviorDataSource!.resetAnimator()
        breakBehaviorDataSource!.resetBallDynamic()
        gameFinish = false
    }
    
    
    func didCollisionWithTheBallBundary(sender:FallingObjectDatasource , numberOfDisappearedBalls:Int){
        
//        audioPlayer.playSoundWithSoundType(soundType: .collison)
        audioPlayer.instantMusicRrepeateTime =  numberOfDisappearedBalls - score
        score = numberOfDisappearedBalls;
        print("游戏得分：\(score)");
    }
    
    func didCollisionWithTheBottomBundary(sender:FallingObjectDatasource)
    {
        if !gameFinish {
            print("游戏结束：\(score)")
            gameFinish = true
            fallingBehaviorDataSource?.stopAnimator()
            //这里最好建一个结果对象
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: addGameResultsNotifiName), object: score)
        }
    }

    func didBallfallingOnTheGround(sender:BreakBehaviorDataSource){
        if !gameFinish{
            print("球掉地上了，游戏结束");
            gameFinish = true
            fallingBehaviorDataSource?.stopAnimator()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: addGameResultsNotifiName), object: score)
        }
       
    }

}

