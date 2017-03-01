//
//  GameSceneViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/7.
//  Copyright © 2017年 lin kang. All rights reserved.
//bug 数据库名字没有更新，滑动列表crash
//回来会有声音

import UIKit

let handleGameResultsNotifiName = "GameResults"
let handleGamePlayingNotifiName = "GamePlayingInfo"
let kIsInstalled = "isInstalled"

class GameSceneViewController: UIViewController,WXApiManagerDelegate {

    var contentView:UIView = UIView()
    var gameScoreTitleView:GameScoreView?
    var gameSceneView:GameSceneView?  = nil;
    var gameResultView:GameResultView!
    var gameCountingDownView:CountDownView?
    var gamePauseView:GamePauseview?
    var gameRuleView:GameRuleView?
    var gameHelpView:GameRuleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let isInstalled:Bool? = UserDefaults.standard.object(forKey: kIsInstalled) as! Bool?
        if (isInstalled == nil || isInstalled == false){
            UserDefaults.standard.set(true, forKey: kIsInstalled)
            gameRuleView = GameRuleView.createView()
            gameRuleView?.startPlayButton.addTarget(self, action: #selector(ruleStartPlayButtonCliked), for: .touchUpInside)

        }
        //笔记  通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameResult(_:)), name: NSNotification.Name(handleGameResultsNotifiName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGamePlaying(_:)), name: NSNotification.Name(rawValue: handleGamePlayingNotifiName), object: nil)
        WXApiManager.shared().delegate = self;

        self.title = "GameScene";
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        contentView.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        self.view.addSubview(contentView)

        
        let viewSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height);
        //游戏分数
        gameScoreTitleView = GameScoreView(frame: CGRect(origin: CGPoint(x:0,y:10), size:CGSize(width: viewSize.width, height: 64)));
        gameScoreTitleView?.pauseButton.addTarget(self, action: #selector(pauseClicked), for:.touchUpInside)
        //游戏主界面
        gameSceneView = GameSceneView(frame:CGRect(origin: CGPoint.zero, size: viewSize));
        gameResultView = GameResultView(frame: CGRect(origin: CGPoint.zero, size: viewSize));
        //游戏结束
        //MVC 结构用户响应事件在控制层
        gameResultView.resetButton.addTarget(self, action: #selector(resetTouched(_:)), for: .touchUpInside)
        gameResultView.helPButton.addTarget(self, action: #selector(helpButtonTouched(_:)), for: .touchUpInside)
        
        //倒计时
        gameCountingDownView = CountDownView(frame: CGRect(origin: CGPoint.zero, size: self.view.frame.size))
        //游戏暂停
        gamePauseView = GamePauseview(frame: contentView.frame)
        gamePauseView?.resumeButton.addTarget(self, action: #selector(resumeClicked), for: .touchUpInside)
        gameResultView.randButton.addTarget(self, action: #selector(rankingCliked), for: .touchUpInside)
        
        contentView.addSubview(gameSceneView!);
        contentView.addSubview(gameScoreTitleView!)
        
//        testDicDecoding()
//        testUserName()
//        testDataBase()
        gameSceneView!.animate = true;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated);
        gameRuleView?.showRule(withType: .firstInstallGame)
        if gameRuleView != nil {
            gameSceneView?.gameEngin.gamePause()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
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
    
    func pauseClicked()  {
        gameSceneView?.gameEngin.gamePause()
        contentView.addSubview(gamePauseView!)
    }
    
    func resumeClicked()  {
        gamePauseView?.removeFromSuperview()
        gameSceneView?.gameEngin.gameContinue()
    }

    func handleGameResult(_ sender:Notification)  {
        print("到达通知")
        let result:Result = sender.object as! Result
        if result.passLevel{
            //进入下一关
            contentView.addSubview(gameCountingDownView!)
            gameCountingDownView?.countDownNumber = GameEngine.share.timeDelayWhenGotoNext
            gameCountingDownView?.startCouting()
            gameCountingDownView?.setHint(hint: "恭喜过关😎")
        }else{
            print("到达加载游戏结果页面")
            //弹出游戏结果
            gameResultView.gameScoreLabel.text = String(format: "%d", arguments: [result.score])
            gameResultView.randButton.isEnabled = false
            gameResultView.randButton.alpha = 0.5
            contentView.addSubview(gameResultView)
            gameResultView.frame.origin = CGPoint(x:0, y: -gameResultView.frame.size.height)
            gameResultView.activityView.startAnimating()
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.gameResultView.frame.origin = CGPoint.zero
            }) { ( finish:Bool) in
                
            }
        }
        LeanCloundDealer.share().updateUserPlayingResult(user: UserManager.share.currentUser,updateCompelete: {(updateSucees)in
            self.gameResultView.randButton.alpha = 1
            self.gameResultView.randButton.isEnabled = true;
            self.gameResultView.activityView.stopAnimating()
        })
    }
    
    func handleGamePlaying(_ sender:Notification)  {
        let titleObject:TitleObject = sender.object as! TitleObject
        gameScoreTitleView?.showScoreBarWithCurrentLevel(level: titleObject.currentLevel! + 1, currentScore: titleObject.currenScore!, golaScore: titleObject.goalScore!)

    }
    
    func rankingCliked(){
        let rankingCtrl = RankingViewController()
        self.navigationController?.pushViewController(rankingCtrl, animated: true)
    }
    
    func ruleStartPlayButtonCliked(sender:UIButton)  {
        if (sender.tag == RuleType.firstInstallGame.rawValue) {
            contentView.addSubview(gameCountingDownView!)
            gameCountingDownView?.countDownNumber = 3
            gameCountingDownView?.startCouting()
            gameCountingDownView?.setHint(hint: "游戏马上开始")
            gameSceneView?.gameEngin.perform(#selector(gameSceneView?.gameEngin.gameContinue), with: nil, afterDelay: 3)
            gameRuleView?.dismiss()
            gameRuleView = nil
        }else{
            gameHelpView?.dismiss()
        }
    }
    
    
    func helpButtonTouched(_ sender:UIButton)  {
        if(gameHelpView == nil){
            gameHelpView = GameRuleView.createView()
            gameHelpView?.startPlayButton.addTarget(self, action: #selector(ruleStartPlayButtonCliked), for: .touchUpInside)
        }
        gameHelpView?.showRule(withType: .helpGame)
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
