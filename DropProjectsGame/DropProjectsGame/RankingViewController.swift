//
//  RankingViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/17.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController,UITableViewDataSource,UIAlertViewDelegate {

    var rankingView:RankingView!
    var rankingResult:[Result] = [Result]()
    var shareView:ShareView?
    var currenScene:WXScene = WXSceneTimeline
    var activiView:UIActivityIndicatorView = UIActivityIndicatorView()
    var shareData:Share = Share()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let shareButton:UIButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24)))
            shareButton.setBackgroundImage(UIImage.init(named: "share.png"), for: .normal)
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        let shareItem:UIBarButtonItem = UIBarButtonItem.init(customView: shareButton)
        navigationItem.setRightBarButtonItems([shareItem], animated: false);
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        activiView.activityIndicatorViewStyle = .white
        activiView.hidesWhenStopped = true
        self.navigationItem.titleView = activiView
        
        rankingView = RankingView(frame: CGRect(origin: CGPoint.zero, size: self.view.frame.size))
        rankingView.tableView.dataSource = self
        rankingView.editButton.addTarget(self, action: #selector(editTouched), for: .touchUpInside)
        rankingView.adminButton?.addTarget(self, action: #selector(adminClicked), for: .touchUpInside);

        self.view.addSubview(rankingView)
        
        shareView = ShareView.createShareView()
        shareView?.weChatFriends.addTarget(self, action: #selector(sendToFriend), for: .touchUpInside)
        shareView?.weChatMoment.addTarget(self, action: #selector(shareToWeiChatMoment), for: .touchUpInside)

        // Do any additional setup after loading the view.
        activiView.startAnimating()
        LeanCloundDealer.share().updateRanking { (objects) in
            self.rankingResult = objects
            self.rankingView.tableView.reloadData()
            LeanCloundDealer.share().selectUser(user: UserManager.share.currentUser) { (user) in
                if (user != nil){
                    self.rankingView.myNameLabel.text = user?.accountName
                    if(user?.result?.ranking != nil){
                        self.rankingView.myRanking.text = String(format: "%d", (user?.result?.ranking)!)
                        self.rankingView.myScore.text = String(format: "%d(关卡:%d)", (user?.result?.score)!,(user?.result?.level)! + 1)
                    }
                }
                self.activiView.stopAnimating()
            }
        }
        
        shareData.getShareData { (shareIfo) in
            self.shareData = shareIfo
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rankingResult.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentify = "cell"
        
        var cell:RankingTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentify) as? RankingTableViewCell
        if (cell == nil){
            cell = RankingTableViewCell(style: .default, reuseIdentifier: cellIdentify)
            cell?.selectionStyle = .none
        }
        
        let result = rankingResult[indexPath.row]
        cell?.setCell(result: result)
        return cell!
    }
    
    func sendToFriend() {
        currenScene = WXSceneSession
        let thumbImage:UIImage  =  UIImage.init(named: shareData.linkImgName)!;
        WXApiRequestHandler.sendLinkURL(shareData.linkURL , tagName: shareData.linkTagName, title: shareData.linkTitle, description: shareData.linkDesc, thumbImage: thumbImage, in: currenScene)
    }
    
    func shareToWeiChatMoment()  {
        currenScene = WXSceneTimeline
        let thumbImage:UIImage  =  UIImage.init(named: shareData.linkImgName)!;
        WXApiRequestHandler.sendLinkURL(shareData.linkURL, tagName: shareData.linkTagName, title: shareData.linkTitle, description: shareData.linkDesc, thumbImage: thumbImage, in: currenScene)
        
    }
    
    func share()  {
        if(WXApi.isWXAppInstalled() ){
            shareView?.showShareView()
        }else{
            let alertView:UIAlertView = UIAlertView(title: "", message: "weChatInstall".localString(), delegate: self, cancelButtonTitle: "Cancel".localString(), otherButtonTitles: "GoToInstall".localString())
            alertView.show()
        }
    }
    
    func editTouched()  {
        let elertView:UIAlertView = UIAlertView(title: "昵称", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        elertView.alertViewStyle = .plainTextInput
        elertView.textField(at: 0)?.placeholder = rankingView.myNameLabel.text
        rankingView.addSubview(elertView)
        elertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) // after animation
    {
        if buttonIndex == 1{
            if alertView.alertViewStyle == .plainTextInput{
                activiView.startAnimating()
                let gameUser = GameUser()
                gameUser.accountName = UserManager.share.currentUser.accountName
                UserManager.share.currentUser.accountName = alertView.textField(at: 0)?.text
                LeanCloundDealer.share().updateUserInfo(oldUser: gameUser,newUser: UserManager.share.currentUser, complete: { (success) in
                    self.activiView.stopAnimating()
                    if (success){
                        self.rankingView.myNameLabel.text = alertView.textField(at: 0)?.text
                        appDelegate?.saveDataBase()
                    }else{
                        self.view.alertInfo(msg: "该用户已存在");
                        UserManager.share.currentUser.accountName = gameUser.accountName
                    }
                })
            }else{
                UIApplication.shared.openURL(URL(string: "https://appsto.re/cn/S8gTy.i")!)
            }
           
        }
    }
    
    func adminClicked()  {
        let stBoard = UIStoryboard(name: "Admin", bundle: nil)
        let adminCtrl = stBoard.instantiateViewController(withIdentifier: "admin")
        self.present(adminCtrl, animated: true) { 
            
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
