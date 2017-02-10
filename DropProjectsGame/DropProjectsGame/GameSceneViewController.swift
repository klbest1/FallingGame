//
//  GameSceneViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/7.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

let handleGameResultsNotifiName = "GameResults"
let handleGamePlayingNotifiName = "GamePlayingInfo"

class GameSceneViewController: UIViewController {

    var contentView:UIView = UIView()
    var gameScoreTitleView:GameScoreView?
    var gameSceneView:GameSceneView?  = nil;
    var gameResultView:GameResultView!
    var gameCountingDownView:CountDownView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //笔记  通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameResult(_:)), name: NSNotification.Name(rawValue: handleGameResultsNotifiName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGamePlaying(_:)), name: NSNotification.Name(rawValue: handleGamePlayingNotifiName), object: nil)

        self.title = "GameScene";
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        contentView.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        self.view.addSubview(contentView)

        
        let viewSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height);
        //tile
        gameScoreTitleView = GameScoreView(frame: CGRect(origin: CGPoint(x:0,y:10), size:CGSize(width: viewSize.width, height: 64)));
        
        //游戏主界面
        gameSceneView = GameSceneView(frame:CGRect(origin: CGPoint.zero, size: viewSize));
        gameResultView = GameResultView(frame: CGRect(origin: CGPoint.zero, size: viewSize));
        //游戏失败
        //MVC 结构用户响应事件在控制层
        gameResultView.resetButton.addTarget(self, action: #selector(resetTouched(_:)), for: .touchUpInside)
        //倒计时
        gameCountingDownView = CountDownView(frame: CGRect(origin: CGPoint.zero, size: self.view.frame.size))
        
        contentView.addSubview(gameSceneView!);
        contentView.addSubview(gameScoreTitleView!)
        
//        testDicDecoding()
//        testUserName()
//        testDataBase()
    }
    
    override func viewDidAppear(_ animated: Bool)
   {
    super.viewDidAppear(animated);
    gameSceneView!.animate = true;
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
//        gameSceneView!.animate = false;
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testUserName() {
        print("userName:\(String.getRandomString(length: 4))")
    }
    
    func testDataBase() {
        //笔记
        let me:GameUser = GameUser()
        me.accountName = "kanglin"
        me.ballImageUrl = "http://xx.com"
        //笔记
        me.lastLoginTime = DateFormatter().date(from: "2010/08/02")
        me.profileImageUrl = "http://xx.com"
        
        let result = Result();
        result.level = 4;
        result.score = 4000
        me.result = result
        
        if #available(iOS 10.0, *) {
            appDelegate?.persistentContainer.viewContext.perform {
//                _ = PlayIResults.playResultsUpdate(user: me, result: result, context: (appDelegate?.persistentContainer.viewContext)!)
                _ = Users.updateUser(user: me, context: (appDelegate?.persistentContainer.viewContext)!)
                do{
                    try appDelegate?.persistentContainer.viewContext.save()
                }catch let error as NSError{
                    print(error);
                }
                Users.printAllUsers(context: (appDelegate?.persistentContainer.viewContext)!)
            }
        }else{
            appDelegate?.managedObjectContext.perform{
//                _ = PlayIResults.playResultsUpdate(user: me, result: result, context: (appDelegate?.managedObjectContext)!)
                _ = Users.updateUser(user: me, context: (appDelegate?.managedObjectContext)!)
                do{
                    try appDelegate?.managedObjectContext.save()
                }catch let error as NSError{
                    print(error);
                }
                Users.printAllUsers(context: (appDelegate?.managedObjectContext)!)
            }
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
    

    func handleGameResult(_ sender:Notification)  {
        let result:Result = sender.object as! Result
        if result.passLevel{
            //进入下一关
            contentView.addSubview(gameCountingDownView!)
            gameCountingDownView?.countDownNumber = GameEngine.share.timeDelayWhenGotoNext
            gameCountingDownView?.startCouting()
            gameCountingDownView?.setHint(hint: "恭喜过关，下一关即将开始！")
        }else{
            //弹出游戏结果
            gameResultView.gameScoreLabel.text = String(format: "%d", arguments: [result.score])
            contentView.addSubview(gameResultView)
            gameResultView.frame.origin = CGPoint(x:0, y: -gameResultView.frame.size.height)
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.gameResultView.frame.origin = CGPoint.zero
            }) { ( finish:Bool) in
                
            }
        }
    }
    
    func handleGamePlaying(_ sender:Notification)  {
        let titleObject:TitleObject = sender.object as! TitleObject
        gameScoreTitleView?.showScoreBarWithCurrentLevel(level: titleObject.currentLevel! + 1, currentScore: titleObject.currenScore!, golaScore: titleObject.goalScore!)

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
