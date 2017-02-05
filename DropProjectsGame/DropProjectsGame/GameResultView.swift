//
//  GameResultView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/31.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class GameResultView: UIView {

    public var resetButton:UIButton!
    public var randButton:UIButton!
    public var gameScoreLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        self.alpha = 0.6
        let contentView:UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
        contentView.backgroundColor = UIColor.white
        contentView.center = self.center;
        self.addSubview(contentView)
        
        
        resetButton = UIButton(frame: CGRect(origin: CGPoint(x:frame.origin.x + 30,y:contentView.frame.size.height - 50), size: CGSize(width: 40, height: 36)))
        resetButton.setBackgroundImage(UIImage(named:"refresh.png"), for: .normal)
        
        randButton = UIButton(frame: CGRect(origin: CGPoint(x:contentView.frame.size.width - 60 - 30,y:contentView.frame.size.height - 50), size: CGSize(width: 60, height: 36)))
        randButton.setTitle("排名", for: .normal)
        randButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        gameScoreLabel = UILabel(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 40, height: 21)));
        gameScoreLabel.textColor = UIColor.red
        gameScoreLabel.font = UIFont.systemFont(ofSize: 21);
        gameScoreLabel.center = CGPoint(x:contentView.frame.size.width/2,y:contentView.frame.size.height/2);
        
        contentView.addSubview(resetButton)
        contentView.addSubview(randButton)
        contentView.addSubview(gameScoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
