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

    
    private var breakObjectBehavior:BreakBehavior?;
    private var gameView:GameSceneView?
    private var dynamicBreakerAnimator :UIDynamicAnimator?
    private var touchedPaddle:Bool = false;
    
     init(referenceView:GameSceneView) {
        super.init()
        gameView = referenceView
        dynamicBreakerAnimator  = UIDynamicAnimator(referenceView: gameView!)
    }
    
    func  lazyInitBehaviors()  {
        let behavior:BreakBehavior = BreakBehavior()
        behavior.collisionBehavior.collisionDelegate = self;
        behavior.collisionBehavior.action = {
            [unowned self] in
           
            let item:UIView? = behavior.collisionBehavior.items.first as? UIView;
            if(item !=  nil){
                if( item!.frame.origin.y > UIView.screenHight){
                    self.stopAnimator()
                    self.resetBallDynamic()
                }
            }
        }
        
        behavior.gravityBehavior.action = {
            [unowned self] in
            let item:UIView = behavior.gravityBehavior.items.first as! UIView;
            if(Int(item.frame.origin.y) == Int(self.gameView!.paddleView!.frame.origin.y - self.gameView!.ballView!.frame.size.height)){
                print("item.frame.origin.y:\(item.frame.origin.y)");
                self.touchedPaddle = true;

            }
            if( item.frame.origin.y >=  (self.gameView!.hight - self.gameView!.ballView!.frame.size.height)){
                self.delegate?.didBallfallingOnTheGround(sender: self)
            }
        }
        
        breakObjectBehavior = behavior;
        
    }
    
    func unInitBehavior()  {
        breakObjectBehavior?.removeItemsFromBehaviors()
        breakObjectBehavior?.removeChildBehavior(breakObjectBehavior!.collisionBehavior)
        breakObjectBehavior?.removeChildBehavior(breakObjectBehavior!.gravityBehavior)
        breakObjectBehavior = nil;
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
        startAnimator()
    }
    
    func startAnimator()  {
        lazyInitBehaviors()
        dynamicBreakerAnimator!.addBehavior(breakObjectBehavior!)
        addBallBehaviors();
        print("start.....")
    }
    
    func stopAnimator() {
        dynamicBreakerAnimator!.removeBehavior(breakObjectBehavior!)
        dynamicBreakerAnimator!.removeAllBehaviors()
        unInitBehavior()
    }
    
    func addBundary(name:String,path:UIBezierPath) {
        breakObjectBehavior?.removeBundry(name:name as NSCopying)
        breakObjectBehavior?.addBundry(name: name as NSCopying, path: path)
    }
    
    func  startPushing() {
        if touchedPaddle{
            breakObjectBehavior?.addPush(item: gameView!.ballView!, angle:pushAngle,magnitude: pushMagnitude);
            touchedPaddle = false
        }
    }
    //p.hight-ballView.size.hight
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?){
        if (identifier != nil) , identifier as! String == PathNames.paddleBundryName  {
            touchedPaddle = true
            print("TouchPaddle:\(touchedPaddle)")
        }
    }
}
