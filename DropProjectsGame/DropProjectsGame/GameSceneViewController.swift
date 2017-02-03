//
//  GameSceneViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/7.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

let addGameResultsNotifiName = "GameResults"

class GameSceneViewController: UIViewController {

    var contentView:UIView = UIView()
    var gameSceneView:GameSceneView?  = nil;
    var gameResultView:GameResultView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GameScene";
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        contentView.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        
        let viewSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 49);
        gameSceneView = GameSceneView(frame:CGRect(origin: CGPoint.zero, size: viewSize));
        gameResultView = GameResultView(frame: CGRect(origin: CGPoint.zero, size: viewSize));
        // MVC 结构用户响应事件在控制层
        gameResultView.resetButton.addTarget(self, action: #selector(resetTouched(_:)), for: .touchUpInside)
        
        self.view.addSubview(contentView)
        contentView.addSubview(gameSceneView!);
        
        testDicDecoding()
    }
    
    override func viewDidAppear(_ animated: Bool)
   {
        super.viewDidAppear(animated);
        gameSceneView!.animate = true;
       //笔记  通知
       NotificationCenter.default.addObserver(self, selector: #selector(addResultView(_:)), name: NSNotification.Name(rawValue: addGameResultsNotifiName), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        gameSceneView!.animate = false;
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testDataBase() {
        let me:GameUser = GameUser()
        me.accountName = "kanglin"
        me.ballImageUrl = "http://xx.com"
        me.lastLoginTime = "20/01/2017"
        me.profileImageUrl = "http://xx.com"
        
        let result = Result();
        result.level = 4;
        result.score = 4000
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if #available(iOS 10.0, *) {
            appDelegate?.persistentContainer.viewContext.perform {
                //            _ = Users.userWithUserInfo(gameUser:me, result:result ,context: appDelegate!.persistentContainer.viewContext)
                appDelegate?.persistentContainer.viewContext.perform {
                    //            _ = Users.userWithUserInfo(gameUser:me, result:result ,context: appDelegate!.persistentContainer.viewContext)
                    _ = PlayIResults.playResultsUpdate(user: me, result: result, context: (appDelegate?.persistentContainer.viewContext)!)
                    
                    
                    do{
                        try appDelegate?.persistentContainer.viewContext.save()
                    }catch let error as NSError{
                        print(error);
                    }
                    
                }
                
                do{
                    try appDelegate?.persistentContainer.viewContext.save()
                }catch let error as NSError{
                    print(error);
                }
            }
            Users.printAllUsers(context: (appDelegate?.persistentContainer.viewContext)!)
        }
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        print("path\(path)");

    }

    func testDicDecoding() {
        let _ = LevelManager()
    }
   
    
    func resetTouched(_ sender:UIButton) {
        gameSceneView?.gameEngin.gameRefresh()
        gameResultView.removeFromSuperview()
    }
    
    func addResultView(_ sender:NotificationCenter)  {
        contentView.addSubview(gameResultView)
        gameResultView.frame.origin = CGPoint(x:0, y: -gameResultView.frame.size.height)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { 
          self.gameResultView.frame.origin = CGPoint.zero
        }) { ( finish:Bool) in
            
        }
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
