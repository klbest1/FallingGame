//
//  BallView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/8.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

/*------常量-----------*/
struct  BallSize {
    //代替define
    static let width:CGFloat = 60
}

class BallView: UIView {
    
    var touchedPaddle = false
    var pushAngle:Double = M_PI_4*3
    var pushMagnitude:CGFloat = 1.8
    var firstPushBallDown:Bool = false
    var pushBehavior:UIPushBehavior? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = BallSize.width/2;
        self.layer.masksToBounds = true;
        self.backgroundColor = UIColor.white
        
        let backGroundView =  UIImageView(image: UIImage.init(named: "ball.png"))
        backGroundView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.size.width + 3, height:  frame.size.height + 3))
        self.addSubview(backGroundView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect);
        path.stroke();
    }

}
