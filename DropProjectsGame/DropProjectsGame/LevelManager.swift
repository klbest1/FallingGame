//
//  LevelManager.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/22.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

private let shareInstance = LevelManager()

class LevelManager: NSObject {
    
    class var share: LevelManager {
        return shareInstance
    }
    
    var levelResponse:LevelResponse?
    override init() {
        super.init()
        let path = Bundle.main.path(forResource: "Level", ofType: "plist")
        let levelDic = NSDictionary(contentsOfFile: path!)
        levelResponse = NSDictionary.decodeDic(dicOrigin: levelDic as! [String : AnyObject]) as? LevelResponse
        if levelResponse != nil {
            for  item in (levelResponse?.results)!{
                print("Plist中的results:\(item.numberOfDrops)")
            }
        }
        
    }
}
