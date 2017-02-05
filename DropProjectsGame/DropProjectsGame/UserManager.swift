//
//  UserManager.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/5.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

private let shareInstance = UserManager()


class UserManager: NSObject {
    
    class var share: UserManager {
        return shareInstance
    }
    
    public var currentUser:GameUser = {
        let gameUser:GameUser = GameUser()
        let gameResult:Result = Result()
        gameUser.result = gameResult
        
        var tempUser:Users?
        
        if #available(iOS 10.0, *) {
            let user = Users.getCurrentUser(context: (appDelegate?.persistentContainer.viewContext)!)
            tempUser = user;
           
        } else {
            // Fallback on earlier versions
            let user = Users.getCurrentUser(context: (appDelegate?.managedObjectContext)!)
            tempUser = user
        }
        
        if(tempUser != nil){
            gameUser.accountName = tempUser?.accountName;
            gameUser.ballImageUrl = tempUser?.ballImageUrl
            gameUser.isCurrentUser = (tempUser?.isCurrentUser)!
            gameUser.lastLoginTime = tempUser?.lastLoginTime
            gameUser.profileImageUrl = tempUser?.profileImageUrl
            gameResult.level = (tempUser?.result?.level)!
            gameResult.score = (tempUser?.result?.score)!
        }else{
            
            //生成默认用户
            //缺： 检测用户名是否重复
            gameUser.accountName = String.getRandomString(length: 5)
            gameUser.lastLoginTime =  Date()
            gameUser.isCurrentUser = true
            gameUser.profileImageUrl = Bundle.main.url(forResource: "head", withExtension: "png")?.path
            gameResult.level = 0
            gameResult.score = 0
        }
        
        return gameUser
    }()
}
