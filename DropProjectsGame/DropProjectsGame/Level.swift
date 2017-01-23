//
//  Level.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/22.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

@objc(Level)
class Level: NSObject {
    var backGroundMusic:String?
    var backGroundImageUrl:String?
    var level:NSNumber?
    var numberOfBalls:NSNumber?
    var numberOfDrops:NSNumber?
    var fallingSpeed:NSNumber?
    var scoreGoal:NSNumber?
}
