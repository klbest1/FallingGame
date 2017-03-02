//
//  FallingObjectDatasource.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/12.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

struct FallingDropSetting {
    var numberOfDrops:Int?
    var fallingSpeed:Float?
}

protocol FallingObjectDatasourceDelegate:class{
    func didScoreChanged(sender:UIDynamicItem , aScore:Int)
    func didCollisionWithTheBottomBundary(sender:FallingObjectDatasource)
}

private let randomDropsPerRow = 5

class FallingObjectDatasource: NSObject,UICollisionBehaviorDelegate {
    private var sceneWidth:CGFloat = 0
    private var sceneHight:CGFloat = 0
    private var gameView:GameSceneView? = nil
    private var dropTimer:Timer?
    private var dropSize:CGSize?
    private var dynamicAnimator :UIDynamicAnimator?
    private var totalDrops:Int = 0
    
    private var numberOfDrops:Int = 400;
    private var fallingSpeed:Float = 0
    public var numberOfDropsPerRow = 10;
    public var drops:[UIView] = [UIView]()
    public var fallingObjectBehavior:FallingObjectBehavior?
    private var fallingSetting:FallingDropSetting!
    private var currentScore:Int = 0
    
    public weak var delegate:FallingObjectDatasourceDelegate?
    
    init(referenceView:GameSceneView, fallingDropsSetting:FallingDropSetting) {
        super.init()
        sceneWidth = referenceView.frame.size.width;
        sceneHight = referenceView.frame.size.height;
        print("sceneHight:\(sceneHight)")
        gameView = referenceView;
        dynamicAnimator  = UIDynamicAnimator(referenceView: gameView!)
        
        dropSize = CGSize(width: sceneWidth/CGFloat(numberOfDropsPerRow), height:  sceneWidth/CGFloat(numberOfDropsPerRow))
        
//431 - 40 - 38  353
        //设定下落球的总数
        numberOfDrops = fallingDropsSetting.numberOfDrops!
        fallingSetting = fallingDropsSetting
    }
    
    func lazyInitBehavior()  {
      
        
        let behavior:FallingObjectBehavior = FallingObjectBehavior()
        behavior.collisionBehavior.collisionDelegate = self;
        //设定球下落的速度
        behavior.setfallingSpeed(speed: fallingSetting.fallingSpeed!)
        behavior.gravityBehavior.action = {[unowned self] in
            behavior.removeBundry()
            //把所有的球加入边界
            for  ballView:BallView in (self.gameView?.ballViews)!{
                let path = UIBezierPath(ovalIn: ballView.frame);
                let ballBudayName = String(format: "%@_%d", PathNames.ballBundaryName,(self.gameView?.ballViews.index(of: ballView))!)
                behavior.addBundry(name:ballBudayName as NSCopying, path: path)
            }
            for  dropItem in self.drops{
                if (dropItem as UIView).frame.origin.y > (self.sceneHight - (self.gameView?.paddleSize.height)! - 20 - (self.dropSize?.height)!) {
                    print("到达底边界！\((dropItem as UIView).frame)")
                    self.delegate?.didCollisionWithTheBottomBundary(sender: self)
                    break;
                }
            }
        }
        
        fallingObjectBehavior = behavior
    }
    
    func  unInitBehavior()  {
        fallingObjectBehavior?.removeItems(items: drops)
        fallingObjectBehavior?.removeChildBehavior(fallingObjectBehavior!.collisionBehavior)
        fallingObjectBehavior?.removeChildBehavior(fallingObjectBehavior!.gravityBehavior)
        fallingObjectBehavior?.removeChildBehavior(fallingObjectBehavior!.dynamicItemBehavior)
        fallingObjectBehavior = nil
    }
    
    func addDrops()  {
        var randomsLocation:[Int] = [CGFloat.random(max: numberOfDropsPerRow)]
        var i = 0
        while ( i < randomDropsPerRow) {
            i += 1;
            let number = CGFloat.random(max: numberOfDropsPerRow);
            if(!randomsLocation.contains(number)){
                randomsLocation.append(number);
            }
        }

        if self.numberOfDrops == totalDrops {
            dropTimer?.invalidate()
            return
        }
        
        for location in randomsLocation{
            let orignX:CGFloat = (dropSize?.width)! * CGFloat( location )
            let drop:UIView =  Drop(frame: CGRect(origin: CGPoint(x:orignX,y:0), size: dropSize!))
            drop.layer.borderWidth = 2;
            drop.layer.borderColor = UIColor.color.cgColor;
            gameView?.addSubview(drop)
            drops.append(drop);
        }
        fallingObjectBehavior!.addItems(items: drops)
        
        //统计产生的Drops
        totalDrops += randomDropsPerRow

        if dropTimer == nil{
            dropTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addDrops), userInfo: nil, repeats: true);
        }
        self.perform(#selector(removeDropsFromBehaviorForInstantStop), with: nil, afterDelay: 1)
    }
    
    //暂停 方块移动
    func removeDropsFromBehaviorForInstantStop()  {
        fallingObjectBehavior?.removeItems(items: drops)
    }
    
    func pauseDrops()  {
        dropTimer?.invalidate()
        dropTimer = nil
        removeDropsFromBehaviorForInstantStop()
    }
    
    //开始游戏
    func startAnimator()  {
        lazyInitBehavior()
        dynamicAnimator!.addBehavior(fallingObjectBehavior!);
        addDrops();
    }
    
    //停止所有的移动包括重力，碰撞，等
    func stopAnimator() {
        dropTimer?.invalidate()
        dropTimer = nil
        dynamicAnimator!.removeAllBehaviors()
        unInitBehavior()
    }
    
    /*刷新游戏*/
    func resetAnimator() {
        for  item in drops{
            item.removeFromSuperview()
        }
        drops.removeAll()
        totalDrops = 0;
        startAnimator()
    }
   
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier:  NSCopying?){
         if(identifier != nil) , (identifier as! String).hasPrefix(PathNames.ballBundaryName) {
            let toucheditem:Drop = item as! Drop
            //保证只执行一次
            toucheditem.backgroundColor = UIColor.init(cgColor: toucheditem.layer.borderColor!)
            if((self.drops.index(of:toucheditem)) != nil){
                self.drops.remove(at: self.drops.index(of:toucheditem)!)
            }
            self.fallingObjectBehavior?.removeItems(items: [toucheditem])
            gameView?.viewDisappedAnimation(view: toucheditem, animationCompletion: { (value:Bool) in
            })
            let score:Int = self.totalDrops - self.drops.count
            if(score != self.currentScore){
                self.currentScore = score
                self.delegate?.didScoreChanged(sender: item, aScore:self.currentScore)
                
            }
            
         }
    }

    
}
