//
//  BreakBehaviorDataSource.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/11.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class BreakBehaviorDataSource: NSObject,UICollisionBehaviorDelegate {
    public var pushInitAngle:Double = 0.04;
    public var pushAngle:Double =  -M_PI_4
    
    private var breakObjectBehavior:BreakBehavior? = BreakBehavior();
    private var gameView:GameSceneView?
    private var dynamicBreakerAnimator :UIDynamicAnimator?
    
     init(referenceView:GameSceneView) {
        super.init()
        gameView = referenceView
        dynamicBreakerAnimator  = UIDynamicAnimator(referenceView: gameView!)
        breakObjectBehavior!.collisionBehavior.collisionDelegate = self;
        self.breakObjectBehavior!.collisionBehavior.action = {
            [unowned self] in
            let item:UIView = self.breakObjectBehavior!.collisionBehavior.items.first as! UIView;
            if( item.frame.origin.y > UIView.screenHight){
                item.removeFromSuperview();
                self.gameView?.ballView = nil;
               self.resetBallDynamic()
            }
        }
        
    }

    func addBallBehaviors(){
        let path:UIBezierPath = UIBezierPath.init(rect: gameView!.paddleView!.frame);
        self.addBundary(name: GameSceneView.PathNames.paddleBundryName , path: path)
        breakObjectBehavior!.addCollisionForItems(items: [gameView!.ballView!]);
        breakObjectBehavior!.addPush(item:gameView!.ballView!,angle:pushInitAngle);
    }
    
    
    func resetBallDynamic() {
       self.gameView!.addBallView()
       breakObjectBehavior?.removeItemsFromGravityCollision();
       addBallBehaviors()
    }
    
    func startAnimator()  {
        dynamicBreakerAnimator!.addBehavior(breakObjectBehavior!)
        addBallBehaviors();
    }
    
    func stopAnimator() {
        dynamicBreakerAnimator!.removeAllBehaviors()
    }
    
    func addBundary(name:String,path:UIBezierPath) {
        breakObjectBehavior!.removeBundry(name:name as NSCopying)
        breakObjectBehavior!.addBundry(name: name as NSCopying, path: path)
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?){
        if (identifier != nil) , identifier as! String == GameSceneView.PathNames.paddleBundryName  {
            breakObjectBehavior!.addPush(item: gameView!.ballView!, angle:pushAngle);
        }
    }
}
