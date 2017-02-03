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
    private let musicDatasource:GameMusicEffectsDatasource = GameMusicEffectsDatasource()
    
    var breakBehaviorDataSource:BreakBehaviorDataSource?
    var fallingBehaviorDataSource:FallingObjectDatasource?
    var fallingDropsSetting:FallingDropSetting = FallingDropSetting()
    let leveManager:LevelManager = LevelManager()
    
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
        musicDatasource.playMusic(musicType: .backround_one)
    }
    
    func gameStop() {
        breakBehaviorDataSource!.stopAnimator();
        fallingBehaviorDataSource!.stopAnimator()

    }
    
    func gameRefresh()  {
        fallingBehaviorDataSource!.resetAnimator()
        breakBehaviorDataSource!.resetBallDynamic()
        musicDatasource.playMusic(musicType: .backround_one)
    }
    
    
    func didScoreChanged(sender:FallingObjectDatasource , aScore:Int)
    {
        musicDatasource.playMusic(musicType: .collison)
        score = aScore;
        print("游戏得分：\(score)");
    }
    
    func didCollisionWithTheBottomBundary(sender:FallingObjectDatasource)
    {
        print("1游戏结束：\(score)")
        musicDatasource.stopMusic(musicType: .backround_one)
        musicDatasource.playMusic(musicType: .gameWin)
        fallingBehaviorDataSource?.stopAnimator()
        //这里最好建一个结果对象
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: addGameResultsNotifiName), object: score)
    }

    func didBallfallingOnTheGround(sender:BreakBehaviorDataSource){
        print("球掉地上了，游戏结束");
        musicDatasource.stopMusic(musicType: .backround_one)
        musicDatasource.playMusic(musicType: .gameOver)
        gameStop()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: addGameResultsNotifiName), object: score)
    }

}

