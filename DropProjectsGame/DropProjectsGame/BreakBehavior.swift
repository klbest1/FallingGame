//
//  BreakBehavior.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/8.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class BreakBehavior: UIDynamicBehavior {
    var pushBehavior:UIPushBehavior? = nil
    

    var collisionBehavior:UICollisionBehavior = {
        let collision = UICollisionBehavior();
        collision.translatesReferenceBoundsIntoBoundary = true;
        return collision;
    }()
    

    var gravityBehavior:UIGravityBehavior = {
        let gravity = UIGravityBehavior();
        print("1一次")
        return gravity;
    }();
    
    override init(){
        super.init();
        self.addChildBehavior(collisionBehavior)
        self.addChildBehavior(gravityBehavior)
       
    }
    
    func addPush(item:UIView,angle:Double,magnitude:CGFloat) {
//        print("angle:\(angle)")
        if(pushBehavior != nil){
            self.removeChildBehavior(self.pushBehavior!);
            self.pushBehavior = nil
        }
        pushBehavior = UIPushBehavior(items: [item], mode: UIPushBehaviorMode.instantaneous)
        self.addChildBehavior(pushBehavior!)
        
        pushBehavior?.magnitude = magnitude;
        pushBehavior!.angle = CGFloat(angle);
        //笔记，区别
        pushBehavior!.action = { [unowned self] in
            if(self.pushBehavior != nil){
                if(!self.pushBehavior!.active){
                    self.pushBehavior?.removeItem(item)
                    self.removeChildBehavior(self.pushBehavior!);
                    self.pushBehavior = nil
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
}

