//
//  GameRuleView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/26.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

enum RuleType:Int{
    case firstInstallGame = 1000,
    helpGame
    
    func getDismissButtonString() -> String! {
        switch self {
        case .firstInstallGame:
            return "startPlay";
        case .helpGame:
            return "知道了"
        }
    }
}

class GameRuleView: BaseView {

     var startPlayButton: UIButton!
    
     var gameRuleLabel: UILabel!
    
     var textView: UITextView!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        
        gameRuleLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 21)))
        gameRuleLabel.center = CGPoint(x: frame.size.width/2, y: 40)
        gameRuleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        gameRuleLabel.textColor = UIColor.black
        gameRuleLabel.textAlignment = .center
        gameRuleLabel.text = "gameRule".localString()
        
        textView = UITextView(frame: CGRect(origin: CGPoint(x:12,y:69), size: CGSize(width: self.width - 12 * 2, height: 341)))
        textView.text = "gameRuletext".localString()
        textView.font = UIFont(name: "MComicHKS-Medium", size: 17)
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false;
        textView.isSelectable = false;
        
        startPlayButton = UIButton(frame: CGRect(origin: CGPoint(x:76,y:439), size: CGSize(width: 128, height: 40)))
        startPlayButton.center = CGPoint(x: frame.size.width/2, y: 439)
        startPlayButton.setTitle("startPlay".localString(), for: .normal)
        startPlayButton.titleLabel?.font = UIFont(name: "MComicHKS-Medium", size: 18)
        startPlayButton.setTitleColor(UIColor.red, for: .normal)
        self.addSubview(gameRuleLabel)
        self.addSubview(textView)
        self.addSubview(startPlayButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        self.textView.text = "gameRuletext".localString()
        self.textView.font = UIFont(name: "MComicHKS-Medium", size: 17)
        self.gameRuleLabel.text = "gameRule".localString()
        self.startPlayButton.setTitle("startPlay".localString(), for: .normal)
        self.layoutIfNeeded()
    }
    
    class func createView()->GameRuleView{
        return GameRuleView(frame: CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
    }
    
    func setButtonType(ruleType:RuleType) {
        let buttonTitle = ruleType.getDismissButtonString()
        self.startPlayButton.setTitle(buttonTitle?.localString(), for: .normal)
        self.startPlayButton.tag = ruleType.rawValue
    }
    
    func resetFrame()  {
        gameRuleLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 21));
        gameRuleLabel.center = CGPoint(x: frame.size.width/2, y: 40)
        textView.frame = CGRect(origin: CGPoint(x:12,y:69), size: CGSize(width: self.width - 12 * 2, height: 341))
        startPlayButton.frame = CGRect(origin: CGPoint(x:76,y:439), size: CGSize(width: 128, height: 34))
        startPlayButton.center = CGPoint(x: frame.size.width/2, y: 419)
    }
    
    func showRule(withType:RuleType) {
        setButtonType(ruleType: withType)
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(self)
//        _ = self.ff_Fill(window)
        //笔记
        resetFrame()
        self.gameRuleLabel.center = CGPoint(x:self.gameRuleLabel.center.x,y:-self.gameRuleLabel.center.y)
        self.textView.center = CGPoint(x:self.textView.center.x,y:-self.textView.center.y)
        self.startPlayButton.center = CGPoint(x:self.startPlayButton.center.x,y:self.startPlayButton.center.y + 200)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.gameRuleLabel.center = CGPoint(x:self.gameRuleLabel.center.x,y:-self.gameRuleLabel.center.y)
            self.textView.center = CGPoint(x:self.textView.center.x,y:-self.textView.center.y)
            self.startPlayButton.center = CGPoint(x:self.startPlayButton.center.x,y:self.startPlayButton.center.y - 200)
        }) { (complete) in
        }
    }
    
    func dismiss()  {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.gameRuleLabel.center = CGPoint(x:self.gameRuleLabel.center.x,y:-self.gameRuleLabel.center.y)
            self.textView.center = CGPoint(x:self.textView.center.x,y:-self.textView.center.y)
            self.startPlayButton.center = CGPoint(x:self.startPlayButton.center.x,y:self.startPlayButton.center.y + 200)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
}
