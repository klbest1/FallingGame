//
//  RankingViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/17.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController,UITableViewDataSource {

    var rankingView:RankingView!
    var rankingResult:[Result] = [Result]()
    var shareView:ShareView?
    var currenScene:WXScene = WXSceneTimeline

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "weiLogo.png"), style: UIBarButtonItemStyle.done, target: self, action: #selector(share));
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        rankingView = RankingView(frame: CGRect(origin: CGPoint.zero, size: self.view.frame.size))
        rankingView.tableView.dataSource = self
        self.view.addSubview(rankingView)
        
        shareView = ShareView.createShareView()
        shareView?.weChatFriends.addTarget(self, action: #selector(sendToFriend), for: .touchUpInside)
        shareView?.weChatMoment.addTarget(self, action: #selector(shareToWeiChatMoment), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        LeanCloundDealer.share().updateRanking { (objects) in
            self.rankingResult = objects
            self.rankingView.tableView.reloadData()
            LeanCloundDealer.share().selectUser(user: UserManager.share.currentUser) { (user) in
                self.rankingView.myNameLabel.text = user.accountName
                self.rankingView.myRanking.text = String(format: "%d", (user.result?.ranking)!)
                self.rankingView.myScore.text = String(format: "%d", (user.result?.score)!)
            }
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
        }
        
        let result = rankingResult[indexPath.row]
        cell?.setCell(result: result)
        return cell!
    }
    
    func sendToFriend() {
        currenScene = WXSceneSession
        let thumbImage:UIImage  =  UIImage.init(named: "head.png")!;
        WXApiRequestHandler.sendLinkURL(kLinkURL, tagName: kLinkTagName, title: kLinkTitle, description: kLinkDescription, thumbImage: thumbImage, in: currenScene)
    }
    
    func shareToWeiChatMoment()  {
        currenScene = WXSceneTimeline
        let thumbImage:UIImage  =  UIImage.init(named: "head.png")!;
        WXApiRequestHandler.sendLinkURL(kLinkURL, tagName: kLinkTagName, title: kLinkTitle, description: kLinkDescription, thumbImage: thumbImage, in: currenScene)
        
    }
    
    func share()  {
        shareView?.showShareView()
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
