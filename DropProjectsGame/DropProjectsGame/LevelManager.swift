//
//  LevelManager.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/22.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class LevelManager: NSObject {
    override init() {
        super.init()
        let path = Bundle.main.path(forResource: "Level", ofType: "plist")
        let levelDic = NSDictionary(contentsOfFile: path!)
        let results = NSDictionary.decodeDic(dicOrigin: levelDic as! [String : AnyObject]) as? [Level]
        for var item in results!{
            print("results:\(item.numberOfDrops)")
        }
    }
}
