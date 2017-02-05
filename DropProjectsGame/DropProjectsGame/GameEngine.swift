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
    var currentLevel:Level?
    var currentLevelIndex:Int = 0
    
    var referenceView:GameSceneView? {
        didSet{
            //这里先写死，随后要改成根据用户来获取
            currentLevelIndex = Int((UserManager.share.currentUser.result?.level)!)
            currentLevel = (LevelManager.share.levelResponse?.results?[currentLevelIndex])!
            gameSetting()
            self.breakBehaviorDataSource = BreakBehaviorDataSource(referenceView:self.referenceView!);
            fallingBehaviorDataSource = FallingObjectDatasource(referenceView: self.referenceView!, fallingDropsSetting: self.fallingDropsSetting)
            fallingBehaviorDataSource?.delegate = self
            breakBehaviorDataSource?.delegate = self
            
        
        }
    }
    
    override init(){
        super.init()
        
    }
    
    func gameSetting()  {
        fallingDropsSetting.fallingSpeed = currentLevel!.fallingSpeed! as Float?
        fallingDropsSetting.numberOfDrops = currentLevel!.numberOfBalls! as Int?;
    }
    
    func gameStart(withReferenceView _referenceView:GameSceneView) {
        if referenceView == nil {
            referenceView = _referenceView
        }
        breakBehaviorDataSource!.startAnimator()
        fallingBehaviorDataSource!.startAnimator()
        musicDatasource.playMusic(musicName: (currentLevel?.backGroundMusic)!)
    }
    
    func gameStop() {
        breakBehaviorDataSource!.stopAnimator();
        fallingBehaviorDataSource!.stopAnimator()

    }
    
    func gameRefresh()  {
        fallingBehaviorDataSource!.resetAnimator()
        breakBehaviorDataSource!.resetBallDynamic()
        musicDatasource.playMusic(musicName: (currentLevel?.backGroundMusic)!)
    }
    
    func gotoNextLevel() {
        currentLevelIndex += 1
        if currentLevelIndex >= (LevelManager.share.levelResponse?.results?.count)!{
            currentLevelIndex = (LevelManager.share.levelResponse?.results?.count)!
        }
        currentLevel = (LevelManager.share.levelResponse?.results?[currentLevelIndex])!
        gameSetting()
        gameRefresh()
    }
    
    func gameResultsChecking() {
        musicDatasource.stopMusic(musicName: (currentLevel?.backGroundMusic)!)
        gameStop()

        let result:Result = Result()
        result.score = Int32(score);
        result.level = Int16(currentLevelIndex)
        result.passLevel = ((currentLevel?.scoreGoal?.intValue)! <= score)
        if(result.passLevel){
            musicDatasource.playMusic(musicType: .gameWin)
            gotoNextLevel()
            
        }else{
            musicDatasource.playMusic(musicType: .gameOver)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: addGameResultsNotifiName), object: result)
        }
        UserManager.share.currentUser.result = result
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
        gameResultsChecking()
    }

    func didBallfallingOnTheGround(sender:BreakBehaviorDataSource){
       print("球掉地上了，游戏结束");
       gameResultsChecking()
    }

}

