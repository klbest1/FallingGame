//
//  FallingObjectDatasource.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/12.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class FallingObjectDatasource: NSObject,UICollisionBehaviorDelegate {
    private var sceneWidth:CGFloat = 0
    private var sceneHight:CGFloat = 0
    private var gameView:GameSceneView? = nil
    private var dropTimer:Timer?
    private var dropSize:CGSize?
    private var dynamicAnimator :UIDynamicAnimator?

    public var numberOfDrops:Int = 400;
    public var numberOfDropsPerRow = 10;
    public var drops:[UIView] = [UIView]()
    public let fallingObjectBehavior = FallingObjectBehavior()
    
    init(referenceView:GameSceneView) {
        super.init()
        sceneWidth = referenceView.frame.size.width;
        sceneHight = referenceView.frame.size.height;
        gameView = referenceView;
        dynamicAnimator  = UIDynamicAnimator(referenceView: gameView!)

        dropSize = CGSize(width: sceneWidth/CGFloat(numberOfDropsPerRow), height:  sceneWidth/CGFloat(numberOfDropsPerRow))
        fallingObjectBehavior.gravityBehavior.action = {
            self.fallingObjectBehavior.removeBundry()
            let path = UIBezierPath(ovalIn: referenceView.ballView!.frame);
            self.fallingObjectBehavior.addBundry(name: GameSceneView.PathNames.ballBundaryName as NSCopying, path: path)
//            self.numberOfDrops = 
        }
    }
    
    
    func addDrops()  {
        var randomsLocation:[Int] = [CGFloat.random(max: numberOfDropsPerRow)]
        var i = 0
        while ( i < 5) {
            i += 1;
            let number = CGFloat.random(max: numberOfDropsPerRow);
            if(!randomsLocation.contains(number)){
                randomsLocation.append(number);
            }
        }
        
        for location in randomsLocation{
            let orignX:CGFloat = (dropSize?.width)! * CGFloat( location )
            let drop:UIView =  UIView(frame: CGRect(origin: CGPoint(x:orignX,y:0), size: dropSize!))
            drop.layer.borderWidth = 2;
            drop.layer.borderColor = UIColor.color.cgColor;
            gameView?.addSubview(drop)
            drops.append(drop);
        }
        fallingObjectBehavior.addItems(items: drops)
        
        if dropTimer == nil{
            dropTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addDrops), userInfo: nil, repeats: true);
        }
        self.perform(#selector(stopDrops), with: nil, afterDelay: 1)
    }
    
    func stopDrops()  {
        fallingObjectBehavior.removeItems(items: drops)
    }
    
    
    func startAnimator()  {
        dynamicAnimator!.addBehavior(fallingObjectBehavior);
        fallingObjectBehavior.collisionBehavior.collisionDelegate = self;
        addDrops();
    }
    
    func stopAnimator() {
        dynamicAnimator!.removeAllBehaviors()
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?){
         if(identifier != nil) , identifier as! String == GameSceneView.PathNames.ballBundaryName{
            let toucheditem:UIView = item as! UIView
            toucheditem.backgroundColor = UIColor.red
            gameView?.viewDisappedAnimation(view: toucheditem, animationCompletion: { (value:Bool) in
                if(value){
                    if((self.drops.index(of:toucheditem)) != nil){
                        self.drops.remove(at: self.drops.index(of:toucheditem)!)
                    }
                    self.fallingObjectBehavior.removeItems(items: [toucheditem])
                }
            })
        }
    }

    
}
