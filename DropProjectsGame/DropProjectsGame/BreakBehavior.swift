//
//  BreakBehavior.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/8.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class BreakBehavior: UIDynamicBehavior {
//    var pushBehavior:UIPushBehavior? = nil
    

    var collisionBehavior:UICollisionBehavior = {
        let collision = UICollisionBehavior();
        collision.translatesReferenceBoundsIntoBoundary = true;
        return collision;
    }()
    
    let dynamicItemBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior()

    var gravityBehavior:UIGravityBehavior = {
        let gravity = UIGravityBehavior();
        return gravity;
    }();
    
    override init(){
        super.init();
        self.addChildBehavior(collisionBehavior)
        self.addChildBehavior(gravityBehavior)
        self.addChildBehavior(dynamicItemBehavior)
        dynamicItemBehavior.allowsRotation = true
        dynamicItemBehavior.elasticity = 0.8

    }
    
    func addPush(item:BallView) {
//        print("angle:\(angle)")
        if(item.pushBehavior != nil){
            self.removeChildBehavior(item.pushBehavior!);
            item.pushBehavior = nil
        }
        item.pushBehavior = UIPushBehavior(items: [item], mode: UIPushBehaviorMode.instantaneous)
        self.addChildBehavior(item.pushBehavior!)
        
        item.pushBehavior?.magnitude = item.pushMagnitude;
        item.pushBehavior!.angle = CGFloat(item.pushAngle);
        //笔记，区别
        item.pushBehavior!.action = { [unowned self] in
            if(item.pushBehavior != nil){
                if(!item.pushBehavior!.active){
                    item.pushBehavior?.removeItem(item)
                    self.removeChildBehavior(item.pushBehavior!);
                    item.pushBehavior = nil
                }
                
            }
        }
    }
    
    func addCollisionForItems(items:[UIView]) {
        for item in items{
            collisionBehavior.addItem(item);
            gravityBehavior.addItem(item)
        }
    }
    
    func removeItemsFromBehaviors(){
        var items = NSArray().addingObjects(from: collisionBehavior.items);
        for item in items{
            collisionBehavior.removeItem(item as! UIDynamicItem)
        }
        
        items = NSArray().addingObjects(from: gravityBehavior.items);
        for item in items{
            gravityBehavior.removeItem(item as! UIDynamicItem)
        }
      
    }
    
    
    func addBundry(name:NSCopying, path:UIBezierPath)  {
//        collisionBehavior.removeAllBoundaries();
        collisionBehavior.addBoundary(withIdentifier: name, for: path);
    }
    
    func removeBundry(name:NSCopying) {
        collisionBehavior.removeAllBoundaries();

    }
    
    func setfallingSpeed(speed:Float) {
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy:CGFloat(defaultYspeedItem*speed))
    }
}

