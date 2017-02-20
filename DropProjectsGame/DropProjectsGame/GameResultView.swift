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
    public var weiChatLoginButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backGroundView = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        backGroundView.alpha = 0.6
        backGroundView.backgroundColor = UIColor.lightGray
        self.addSubview(backGroundView)
        
        let contentView:UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true;
        contentView.center = self.center;
        self.addSubview(contentView)
        
        let titleLable:UILabel = UILabel(frame: CGRect(origin: CGPoint(x:0,y:20), size: CGSize(width: 200, height: 30)));
            titleLable.textAlignment = .center
        //Game Over!😭
        titleLable.font = UIFont(name: "Damascus", size: 26)
        titleLable.text = "Game Over!😭"
        titleLable.textAlignment = .center
        
        let hintScoreLabel:UILabel = UILabel(frame: CGRect(origin: CGPoint(x:0,y:titleLable.frame.maxY ), size: CGSize(width: 200, height: 21)));
        hintScoreLabel.text = "游戏得分:";
        hintScoreLabel.textAlignment = .center
        hintScoreLabel.font = UIFont.systemFont(ofSize: 21)
        hintScoreLabel.textColor = UIColor.brown
        
        resetButton = UIButton(frame: CGRect(origin: CGPoint(x:frame.origin.x + 30,y:contentView.frame.size.height - 50), size: CGSize(width: 40, height: 36)))
        resetButton.setBackgroundImage(UIImage(named:"refresh.png"), for: .normal)
        
        randButton = UIButton(frame: CGRect(origin: CGPoint(x:contentView.frame.size.width - 60 - 30,y:contentView.frame.size.height - 50), size: CGSize(width: 60, height: 36)))
        randButton.setTitle("排名", for: .normal)
        randButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        gameScoreLabel = UILabel(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 40, height: 21)));
        gameScoreLabel.textColor = UIColor.black
        gameScoreLabel.textAlignment = .center
        gameScoreLabel.font = UIFont.systemFont(ofSize: 21);
        gameScoreLabel.center = CGPoint(x:contentView.frame.size.width/2,y:contentView.frame.size.height/2);
        
        weiChatLoginButton = UIButton(frame: CGRect(origin: CGPoint(x:resetButton.frame.maxX + 10,y:contentView.frame.size.height - 50), size: CGSize(width: 40, height: 40)))
        weiChatLoginButton.setTitle("微信", for: .normal)
        weiChatLoginButton.setTitleColor(UIColor.black, for: .normal)
        
        contentView.addSubview(hintScoreLabel)
        contentView.addSubview(titleLable)
        contentView.addSubview(resetButton)
        contentView.addSubview(randButton)
        contentView.addSubview(gameScoreLabel)
        contentView.addSubview(weiChatLoginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
