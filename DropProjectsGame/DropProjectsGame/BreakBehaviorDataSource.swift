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
    
//    private var breakObjectBehavior:BreakBehavior?;
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
                print("item.y\(item.frame)")
                if( item.frame.origin.y > UIView.screenHight){
                    self.stopAnimator()
                    self.resetBallDynamic()
                }
                
                let emitatePoint = CGPoint(x: item.frame.origin.x, y: self.gameView!.center.y)
                let isInthePaddleRange:Bool = self.gameView!.paddleView!.frame.contains(emitatePoint)
                if(Int(item.frame.origin.y) > Int(self.gameView!.paddleView!.frame.origin.y - BallSize.width - 3) && isInthePaddleRange){
                    //                print("item.frame.origin.y:\(item.frame.origin.y)");
                    item.touchedPaddle = true;
                    if(!self.ballsReadyToPush.contains(item)){
                        self.ballsReadyToPush.insert(item, at: 0)
                    }
                    //第一次接触板时让球停下
                    if (item.firstPushBallDown )  {
                        self.smallPush()
                    }
                }
                //            print("item:\(item.frame)")
                if( item.frame.origin.y >=  (self.gameView!.hight - BallSize.width)){
                    self.delegate?.didBallfallingOnTheGround(sender: self)
                }
            }
        }
        
        behavior.gravityBehavior.action = {
            [unowned self] in
//            let item:BallView = behavior.gravityBehavior.items.first as! BallView;
            for itemDy:UIDynamicItem in behavior.gravityBehavior.items{
                let item = itemDy as! BallView
//                if(Int(item.frame.origin.y) == Int(self.gameView!.paddleView!.frame.origin.y - BallSize.width - 6)){
//                    //                print("item.frame.origin.y:\(item.frame.origin.y)");
//                    item.touchedPaddle = true;
//                    if(!self.ballsReadyToPush.contains(item)){
//                        self.ballsReadyToPush.insert(item, at: 0)
//                    }
//                    //第一次接触板时让球停下
//                    if (item.firstPushBallDown )  {
//                        self.smallPush()
//                    }
//                }
                //            print("item:\(item.frame)")
                if( item.frame.origin.y >=  (self.gameView!.hight - BallSize.width)){
                    self.delegate?.didBallfallingOnTheGround(sender: self)
                }
 
            }
                
        }
        //设置下落速度
        if numberOfBallsInDifferentLevel > 1 {
            behavior.setfallingSpeed(speed: 1)
        }else{
            behavior.setfallingSpeed(speed: 100/4)
        }
        
        let ballView = gameView!.ballsNeedPushAtStart.first
        ballView?.breakObjectBehavior = behavior;
        dynamicBreakerAnimator!.addBehavior(behavior)
    }
    
    func unInitBehavior()  {
        ballsReadyToPush.removeAll()
        for balView in (gameView!.ballViews){
            balView.breakObjectBehavior?.removeItemsFromBehaviors()
            balView.breakObjectBehavior?.removeChildBehavior(balView.breakObjectBehavior!.collisionBehavior)
            balView.breakObjectBehavior?.removeChildBehavior(balView.breakObjectBehavior!.gravityBehavior)
            dynamicBreakerAnimator!.removeBehavior(balView.breakObjectBehavior!)
            balView.breakObjectBehavior = nil;
        }
        dynamicBreakerAnimator!.removeAllBehaviors()
    }
    
    func initBallBehaviors(){
        let path:UIBezierPath = UIBezierPath.init(rect: gameView!.paddleView!.frame);
        addBundary(name: PathNames.paddleBundryName , path: path)
        let ballView = gameView!.ballsNeedPushAtStart.first

        ballView?.breakObjectBehavior!.removeItemsFromBehaviors()
        ballView?.breakObjectBehavior!.addCollisionForItems(items: [ballView!]);
        //刚出现的球已经被推出，所以需要移除
        ballView?.firstPushBallDown = true
        currentNumberOfBalls += 1
    }
    
    func addExtralBallIntoBehaviors()  {
        let extralBall:BallView = gameView!.ballsNeedPushAtStart.first!
        lazyInitBehaviors()
        initBallBehaviors()
        //向上推出，这样不必判断板子的位置
        extralBall.firstPushBallDown = false
        extralBall.pushAngle =  M_PI_4*(-3)
        extralBall.pushMagnitude = 2.8
        extralBall.breakObjectBehavior!.addPush(item:gameView!.ballsNeedPushAtStart.first!);
        gameView!.ballsNeedPushAtStart.removeFirst()

    }
    
    func addExtralBall()  {
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
        initBallBehaviors();
        let ballView:BallView = gameView!.ballsNeedPushAtStart.first!
        ballView.breakObjectBehavior!.addPush(item:ballView);
        gameView!.ballsNeedPushAtStart.removeFirst()
        currentNumberOfBalls = 1
        print("start.....")
    }
    
    func stopAnimator() {
        unInitBehavior()
    }
    
    func pauseAnimator()  {
        for balView in (gameView!.ballViews){
            dynamicBreakerAnimator!.removeBehavior(balView.breakObjectBehavior!)
        }
        dynamicBreakerAnimator!.removeAllBehaviors()

    }
    
    func addBundary(name:String,path:UIBezierPath) {
        for balView in (gameView!.ballViews){
            balView.breakObjectBehavior?.removeBundry(name:name as NSCopying)
            balView.breakObjectBehavior?.addBundry(name: name as NSCopying, path: path)
        }
    }
    
    func  startPushing() {
        let ball:BallView? = ballsReadyToPush.first
        if ball != nil {
            if ball!.touchedPaddle{
                if((ball?.firstPushBallDown)! == false && (ball?.pushAngle)! > Double(0)){
                    //手指下滑时什么也不做
                    return
                }
                ball!.breakObjectBehavior?.addPush(item: ball!);
                ball!.touchedPaddle = false
                let delayTime = DispatchTime.now() + 0.3
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                    let index:Int? = self.ballsReadyToPush.index(of: ball!)
                    if(index != nil){
                        self.ballsReadyToPush.remove(at: index!)
                    }
                })
            }
        }
        
        //加入第二个球.第三个
        if (currentNumberOfBalls < numberOfBallsInDifferentLevel) {
            print("currentBall\(currentNumberOfBalls)-->totalBall\(numberOfBallsInDifferentLevel)")
            addExtralBall()
//            gameView?.paddleSize = CGSize(width: 160, height: (gameView?.paddleSize.height)!)
    
        }
        
        
    }
    
    func smallPush()  {
        let ball:BallView? = ballsReadyToPush.first
        ball?.pushAngle = -M_PI_4
        ball?.pushMagnitude = 0.8
        ball?.breakObjectBehavior?.addPush(item: ball!);
        ball?.firstPushBallDown = false
        //加入第二个球.第三个
        //加入第二个球.第三个
        if (currentNumberOfBalls < numberOfBallsInDifferentLevel) {
//            print("currentBall\(currentNumberOfBalls)-->totalBall\(numberOfBallsInDifferentLevel)")
//            addExtralBall()
//            gameView?.paddleSize = CGSize(width: 160, height: (gameView?.paddleSize.height)!)

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
                smallPush()
                print("push了一次")
            }
            print("TouchPaddle:\(touchedPaddle)")
        }
    }
}
