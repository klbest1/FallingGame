//
//  CountDownView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/6.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class CountDownView: UIView {
    var countDownNumber:Int = 3;
    var countDownShowLabel:UILabel = UILabel()
    var hintLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let contentView:UIView = UIView(frame: frame);
        countDownShowLabel.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 40, height: 40))
        countDownShowLabel.textColor = UIColor.orange
        countDownShowLabel.font = UIFont.systemFont(ofSize: 42);
        countDownShowLabel.center = self.center
        
        hintLabel.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 300, height: 35))
        hintLabel.center = CGPoint(x:self.center.x,y:self.center.y - hintLabel.frame.size.height - 20)
        hintLabel.textColor = UIColor.black
        hintLabel.textAlignment = .center
        
        contentView.addSubview(countDownShowLabel)
        contentView.addSubview(hintLabel)
        self.addSubview(contentView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHint(hint:String)  {
        hintLabel.text = hint
        hintLabel.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        hintLabel.alpha = 0.5
        UIView.animate(withDuration: 1, animations: {
            self.hintLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.hintLabel.alpha = 1
        }) { (finish:Bool) in
            
        }
    }
    
    func startCouting() {
        countDownShowLabel.text = String(format: "%d",countDownNumber)
        countDownNumber -= 1
        countDownShowLabel.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        countDownShowLabel.alpha = 0.5
        UIView.animate(withDuration: 1, animations: {
            self.countDownShowLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.countDownShowLabel.alpha = 1
        }) { [unowned self](finish:Bool) in
            if (finish && self.countDownNumber > 0){
                self.startCouting()
            }else{
                self.removeFromSuperview()
            }
        }
    }
}
