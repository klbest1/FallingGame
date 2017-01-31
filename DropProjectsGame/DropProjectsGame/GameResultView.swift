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
        contentView.addSubview(resetButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
