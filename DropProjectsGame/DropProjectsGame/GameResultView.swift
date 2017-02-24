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
    var     activityView:UIActivityIndicatorView! = UIActivityIndicatorView()
    
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
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        self.addSubview(contentView)
        
        let titleLable:UILabel = UILabel(frame: CGRect(origin: CGPoint(x:0,y:20), size: CGSize(width: 200, height: 24)));
            titleLable.textAlignment = .center
        //Game Over!😭
        titleLable.font = UIFont(name: "HYo2gf", size: 22)
        titleLable.text = "Game Over!😎"
        titleLable.textAlignment = .center
        titleLable.textColor = UIColor.darkGray
        
        let hintScoreLabel:UILabel = UILabel(frame: CGRect(origin: CGPoint(x:0,y:titleLable.frame.maxY + 10 ), size: CGSize(width: 200, height: 21)));
        hintScoreLabel.text = "游戏得分:";
        hintScoreLabel.textAlignment = .center
        hintScoreLabel.font = UIFont.init(name: "HYXueFengF", size: 20)
        hintScoreLabel.textColor = UIColor.init(red: 0.3, green: 0.7, blue: 0.5, alpha: 0.8)
        
        resetButton = UIButton(frame: CGRect(origin: CGPoint(x:frame.origin.x + 30,y:contentView.frame.size.height - 50), size: CGSize(width: 40, height: 36)))
        resetButton.setBackgroundImage(UIImage(named:"refresh.png"), for: .normal)
        
        randButton = UIButton(frame: CGRect(origin: CGPoint(x:contentView.frame.size.width - 60 - 30,y:contentView.frame.size.height - 50), size: CGSize(width: 60, height: 36)))
        randButton.setTitle("排名", for: .normal)
        randButton.titleLabel?.font = UIFont(name: "MComicHKS-Medium", size: 20)
        randButton.setTitleColor(UIColor.init(red: 1, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
        
        gameScoreLabel = UILabel(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 50, height: 28)));
        gameScoreLabel.font = UIFont.init(name: "MComicHKS-Medium", size: 28)
        gameScoreLabel.textAlignment = .center
        gameScoreLabel.center = CGPoint(x:contentView.frame.size.width/2,y:contentView.frame.size.height/2);
        gameScoreLabel.textColor = UIColor.orange
        
        weiChatLoginButton = UIButton(frame: CGRect(origin: CGPoint(x:resetButton.frame.maxX + 10,y:contentView.frame.size.height - 50), size: CGSize(width: 40, height: 40)))
        weiChatLoginButton.setTitle("微信", for: .normal)
        weiChatLoginButton.setTitleColor(UIColor.black, for: .normal)
        
        activityView.activityIndicatorViewStyle = .gray
        activityView.hidesWhenStopped = true
        activityView.center = CGPoint(x: gameScoreLabel.center.x, y: gameScoreLabel.center.y + 25)
        
        contentView.addSubview(hintScoreLabel)
        contentView.addSubview(titleLable)
        contentView.addSubview(resetButton)
        contentView.addSubview(randButton)
        contentView.addSubview(gameScoreLabel)
        contentView.addSubview(activityView)
//        contentView.addSubview(weiChatLoginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
