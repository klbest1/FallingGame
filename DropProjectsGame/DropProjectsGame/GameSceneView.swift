//
//  GameSceneView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/8.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit


class GameSceneView: BaseView,UICollisionBehaviorDelegate {

    
    /*-------初始化------*/
    override init(frame: CGRect) {
        super.init(frame: frame)
        paddleSize = CGSize(width: 80, height: 20);

        self.addGestureRecognizer(panGuesture);
        let backGroundImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        backGroundImageView.image = UIImage(named: "Background_Diffuse")
//        backGroundImageView.backgroundColor = UIColor.colorFromRGB(rgbValue: 0xF1F3F7)
        self.addSubview(backGroundImageView)
        
        let originX = (self.width-self.paddleSize.width)/2.0
        let orignY = self.hight - 20-self.paddleSize.height;
        let origin =  CGPoint(x:originX,y:orignY)
        paddleView = UIView(frame:CGRect(origin: origin, size: paddleSize));
        paddleView!.backgroundColor = UIColor.orange;
        
        self.addSubview(paddleView!)
        
        addBallView()
    }
    
    func resetPaddleView()  {
        let originX = (self.width-self.paddleSize.width)/2.0
        let orignY = self.hight - 20-self.paddleSize.height;
        let origin =  CGPoint(x:originX,y:orignY)
        paddleView?.frame.origin = origin
        let path:UIBezierPath = UIBezierPath.init(rect: paddleView!.frame);
        gameEngin.breakBehaviorDataSource!.addBundary(name: PathNames.paddleBundryName, path: path)
    }
    
    func  removeBallViews()  {
        for view:UIView in ballViews{
            view.removeFromSuperview()
        }
        ballViews.removeAll()
        ballsNeedPushAtStart.removeAll()
    }
    
    func removeChosedBallView(ballView:BallView)  {
        ballView.removeFromSuperview()
        ballViews.remove(at: ballViews.index(of: ballView)!)
    }
    
    func  addBallView()  {
        let  ballView:BallView = BallView(frame: CGRect(origin: CGPoint(x:self.width-BallSize.width/2 ,y:self.center.y - BallSize.width/2), size: CGSize(width: BallSize.width, height: BallSize.width)))
        ballViews.append(ballView)
        ballView.index = ballViews.index(of: ballView)
        ballsNeedPushAtStart.append(ballView)
        self.addSubview(ballView);
    }
    
    func addBallViewAtIndex(index:Int)  {
        let  ballView:BallView = BallView(frame: CGRect(origin: CGPoint(x:self.width-BallSize.width/2 ,y:self.center.y - BallSize.width/2), size: CGSize(width: BallSize.width, height: BallSize.width)))
        ballViews.insert(ballView, at: index)
        ballView.index = ballViews.index(of: ballView)
        ballsNeedPushAtStart.append(ballView)
        self.addSubview(ballView);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*-----------类变量------------*/
    let gameEngin:GameEngine = GameEngine.share
    var animate:Bool = false{
        didSet{
            if animate {
                gameEngin.gameStart(withReferenceView: self)
            }else{
                gameEngin.gameStop()
            }
        }
    }
    
    var panGuesture:UIPanGestureRecognizer{
        let pan :UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handPan(_:)))
        return pan
    }
    
   
    
    var paddleSize:CGSize!{
        didSet{
            paddleView?.frame.size = paddleSize
            print(paddleSize)
        }
    }
    
    var yFingerMovingDistance:Double = 0
    
    var paddleView:UIView? = nil;
    
    public var ballViews:[BallView] = [BallView]()
    public var ballsNeedPushAtStart:[BallView] = [BallView]()

    /*------------方法-------------*/
    
    override func layoutSubviews() {
     super.layoutSubviews()
      
    }
    //200 45du
    // X /200
    // x < 1 :PI/4 + (200 - x)/200 * (PI/4) =
    // > 1 :PI/4  - x / 200  * 0.008
    
    func handPan(_ sender:UIPanGestureRecognizer)  {
       
        let state = sender.state;
        let touchPoint:CGPoint = sender.location(in: self);
        var lastPoint:CGPoint = CGPoint.zero
        var fistPoint:CGPoint? = gameEngin.breakBehaviorDataSource?.ballsReadyToPush.first?.center
        switch state {
        case .began:
            fistPoint = touchPoint;
            break;
        case .changed:
            lastPoint = touchPoint;
          
             //计算PaddleView的x轴移动位置
            var touchX:CGFloat = touchPoint.x;
            if touchX < paddleSize.width / 2 {
                touchX = paddleSize.width/2;
            }
            if touchX > self.width - paddleSize.width/2 {
                touchX = self.width - paddleSize.width/2
            }
            paddleView!.center = CGPoint(x: touchX, y: paddleView!.center.y);
            
            let path:UIBezierPath = UIBezierPath.init(rect: paddleView!.frame);
            gameEngin.breakBehaviorDataSource!.addBundary(name: PathNames.paddleBundryName, path: path)
            
            //计算球弹出的角度及强度
            if (gameEngin.breakBehaviorDataSource?.ballsReadyToPush.count)! > 0{
                let ballWillPush:BallView = (gameEngin.breakBehaviorDataSource?.ballsReadyToPush.first)! as BallView
                //计算手指移动的距离
                yFingerMovingDistance = fabs(Double(lastPoint.y - fistPoint!.y))
                let velocity = sender.velocity(in: self)
                ballWillPush.pushAngle = checkAngle(firstPoint: fistPoint!, lastPoint: lastPoint)
                ballWillPush.pushMagnitude = checkingSpeed(velocity: velocity)
                //            print("velocity:\(velocity)")
            }
          
            break;
        case .ended:
            if yFingerMovingDistance > 20  {
                gameEngin.breakBehaviorDataSource?.startPushing()
                yFingerMovingDistance = 0;
            }
        default:
            break;
        }
    }
    
    func checkingAngle(velocity:CGPoint) -> Double{
        let velocityX = fabs(velocity.x)
        let propotion  = velocityX / 200;
        var angle = 0.0;
        if propotion > 1 {
            angle = M_PI/4  - Double(propotion * 0.008);
        }else{
            let rest = 200 - velocityX;
            angle = M_PI/4 + Double(rest/200)*M_PI/4
        }
        
        if velocity.x > 0{
           angle =  M_PI_2 + angle
        }
        return -angle
    }
    
    func checkingSpeed(velocity:CGPoint) -> CGFloat{
        let velocityX = fabs(velocity.y)
        let propotion  = velocityX / 200;
        var speed:CGFloat = 0.0;
        if propotion > 1 {
            speed = fabs(velocity.y/200) * 0.01 +  3;
        }else{
            speed = 3 * fabs(velocity.y/200) * 0.01
        }
        
//        print("speed:\(speed)")
        return speed
    }
    
    func checkAngle(firstPoint:CGPoint , lastPoint:CGPoint) -> Double{
        let yDistance = Double(lastPoint.y - firstPoint.y)
        let xDistance = Double(lastPoint.x - firstPoint.x)
        let angle = atan2(yDistance, xDistance)
//        print("angle:\(angle/M_PI * 180)")
        return angle
    }

    
    func viewDisappedAnimation( view:UIView,animationCompletion:  @escaping ((_ finish:Bool)->())){
        UIView.animate(withDuration: 0.5, delay: 0, options:[.curveEaseOut], animations: {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(M_2_PI))
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: {_ in
            animationCompletion(true)
            view.removeFromSuperview()
        })
    }

}
