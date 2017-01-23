//
//  GameSceneView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/8.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit


class GameSceneView: UIView,UICollisionBehaviorDelegate {
    /*------常量-----------*/
    struct  BallSize {
        //代替define
        static let width:CGFloat = 60
    }
    
    struct PathNames{
        static let paddleBundryName = "paddleName"
        static let ballBundaryName = "ballViewName"
    }
    
   /*----------end----------*/
    
    
    /*-------初始化------*/
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(panGuesture);
        
        let originX = (self.width-self.paddleSize.width)/2.0
        let orignY = self.hight - 20-self.paddleSize.height;
        let origin =  CGPoint(x:originX,y:orignY)
        paddleView = UIView(frame:CGRect(origin: origin, size: paddleSize));
        paddleView!.backgroundColor = UIColor.orange;
        
        self.addSubview(paddleView!)
        
        addBallView()
    }
    
    func  addBallView()  {
        if ballView == nil {
            ballView = BallView()
            ballView?.backgroundColor = UIColor.white
        }
        ballView!.frame = CGRect(origin: CGPoint(x:self.width-BallSize.width ,y:self.center.y - BallSize.width/2), size: CGSize(width: BallSize.width, height: BallSize.width));
        self.addSubview(ballView!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*-----------类变量------------*/
    
    var animate:Bool = false{
        didSet{
            if animate {
              breakBehaviorDataSource.startAnimator()
              fallingBehaviorDataSource.startAnimator()
            }else{
                breakBehaviorDataSource.stopAnimator();
                fallingBehaviorDataSource.stopAnimator()
            }
        }
    }
    
    var panGuesture:UIPanGestureRecognizer{
        let pan :UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handPan(_:)))
        return pan
    }
    
    var width:CGFloat {
        return self.frame.size.width
    }
    var hight:CGFloat{
        return self.frame.size.height;
    }
    
    var paddleSize:CGSize{
        let size = CGSize(width: 80, height: 20);
        return size;
    }
    
    
    var paddleView:UIView? = nil;
    
    var ballView:BallView?
    
    lazy var breakBehaviorDataSource:BreakBehaviorDataSource = BreakBehaviorDataSource(referenceView:self);
    lazy var fallingBehaviorDataSource:FallingObjectDatasource = FallingObjectDatasource(referenceView: self)

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
        switch state {
        case .began:
            break;
        case .changed:
            var touchX:CGFloat = touchPoint.x;
            if touchX < paddleSize.width / 2 {
                touchX = paddleSize.width/2;
            }
            if touchX > self.width - paddleSize.width/2 {
                touchX = self.width - paddleSize.width/2
            }
            paddleView!.center = CGPoint(x: touchX, y: paddleView!.center.y);
            
            let path:UIBezierPath = UIBezierPath.init(rect: paddleView!.frame);
            breakBehaviorDataSource.addBundary(name: PathNames.paddleBundryName, path: path)
            //   print("volocity:\(sender.velocity(in: self))")
            breakBehaviorDataSource.pushAngle = checkingAngle(velocity: sender.velocity(in: self))

            break;
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
    //笔记
    func viewDisappedAnimation( view:UIView,animationCompletion:  @escaping ((_ finish:Bool)->())){
        UIView.animate(withDuration: 0.5, delay: 0, options:[ .curveEaseOut], animations: {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(M_2_PI))
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: {_ in
            animationCompletion(true)
            view.removeFromSuperview()
        })
    }

}
