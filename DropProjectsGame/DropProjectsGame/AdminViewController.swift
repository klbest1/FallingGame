//
//  AdminViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/3/5.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    @IBOutlet weak var linkURLField: UITextField!
    @IBOutlet weak var tagField: UITextField!
    
    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var descView: UITextView!
    @IBOutlet weak var imgField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkURLField.text = kLinkURL
        tagField.text = kLinkTagName
        titleView.text = kLinkTitle
        descView.text = kLinkDescription
        imgField.text = kLinkImgName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBAction func submitClicked(_ sender: UIButton) {
        let share = Share()
        share.linkURL = linkURLField.text!
        share.linkTagName = tagField.text!
        share.linkTitle = titleView.text!
        share.linkDesc = descView.text!
        share.linkImgName = imgField.text!
        self.stateLabel.text = "提交中..."
        self.stateLabel.isHidden = false
        share.updateShare(compelete: {(success) in
            if success {
                self.stateLabel.text = "更新成功！"
            }else{
                self.stateLabel.text = "更新失败!"
            }
        })
        
    }


    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) { 
            
        }
    }
}
