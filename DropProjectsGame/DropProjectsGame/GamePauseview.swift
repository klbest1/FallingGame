//
//  GamePauseview.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/11.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class GamePauseview: UIView {
    var resumeButton:UIButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let contentView = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        contentView.backgroundColor = UIColor.lightGray
        contentView.alpha = 0.6
        self.addSubview(contentView)
        
        resumeButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 36, height: 36))
        resumeButton.setBackgroundImage(UIImage.init(named: "start.png"), for: .normal)
        resumeButton.center = contentView.center
        self.addSubview(resumeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
