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
    static let referenceBundayName = "referenceBunday"
}

private let shareInstance = GameEngine()

class GameEngine: NSObject,FallingObjectDatasourceDelegate {
    class var share: GameEngine {
        return shareInstance
    }
    
    public var score:Int = 0
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

    }
    
    func gameStop() {
        breakBehaviorDataSource!.stopAnimator();
        fallingBehaviorDataSource!.stopAnimator()

    }
    
    func didCollisionWithTheBallBundary(sender:FallingObjectDatasource , numberOfDisappearedBalls:Int){
        score = numberOfDisappearedBalls;
        print("游戏得分：\(score)");
    }
    
    func didCollisionWithTheBottomBundary(sender:FallingObjectDatasource)
    {
        print("游戏结束：\(score)")
        fallingBehaviorDataSource?.endingDrops()
    }

}

