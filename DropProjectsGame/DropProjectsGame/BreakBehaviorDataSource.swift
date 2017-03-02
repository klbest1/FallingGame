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
    public var numberOfBallsInDifferentLevel:Int = 1
    public var currentNumberOfBalls:Int = 0
    public weak var delegate:BreakBehaviorDataSourceDelegate?
    public var ballsReadyToPush:[BallView] = [BallView]()
    
    private var breakObjectBehavior:BreakBehavior?;
    private var gameView:GameSceneView?
    private var dynamicBreakerAnimator :UIDynamicAnimator?
    private var touchedPaddle:Bool = false;
    private var firstPushBallDown:Bool = false
    
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
           
            for itemDy in behavior.collisionBehavior.items{
                let item:BallView = itemDy as! BallView
                if( item.frame.origin.y > UIView.screenHight){
                    self.stopAnimator()
                    self.resetBallDynamic()
                }
            }
        }
        
        behavior.gravityBehavior.action = {
            [unowned self] in
//            let item:BallView = behavior.gravityBehavior.items.first as! BallView;
            for itemDy:UIDynamicItem in behavior.gravityBehavior.items{
                let item = itemDy as! BallView
                if(Int(item.frame.origin.y) == Int(self.gameView!.paddleView!.frame.origin.y - BallSize.width)){
                    //                print("item.frame.origin.y:\(item.frame.origin.y)");
                    item.touchedPaddle = true;
                    if(!self.ballsReadyToPush.contains(item)){
                        self.ballsReadyToPush.insert(item, at: 0)
                    }
                    //第一次接触板时让球停下
                    if (item.firstPushBallDown )  {
                        item.pushAngle = -M_PI_4
                        item.pushMagnitude = 0.8
                        print("push了一次")
                        self.startPushing()
                        item.firstPushBallDown = false
                    }
                }
                //            print("item:\(item.frame)")
                if( item.frame.origin.y >=  (self.gameView!.hight - BallSize.width)){
                    self.delegate?.didBallfallingOnTheGround(sender: self)
                }
 
            }
                
        }
        
        breakObjectBehavior = behavior;
        
    }
    
    func unInitBehavior()  {
        ballsReadyToPush.removeAll()
        breakObjectBehavior?.removeItemsFromBehaviors()
        breakObjectBehavior?.removeChildBehavior(breakObjectBehavior!.collisionBehavior)
        breakObjectBehavior?.removeChildBehavior(breakObjectBehavior!.gravityBehavior)
        breakObjectBehavior = nil;
    }
    
    func initBallBehaviors(){
        let path:UIBezierPath = UIBezierPath.init(rect: gameView!.paddleView!.frame);
        self.addBundary(name: PathNames.paddleBundryName , path: path)
        breakObjectBehavior!.removeItemsFromBehaviors()
        breakObjectBehavior!.addCollisionForItems(items: gameView!.ballViews);
        breakObjectBehavior!.addPush(item:gameView!.ballsNeedPushAtStart.first!);
        //刚出现的球已经被推出，所以需要移除
        gameView!.ballsNeedPushAtStart.first!.firstPushBallDown = true
        gameView!.ballsNeedPushAtStart.removeFirst()
        currentNumberOfBalls = 1
    }
    
    func addExtralBallIntoBehaviors()  {
        if breakObjectBehavior != nil{
            breakObjectBehavior!.addCollisionForItems(items: gameView!.ballViews);
            let extralBall:BallView = gameView!.ballsNeedPushAtStart.first!
            //向上推出，这样不必判断板子的位置
            extralBall.pushAngle =  M_PI_4*(-3)
            extralBall.pushMagnitude = 2.8
            breakObjectBehavior!.addPush(item:gameView!.ballsNeedPushAtStart.first!);
            //刚出现的球已经被推出，所以需要移除
            gameView!.ballsNeedPushAtStart.removeFirst()
        }
    }
    
    func addExtralBall()  {
        currentNumberOfBalls += 1
        let delayTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
            self.gameView?.addBallView()
            self.addExtralBallIntoBehaviors()
        })
    }
    
    func resetBallDynamic() {
        gameView!.removeBallViews()
        gameView!.addBallView()
        startAnimator()
    }
    
    func startAnimator()  {
        lazyInitBehaviors()
        dynamicBreakerAnimator!.addBehavior(breakObjectBehavior!)
        initBallBehaviors();
        print("start.....")
    }
    
    func stopAnimator() {
        dynamicBreakerAnimator!.removeBehavior(breakObjectBehavior!)
        dynamicBreakerAnimator!.removeAllBehaviors()
        unInitBehavior()
    }
    
    func pauseAnimator()  {
        dynamicBreakerAnimator!.removeBehavior(breakObjectBehavior!)
        dynamicBreakerAnimator!.removeAllBehaviors()
    }
    
    func addBundary(name:String,path:UIBezierPath) {
        breakObjectBehavior?.removeBundry(name:name as NSCopying)
        breakObjectBehavior?.addBundry(name: name as NSCopying, path: path)
    }
    
    func  startPushing() {
        let ball:BallView? = ballsReadyToPush.first
        if ball != nil {
            if ball!.touchedPaddle{
                if((ball?.firstPushBallDown)! == false && (ball?.pushAngle)! > Double(0)){
                    //手指下滑时什么也不做
                    return
                }
                breakObjectBehavior?.addPush(item: ball!);
                ball!.touchedPaddle = false
                ballsReadyToPush.remove(at: (ballsReadyToPush.index(of: ball!))!)
            }
        }
        
        //加入第二个球.第三个
        if (currentNumberOfBalls < numberOfBallsInDifferentLevel) {
            print("currentBall\(currentNumberOfBalls)-->totalBall\(numberOfBallsInDifferentLevel)")
            addExtralBall()
        }
    }
    
    
    //p.hight-ballView.size.hight
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?){
        if (identifier != nil) , identifier as! String == PathNames.paddleBundryName  {
            let ballView:BallView = item as! BallView
            ballView.touchedPaddle = true
            //碰撞到黄色板，加入到要弹出的队列
            if !ballsReadyToPush.contains(ballView){
                ballsReadyToPush.insert(ballView, at: 0)
            }
            //第一次接触板时让球停下
            if (ballView.firstPushBallDown )  {
                ballView.pushAngle = -M_PI_4
                ballView.pushMagnitude = 0.8
                self.startPushing()
                ballView.firstPushBallDown = false
                print("push了一次")
            }
            print("TouchPaddle:\(touchedPaddle)")
        }
    }
}
