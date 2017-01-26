//
//  FallingObjectBehavior.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/12.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

let defaultYspeedItem:Float = 0.04

class FallingObjectBehavior: UIDynamicBehavior {
    
    var ySpeed:Float = 1.0
    let gravityBehavior:UIGravityBehavior = UIGravityBehavior();
    let collisionBehavior:UICollisionBehavior = UICollisionBehavior()
    let dynamicItemBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior()
    
    override init() {
        super.init()
        self.addChildBehavior(gravityBehavior)
        self.addChildBehavior(collisionBehavior)
        self.addChildBehavior(dynamicItemBehavior)
        gravityBehavior.magnitude = 4;
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy:CGFloat(defaultYspeedItem*ySpeed))
//        dynamicItemBehavior.allowsRotation = true
//        dynamicItemBehavior.elasticity = 0.4
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true;
    }
    
    func addItems(items:[UIView])  {
        for item in items{
            gravityBehavior.addItem(item);
            dynamicItemBehavior.addItem(item)
            collisionBehavior.addItem(item)
        }
    }
    
    func removeItems(items:[UIView])  {
        for item in items{
            gravityBehavior.removeItem(item);
            dynamicItemBehavior.removeItem(item)
            collisionBehavior.removeItem(item)
        }
    }
    
    func addBundry(name:NSCopying , path:UIBezierPath)  {
        collisionBehavior.addBoundary(withIdentifier: name, for: path)
    }
    func removeBundry( )  {
        collisionBehavior.removeAllBoundaries()
    }
    
    func setfallingSpeed(speed:Float) {
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy:CGFloat(defaultYspeedItem*speed))
    }
}
