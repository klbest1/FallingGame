//
//  UIkit Extension.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/12.
//  Copyright © 2017年 lin kang. All rights reserved.
//$$$$$$$$$$$$

import UIKit

extension CGFloat {
    static func random(max:Int) -> Int{
        let randomNumber = arc4random() % UInt32(max)
        return Int(randomNumber);
    }
}

extension UIColor{
    static var color:UIColor  {
        let random = arc4random() % 6;
        switch random {
        case 0:
            return UIColor.black
        case 1:
            return UIColor.brown
        case 2:
            return UIColor.red
        case 3:
           return UIColor.yellow
        case 4:
            return UIColor.magenta
        case 5:
            return UIColor.purple
        default:
            return UIColor.purple
        }
    };
}

extension UIView{
    static var screenWidth:CGFloat{
        return UIScreen.main.bounds.width
    }
    
    static var screenHight:CGFloat{
        return UIScreen.main.bounds.height
    }
    

     func createExplode()->CAEmitterLayer{
        let expodeEmitter = CAEmitterLayer()
        expodeEmitter.position = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        print(expodeEmitter.position)
        expodeEmitter.emitterSize = CGSize(width: self.frame.size.width, height: 0)
        expodeEmitter.emitterMode = kCAEmitterLayerPoints
        expodeEmitter.emitterShape	= kCAEmitterLayerLine;
        expodeEmitter.renderMode		= kCAEmitterLayerAdditive;
        expodeEmitter.seed = (arc4random()%100)+1;
        expodeEmitter.birthRate = 0
        // Create the rocket
        let rocket:CAEmitterCell  = CAEmitterCell();
        //生成一颗
        rocket.birthRate		= 1.0;
        //散发的角度，圆锥体
        rocket.emissionRange	= 0.25 * CGFloat( M_PI );  // some variation in angle
        //速度
        rocket.velocity			= 0;
        //速度增减范围
        rocket.velocityRange	= 0;
        //y 加速度
        rocket.yAcceleration	= 75;
        //屏幕上存在的时间
        rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
        
        rocket.contents			= UIImage.init(named: "")?.cgImage;
        rocket.scale			= 0.2;
        rocket.color			= UIColor.red.cgColor;
        rocket.greenRange		= 1.0;		// different colors
        rocket.redRange			= 1.0;
        rocket.blueRange		= 1.0;
        rocket.spinRange		= CGFloat(M_PI);		// slow spin
        
        
        
        // the burst object cannot be seen, but will spawn the sparks
        // we change the color here, since the sparks inherit its value
        let burst: CAEmitterCell = CAEmitterCell();
        
        burst.birthRate			= 1.0;		// at the end of travel
        burst.velocity			= 0;
        burst.scale				= 2.0;
        burst.redSpeed			= -1.5;		// shifting
        burst.blueSpeed			= +1.5;		// shifting
        burst.greenSpeed		= +1.0;		// shifting
        burst.lifetime			= 0.35;
        
        // and finally, the sparks
        let spark:CAEmitterCell  = CAEmitterCell();
        
        spark.birthRate			= 40;
        spark.velocity			= 50;
        spark.emissionRange		= 2 * CGFloat(M_PI);	// 360 deg
        spark.yAcceleration		= 75;		// gravity
        spark.lifetime			= 0.5;
        
        spark.contents			= UIImage.init(named: "DazHeart")?.cgImage;
        spark.scaleSpeed		= -0.2;
        spark.greenSpeed		= -0.1;
        spark.redSpeed			=  0.4;
        spark.blueSpeed			= -0.1;
        spark.alphaSpeed		= -0.25;
        spark.spin				= 2 * CGFloat(M_PI);
        spark.spinRange			= 2 * CGFloat(M_PI);
        
        // putting it together
        expodeEmitter.emitterCells	= [rocket];
        rocket.emitterCells				= [ burst];
        burst.emitterCells				= [spark];
        self.layer.addSublayer(expodeEmitter)
        return expodeEmitter
    }
    
    func createExplode(location:CGPoint,color:CGColor)->CAEmitterLayer{
        let expodeEmitter = CAEmitterLayer()
        expodeEmitter.position = location
        print(expodeEmitter.position)
        expodeEmitter.emitterSize = CGSize(width: 20, height: 0)
        expodeEmitter.emitterMode = kCAEmitterLayerPoints
        expodeEmitter.emitterShape	= kCAEmitterLayerLine;
        expodeEmitter.renderMode		= kCAEmitterLayerAdditive;
        expodeEmitter.seed = (arc4random()%100)+1;
        expodeEmitter.birthRate = 0
        // Create the rocket
        let rocket:CAEmitterCell  = CAEmitterCell();
        //生成一颗
        rocket.birthRate		= 1.0;
        //散发的角度，圆锥体
        rocket.emissionRange	= 0.25 * CGFloat( M_PI );  // some variation in angle
        //速度
        rocket.velocity			= 0;
        //速度增减范围
        rocket.velocityRange	= 0;
        //y 加速度
        rocket.yAcceleration	= 75;
        //屏幕上存在的时间
        rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
        
        rocket.contents			= UIImage.init(named: "")?.cgImage;
        rocket.scale			= 0.2;
        rocket.color			= color;
//        rocket.greenRange		= 1.0;		// different colors
//        rocket.redRange			= 1.0;
//        rocket.blueRange		= 1.0;
        rocket.spinRange		= CGFloat(M_PI);		// slow spin
        
        
        
        // the burst object cannot be seen, but will spawn the sparks
        // we change the color here, since the sparks inherit its value
        let burst: CAEmitterCell = CAEmitterCell();
        
        burst.birthRate			= 1.0;		// at the end of travel
        burst.velocity			= 0;
        burst.scale				= 2.0;
        burst.color = color
//        burst.redSpeed			= -1.5;		// shifting
//        burst.blueSpeed			= +1.5;		// shifting
//        burst.greenSpeed		= +1.0;		// shifting
        burst.lifetime			= 0.35;
        
        // and finally, the sparks
        let spark:CAEmitterCell  = CAEmitterCell();
        
        spark.birthRate			= 40;
        spark.velocity			= 50;
        spark.emissionRange		= 2 * CGFloat(M_PI);	// 360 deg
        spark.yAcceleration		= 75;		// gravity
        spark.lifetime			= 0.5;
        
        spark.contents			= UIImage.init(named: "DazHeart")?.cgImage;
        spark.scaleSpeed		= -0.2;
        spark.color = color
//        spark.greenSpeed		= -0.1;
//        spark.redSpeed			=  0.4;
//        spark.blueSpeed			= -0.1;
        spark.alphaSpeed		= -0.25;
        spark.spin				= 2 * CGFloat(M_PI);
        spark.spinRange			= 2 * CGFloat(M_PI);
        
        // putting it together
        expodeEmitter.emitterCells	= [rocket];
        rocket.emitterCells				= [ burst];
        burst.emitterCells				= [spark];
        self.layer.addSublayer(expodeEmitter)
        return expodeEmitter
    }

    
    ///  填充子视图
    ///
    ///  - parameter referView: 参考视图
    ///  - parameter insets:    间距
    public func ff_Fill(_ referView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[subView]-\(insets.right)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: ["subView" : self])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[subView]-\(insets.bottom)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: ["subView" : self])
        
        superview?.addConstraints(cons)
        
        return cons
    }
}
