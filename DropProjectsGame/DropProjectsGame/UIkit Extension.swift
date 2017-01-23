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
}
