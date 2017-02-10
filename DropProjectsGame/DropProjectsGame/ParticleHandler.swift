//
//  ParticleHandler.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/10.
//  Copyright © 2017年 lin kang. All rights reserved.
//  分数没刷新，初次碰撞有问题

import UIKit

class ParticleHandler: NSObject {
//    var emitters:[CAEmitterLayer] = [CAEmitterLayer]()
    
    func addExplodeEmitter(destiantionView:UIView,location:CGPoint,color:CGColor)  {
        let emitter: CAEmitterLayer  = destiantionView.createExplode(location: location,color:color)
        emitter.birthRate = 1
        let deadlineTime = DispatchTime.now() + .milliseconds(80)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            emitter.birthRate = 0
        }
//        self.perform(#selector(stopEmitter(_ :)), with: emitter, afterDelay: 0.3)
//        print(location)
    }
    
    func stopEmitter(_ sender:CAEmitterLayer)  {
//        print(sender)
        sender.birthRate = 0
    }
}
