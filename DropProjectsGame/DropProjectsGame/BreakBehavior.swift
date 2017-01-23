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
        return gravity;
    }();
    
    override init(){
        super.init();
        self.addChildBehavior(collisionBehavior)
        self.addChildBehavior(gravityBehavior)
       
    }
    
    func addPush(item:UIView,angle:Double) {
        print("angle:\(angle)")
        if pushBehavior == nil {
            pushBehavior = UIPushBehavior(items: [item], mode: UIPushBehaviorMode.instantaneous)
            self.addChildBehavior(pushBehavior!)
        }
        pushBehavior?.magnitude = 3;
        pushBehavior!.angle = CGFloat(angle);
        pushBehavior!.action = { [unowned self] in
            if(!self.pushBehavior!.active){
                self.removeChildBehavior(self.pushBehavior!);
                self.pushBehavior = nil
            }
        }
    }
    
    func addCollisionForItems(items:[UIView]) {
        for item in items{
            collisionBehavior.addItem(item);
            gravityBehavior.addItem(item)
        }
    }
    
    func removeItemsFromGravityCollision(){
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
