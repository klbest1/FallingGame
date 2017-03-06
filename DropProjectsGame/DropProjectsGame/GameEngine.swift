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
    
    var score:Int = 0
    var lastLevelScore:Int = 0
    private let musicDatasource:GameMusicEffectsDatasource = GameMusicEffectsDatasource()
    private let particleHander:ParticleHandler = ParticleHandler()
    
    var breakBehaviorDataSource:BreakBehaviorDataSource?
    var fallingBehaviorDataSource:FallingObjectDatasource?
    var fallingDropsSetting:FallingDropSetting = FallingDropSetting()
    var currentLevel:Level?
    var currentLevelIndex:Int = 0
    var timeDelayWhenGotoNext:Int = 3
    
    var referenceView:GameSceneView? {
        didSet{
            currentLevelIndex = Int((UserManager.share.currentUser.result?.level)!)
            currentLevel = (LevelManager.share.levelResponse?.results?[currentLevelIndex])!
            self.breakBehaviorDataSource = BreakBehaviorDataSource(referenceView:self.referenceView!);
            fallingBehaviorDataSource = FallingObjectDatasource(referenceView: self.referenceView!, fallingDropsSetting: self.fallingDropsSetting)
            gameSetting()
            fallingBehaviorDataSource?.delegate = self
            breakBehaviorDataSource?.delegate = self
            
        }
    }
    
    override init(){
        super.init()
        
    }
    //游戏设置
    func gameSetting()  {
        fallingDropsSetting.fallingSpeed = currentLevel!.fallingSpeed! as Float?
        fallingDropsSetting.numberOfDrops = currentLevel!.numberOfBalls! as Int?;
        fallingBehaviorDataSource?.fallingSetting = fallingDropsSetting
        breakBehaviorDataSource?.numberOfBallsInDifferentLevel = currentLevel!.numberOfBalls as! Int
    }
    
    
    func gameStart(withReferenceView _referenceView:GameSceneView) {
        if referenceView == nil {
            referenceView = _referenceView
        }
        breakBehaviorDataSource!.startAnimator()
        fallingBehaviorDataSource!.startAnimator()
        musicDatasource.playMusic(musicName: (currentLevel?.backGroundMusic)!)
        sentGamePlayingInfoNoti()
    }
    
    func sentGamePlayingInfoNoti() {
        let titleObject = TitleObject()
        titleObject.currenScore = lastLevelScore + score
        titleObject.currentLevel = currentLevelIndex
        titleObject.goalScore = currentLevel?.scoreGoal! as! Int + lastLevelScore
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleGamePlayingNotifiName), object: titleObject)

    }
    
    func gameStop() {
        breakBehaviorDataSource!.stopAnimator();
        fallingBehaviorDataSource!.stopAnimator()

    }
    
    func gamePause()  {
        fallingBehaviorDataSource?.pauseDrops()
    }
    
    func gameContinue()  {
        fallingBehaviorDataSource?.addDrops()
    }
    
    func gameRefresh()  {
        score = 0
        if (!(UserManager.share.currentUser.result?.passLevel)!){
            lastLevelScore = 0
        }
        fallingBehaviorDataSource!.resetAnimator()
        breakBehaviorDataSource!.resetBallDynamic()
        referenceView?.resetPaddleView()
        musicDatasource.playMusic(musicName: (currentLevel?.backGroundMusic)!)
        sentGamePlayingInfoNoti()
    }
    
    func gotoNextLevel() {
        currentLevelIndex += 1
        if currentLevelIndex >= (LevelManager.share.levelResponse?.results?.count)!{
            currentLevelIndex = 0
        }
        currentLevel = (LevelManager.share.levelResponse?.results?[currentLevelIndex])!
        lastLevelScore += score;
        gameSetting()
        gameRefresh()
    }
    
    func gameResultsChecking() {
        print("检查游戏结果")
        musicDatasource.stopMusic(musicName: (currentLevel?.backGroundMusic)!)
        gameStop()

        let result:Result = Result()
        result.score = Int32(score + lastLevelScore);
        result.level = Int16(currentLevelIndex)
        result.passLevel = ((currentLevel?.scoreGoal?.intValue)! <= score)
        UserManager.share.currentUser.result = result

        if(result.passLevel){
            musicDatasource.playMusic(musicType: .gameWin)
            self.perform(#selector(gotoNextLevel), with: nil, afterDelay: TimeInterval(timeDelayWhenGotoNext))
        }else{
            musicDatasource.playMusic(musicType: .gameOver)
        }
        NotificationCenter.default.post(name: NSNotification.Name(handleGameResultsNotifiName), object: result)
        print("执行了通知\(result)")
    }
    
    func didScoreChanged(sender:UIDynamicItem , aScore:Int)
    {
        musicDatasource.playMusic(musicType: .collison)
        score = aScore;
        print("游戏得分：\(score)");
        sentGamePlayingInfoNoti()
        particleHander.addExplodeEmitter(destiantionView: referenceView!, location: sender.center,color:(sender as! UIView).layer.borderColor!)
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

