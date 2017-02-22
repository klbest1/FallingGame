//
//  ShareView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/22.
//  Copyright © 2017年 lin kang. All rights reserved.
//笔记，自动布局

import UIKit

class ShareView: UIView {

    let kShareviewMargin:CGFloat = 35
    let kShareItemWidth:CGFloat = 63
    var shareViewItemSpace:CGFloat = 0
    
    @IBOutlet weak var pengyouQuanCenter: NSLayoutConstraint!

    @IBOutlet weak var qqRight: NSLayoutConstraint!
    @IBOutlet weak var kongjianTop: NSLayoutConstraint!
    @IBOutlet weak var kongJianRight: NSLayoutConstraint!
    
    @IBOutlet weak var shareContentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var shareContentViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var weChatFriends: UIButton!
    @IBOutlet weak var weChatMoment: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dissmissButton: UIButton!
    @IBOutlet weak var shareContentView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let kScreenWidth:CGFloat = UIScreen.main.bounds.width
        shareViewItemSpace = (kScreenWidth - kShareviewMargin * 2 -  kShareItemWidth * 4)/CGFloat(3)
        if( kScreenWidth >= 375 ){
            pengyouQuanCenter.constant = -(shareViewItemSpace/2 + kShareItemWidth/2)
            qqRight.constant = (shareViewItemSpace + kShareItemWidth + kShareviewMargin)
            kongjianTop.constant = 21
            kongJianRight.constant = 35
            shareContentViewHight.constant = 180
        }
        dissmissButton.backgroundColor = UIColor(white: 0, alpha: 0.2)
        shareContentView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    class func createShareView() -> ShareView {
        return Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)?.first as! ShareView
    }
    
    func showShareView(){
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(self)
        dissmissButton.alpha = 0
        self.ff_Fill(window)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.6) {
            self.dissmissButton.alpha = 1
            self.shareContentViewBottom.constant = 0
        }
    }
    
    func dismissShareView()  {
        UIView.animate(withDuration: 0.4, animations: {
            self.shareContentViewBottom.constant = -260
            self.dissmissButton.alpha = 0

        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    
    func dismiss()  {
        dismissShareView()
    }
}
