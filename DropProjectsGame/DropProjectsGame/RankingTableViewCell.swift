//
//  RankingTableViewCell.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/17.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    var rankging:UILabel = UILabel()
    var name:UILabel = UILabel()
    var score:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rankging.frame = CGRect(origin: CGPoint(x:5,y:(self.contentView.frame.size.height - 19)/2), size: CGSize(width: 50, height: 19));
        rankging.font = UIFont(name: "MComicHKS-Medium", size: 19)
        rankging.textColor = UIColor.orange
        rankging.textAlignment = .left
        rankging.text = "NO.1"
        rankging.adjustsFontSizeToFitWidth = true;
        self.contentView.addSubview(rankging)
        
        name.frame = CGRect(origin: CGPoint(x:rankging.frame.maxX + 10,y:(self.contentView.frame.size.height - 19)/2), size: CGSize(width: 100, height: 19));
        name.font = UIFont(name: "HYXueFengF", size: 19)
        name.textColor = UIColor.orange
        name.textAlignment = .left
        name.text = "accy"
        name.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(name)
        
        score.frame = CGRect(origin: CGPoint(x:name.frame.maxX,y:(self.contentView.frame.size.height - 19)/2), size: CGSize(width: 98, height: 19));
        score.font = UIFont(name: "MComicHKS-Medium", size: 19)
        score.textColor = UIColor.orange
        score.textAlignment = .left
        score.text = "1000"
        score.adjustsFontSizeToFitWidth = true;
        self.contentView.addSubview(score)
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear

    }
    
    func setCell(result:Result)  {
        var rankingStr = String(format: "%d", result.ranking)
        switch  Int(result.ranking) {
        case 1:
            rankingStr = "NO.1"
            break;
        case 2:
            rankingStr = "NO.2"
            break;
        case 3:
            rankingStr = "NO.3"
            break;
        default:
            break;
        }
        
        rankging.text = rankingStr
        self.name.text = result.user?.accountName
        if (result.user?.accountName == nil  ){
            if ( result.user != nil){
                let query = GameUser.query()
                query.getObjectInBackground(withId: (result.user?.objectId)!) { (object, error) in
                    let user:GameUser? = object as? GameUser
                    result.user?.accountName = user?.accountName
                    if(self.name.text == nil){
                        self.name.text = user?.accountName
                    }
                }
            }
        }
        
        score.text = String(format: "%d(关卡:%d)", result.score,(result.level + 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
