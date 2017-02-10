//
//  GameScoreView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/7.
//  Copyright © 2017年 lin kang. All rights reserved.
//
/*
 hese are the steps to add a custom font to you application:
 
 Add "gameOver.ttf" font in your application ( Make sure that it's included in the target)
 Modify the application-info.plist file.
 Add the key "Fonts provided by application" in a new row
 and add "gameOver.ttf" as new item in the Array "Fonts provided by application".
 Now the font will be available in Interface Builder. To use the custom font in code we need to refer to it by name, but the name often isn’t the same as the font’s filename
 
 There are 2 ways to find the name:
 
 Install the font on your Mac. Open Font Book, open the font and see what name is listed.
 Programmatically list the available fonts in your app
*/

import UIKit

class GameScoreView: UIView {
    var showLevelLabel:UILabel = UILabel()
    var showCurrentScoreHintLabel:UILabel = UILabel()
    var showCurrentScoreLabel:UILabel = UILabel()
    var showGoalScoreHintLabel:UILabel = UILabel()
    var showGoalScoreLabel:UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.alpha = 0
        let contentView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.size.width, height: frame.size.height)))
        self.addSubview(contentView)
         //44
        showCurrentScoreHintLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 16));
        showCurrentScoreHintLabel.textAlignment = .center
        showCurrentScoreHintLabel.font = UIFont.init(name: "HYXueFengF", size: 16)
//        showCurrentScoreHintLabel.textColor = UIColor.orange
        showCurrentScoreHintLabel.textColor = UIColor.white

        showCurrentScoreHintLabel.text = "当前分"
        showCurrentScoreHintLabel.center = CGPoint(x:contentView.center.x,y:7)
        
        showCurrentScoreLabel.frame = CGRect(origin: CGPoint(x:showCurrentScoreHintLabel.frame.minX,y:showCurrentScoreHintLabel.frame.maxY + 5), size: CGSize(width: 50, height: 16));
        showCurrentScoreLabel.textAlignment = .center
        showCurrentScoreLabel.font = UIFont.init(name: "HYXueFengF", size: 16)
//        showCurrentScoreLabel.textColor = UIColor.orange
        showCurrentScoreLabel.textColor = UIColor.white
        showCurrentScoreLabel.textAlignment = .center
        
        showGoalScoreHintLabel.frame = CGRect(origin: CGPoint(x:showCurrentScoreHintLabel.frame.minX -  80 - 20,y:showCurrentScoreHintLabel.frame.minY), size: CGSize(width: 50, height: 16));
        showGoalScoreHintLabel.textAlignment = .center
        showGoalScoreHintLabel.font = UIFont.init(name: "HYXueFengF", size: 16)
//        showGoalScoreHintLabel.textColor = UIColor.purple
        showGoalScoreHintLabel.textColor = UIColor.white
        showGoalScoreHintLabel.text = "目标分"
        
        showGoalScoreLabel.frame = CGRect(origin: CGPoint(x:showGoalScoreHintLabel.frame.minX ,y:showCurrentScoreLabel.frame.minY), size: CGSize(width: 50, height: 16));
        showGoalScoreLabel.textAlignment = .center
        showGoalScoreLabel.font = UIFont.init(name: "HYXueFengF", size: 16)
//        showGoalScoreLabel.textColor = UIColor.purple
        showGoalScoreLabel.textColor = UIColor.white

        
        showLevelLabel.frame = CGRect(origin: CGPoint(x:showCurrentScoreLabel.frame.maxX + 10,y:showGoalScoreHintLabel.frame.minY), size: CGSize(width: 60, height: 16));
        showLevelLabel.textAlignment = .center
        showLevelLabel.font = UIFont.init(name: "HYXueFengF", size: 16)
//        showLevelLabel.textColor = UIColor.brown
        showLevelLabel.textColor = UIColor.white
//        showLevelLabel.center = CGPoint(x:showLevelLabel.frame.midX,y:contentView.center.y)
       
        
        contentView.addSubview(showLevelLabel)
        contentView.addSubview(showCurrentScoreHintLabel)
        contentView.addSubview(showCurrentScoreLabel)
        contentView.addSubview(showGoalScoreHintLabel)
        contentView.addSubview(showGoalScoreLabel)
    }
    
    func showScoreBarWithCurrentLevel(level:Int,currentScore:Int,golaScore:Int)  {
        showLevelLabel.text = String(format: "关卡 %d", arguments: [level])
        showCurrentScoreLabel.text = String(format: "%d", arguments: [currentScore])
        showGoalScoreLabel.text = String(format: "%d", arguments: [golaScore])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
