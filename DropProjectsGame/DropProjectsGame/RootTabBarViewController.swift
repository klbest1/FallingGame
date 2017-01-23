//
//  RootTabBarViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/7.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {

    var gameSecneCtrl:GameSceneViewController = GameSceneViewController()
    var setCtrl:SettingViewController = SettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        var ctrls = [gameSecneCtrl,setCtrl] as [UIViewController]
        self.addChildViewController(gameSecneCtrl)
        self.addChildViewController(setCtrl)
        print("高度:\(self.tabBar.frame.size.height)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
