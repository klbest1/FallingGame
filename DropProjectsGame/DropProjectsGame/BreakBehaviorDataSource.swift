//
//  BreakBehaviorDataSource.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/11.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

protocol BreakBehaviorDataSourceDelegate:class {
    func didBallfallingOnTheGround(sender:BreakBehaviorDataSource);
}


class BreakBehaviorDataSource: NSObject,UICollisionBehaviorDelegate {
    public var pushInitAngle:Double = 0.04;
    public var pushAngle:Double =  -M_PI_4
    public var pushMagnitude:CGFloat = 0;
    public weak var delegate:BreakBehaviorDataSourceDelegate?

    
    private var breakObjectBehavior:BreakBehavior? = BreakBehavior();
    private var gameView:GameSceneView?
    private var dynamicBreakerAnimator :UIDynamicAnimator?
    private var touchedPaddle:Bool = false;
    
     init(referenceView:GameSceneView) {
        super.init()
        gameView = referenceView
        dynamicBreakerAnimator  = UIDynamicAnimator(referenceView: gameView!)
        breakObjectBehavior!.collisionBehavior.collisionDelegate = self;
        self.breakObjectBehavior!.collisionBehavior.action = {
            [unowned self] in
            let item:UIView = self.breakObjectBehavior!.collisionBehavior.items.first as! UIView;
            if( item.frame.origin.y > UIView.screenHight){
               self.resetBallDynamic()
            }
        }
        
        self.breakObjectBehavior!.gravityBehavior.action = {
            [unowned self] in
            let item:UIView = self.breakObjectBehavior!.gravityBehavior.items.first as! UIView;
            if( item.frame.origin.y >=  (self.gameView!.hight - self.gameView!.ballView!.frame.size.height)){
               
                self.delegate?.didBallfallingOnTheGround(sender: self)
            }
        }
        
    }

    
    func addBallBehaviors(){
        let path:UIBezierPath = UIBezierPath.init(rect: gameView!.paddleView!.frame);
        self.addBundary(name: PathNames.paddleBundryName , path: path)
        breakObjectBehavior!.addCollisionForItems(items: [gameView!.ballView!]);
        breakObjectBehavior!.addPush(item:gameView!.ballView!,angle:pushInitAngle,magnitude: 3);
    }
    
    
    func resetBallDynamic() {
        self.gameView?.ballView?.removeFromSuperview()
        self.gameView?.ballView = nil;
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
    
    func  startPushing() {
        if touchedPaddle{
            breakObjectBehavior!.addPush(item: gameView!.ballView!, angle:pushAngle,magnitude: pushMagnitude);
            touchedPaddle = false
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?){
        if (identifier != nil) , identifier as! String == PathNames.paddleBundryName  {
            touchedPaddle = true
        }
    }
}
