//
//  RankingView.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/17.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class RankingView: BaseView {
    var contentView:UIView = UIView()
    var myNameLabelHint:UILabel = UILabel()
    var myRankingHint:UILabel = UILabel()
    var myScoreHint:UILabel = UILabel()
    
    var myNameLabel:UILabel = UILabel()
    var myRanking:UILabel = UILabel()
    var myScore:UILabel = UILabel()
    var tableView:UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        self.addSubview(contentView)
        
        let backGroundView:UIImageView = UIImageView(frame: contentView.frame)
        backGroundView.image = UIImage(named: "ranking_background.png")
        contentView.addSubview(backGroundView)
        
        //名字
        myNameLabelHint.frame = CGRect(origin: CGPoint(x:50,y:84), size: CGSize(width: 150, height: 21))
        myNameLabelHint.font = UIFont(name: "HYXueFengF", size: 21)
        myNameLabelHint.textColor = UIColor.white
        myNameLabelHint.textAlignment = .left
        myNameLabelHint.text = "我的名字:"
        contentView.addSubview(myNameLabelHint)
        
        myNameLabel.frame = CGRect(origin: CGPoint(x:myNameLabelHint.frame.maxX - 30,y:myNameLabelHint.frame.minY + 2), size: CGSize(width: 150, height: 20))
       //笔记 使用自定义字体
        myNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        myNameLabel.textColor = UIColor.brown
        myNameLabel.textAlignment = .left
        contentView.addSubview(myNameLabel)
        
        //排名
        myRankingHint.frame = CGRect(origin: CGPoint(x:50,y:myNameLabelHint.frame.maxY + 10), size: CGSize(width: 150, height: 21))
        myRankingHint.font = UIFont(name: "HYXueFengF", size: 21)
        myRankingHint.textColor = UIColor.white
        myRankingHint.textAlignment = .left
        myRankingHint.text = "我的排名:"
        contentView.addSubview(myRankingHint)
        
        myRanking.frame = CGRect(origin: CGPoint(x:myRankingHint.frame.maxX - 30,y:myRankingHint.frame.minY + 4), size: CGSize(width: 150, height: 20))
        //笔记 使用自定义字体
        myRanking.font = UIFont.boldSystemFont(ofSize: 20)
        myRanking.textColor = UIColor.brown
        myRanking.textAlignment = .left
        contentView.addSubview(myRanking)
        
        //分数
        myScoreHint.frame = CGRect(origin: CGPoint(x:50,y:myRankingHint.frame.maxY + 10), size: CGSize(width: 150, height: 25))
        myScoreHint.font = UIFont(name: "HYXueFengF", size: 21)
        myScoreHint.textColor = UIColor.white
        myScoreHint.textAlignment = .left
        myScoreHint.text = "我的分数:"
        contentView.addSubview(myScoreHint)
        
        myScore.frame = CGRect(origin: CGPoint(x:myScoreHint.frame.maxX - 30,y:myScoreHint.frame.minY + 4), size: CGSize(width: 150, height: 20))
        //笔记 使用自定义字体
        myScore.font = UIFont.boldSystemFont(ofSize: 20)
        myScore.textColor = UIColor.brown
        myScore.textAlignment = .left
        contentView.addSubview(myScore)
        
        ///************列表 表头的提示****************/
        let tableRankingHint:UILabel = UILabel(frame: CGRect(origin: CGPoint(x:50 + 5,y:myScoreHint.frame.maxY + 20), size: CGSize(width: 100, height: 20)))
        //笔记 使用自定义字体
        tableRankingHint.font = UIFont.systemFont(ofSize: 20)
        tableRankingHint.textColor = UIColor.white
        tableRankingHint.textAlignment = .left
        tableRankingHint.text = "排名"
        contentView.addSubview(tableRankingHint)
        
        let tableNameHint:UILabel = UILabel(frame: CGRect(origin: CGPoint(x:tableRankingHint.frame.maxX + 10,y:myScoreHint.frame.maxY + 20), size: CGSize(width: 100, height: 20)))
        //笔记 使用自定义字体
        tableNameHint.font = UIFont.systemFont(ofSize: 20)
        tableNameHint.textColor = UIColor.white
        tableNameHint.textAlignment = .left
        tableNameHint.text = "名字"
        contentView.addSubview(tableNameHint)
        
        let tableScoreHint:UILabel = UILabel(frame: CGRect(origin: CGPoint(x:tableNameHint.frame.maxX + 10,y:myScoreHint.frame.maxY + 20), size: CGSize(width: 100, height: 20)))
        //笔记 使用自定义字体
        tableScoreHint.font = UIFont.systemFont(ofSize: 20)
        tableScoreHint.textColor = UIColor.white
        tableScoreHint.textAlignment = .left
        tableScoreHint.text = "分数"
        contentView.addSubview(tableScoreHint)
        
        tableView.frame = CGRect(origin: CGPoint(x:50,y:tableRankingHint.frame.maxY + 20), size: CGSize(width: 260, height: self.hight - tableRankingHint.frame.maxY - 20 - 40 ))
        tableView.backgroundColor = UIColor.clear
        contentView.addSubview(tableView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
