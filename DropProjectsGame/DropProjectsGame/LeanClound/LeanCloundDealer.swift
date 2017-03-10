//
//  LeanCloundDealer.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/13.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

private let instance = LeanCloundDealer()

class LeanCloundDealer: NSObject {
    class func share()->LeanCloundDealer{
        return instance
    }
    
    func updateUserPlayingResult(user:GameUser,updateCompelete:@escaping (Bool)->())  {
        let query : AVQuery = GameUser.query()
        query.limit = 1
        query.whereKey(kAcountNameKey, equalTo: user.accountName!)
        query.findObjectsInBackground { (objects, error) in
            if((error) != nil){
                if ((error as? NSError)?.code != 101){
                    print("查询USER发生错误:\(error?.localizedDescription ?? "fuckxxxx")")
                    return
                }
            }
            if(objects?.count ==  0 || objects == nil){
                user.createUser(createSuccess: {(success) in
                    updateCompelete(success)
                })
            }else{
                if let downLoadUser = objects?.first as? GameUser {
                    let query : AVQuery = Result.query()
                    query.limit = 1
                    query.getObjectInBackground(withId: (downLoadUser.result?.objectId)!, block: { (object, error) in
                        if(object != nil){
                            let queryedResult = object as? Result
                            //游戏得分超过最高分才更新
                            if(queryedResult != nil && (queryedResult?.score)! < (user.result?.score)!) {
                                
                                let recordUser:GameUser = GameUser.init(className: "GameUser", objectId: downLoadUser.objectId!)
                                recordUser.result = Result.init(className: "Result", objectId: (downLoadUser.result?.objectId)!)
                                recordUser.profileImageUrl = (downLoadUser.profileImageUrl as! NSCopying) as? String
                                recordUser.updateUser(newUser: UserManager.share.currentUser,compelete: { (success)in
                                    updateCompelete(success)
                                    
                                })
                            }else{
                                updateCompelete(true)
                            }
                        }
                    })
                   
                }
            }
        }
    }
    //获取当前用户信息
    func selectUser(user:GameUser,complete:@escaping ((_ findedUser:GameUser?)->()))  {
        let query : AVQuery = GameUser.query()
        query.limit = 1
        query.whereKey(kAcountNameKey, equalTo: user.accountName!)
        query.findObjectsInBackground { (objects, error) in
            if((error) != nil){
                if ((error as? NSError)?.code != 101){
                    print("查询USER发生错误:\(error?.localizedDescription ?? "fuckxxxx")")
                    complete(_ :nil)
                    return
                }
            }
            
            if let downLoadUser = objects?.first as? GameUser {
                let query : AVQuery = Result.query()
                query.limit = 1
                let result = query.getObjectWithId((downLoadUser.result?.objectId)!) as? Result
                downLoadUser.result = result
                complete(_ :downLoadUser)
            }
        }
    }
    
    //更新排名，
    func updateRanking(complete:@escaping ((_ objects:[Result])->())) {
        let result = Result()
        result.updateRanking { (objects) in
            complete(objects)
        }
    }
    
    func updateUserInfo(oldUser:GameUser,newUser:GameUser,complete:@escaping (Bool)->()) {
        let query : AVQuery = GameUser.query()
        query.limit = 1
        query.whereKey(kAcountNameKey, equalTo: newUser.accountName!)
        query.findObjectsInBackground { (objects, error) in
            if objects != nil && (objects?.count)! > 0{
                complete(false)
            }else{
                let query : AVQuery = GameUser.query()
                query.limit = 1
                query.whereKey(kAcountNameKey, equalTo: oldUser.accountName!)
                query.findObjectsInBackground { (objects, error) in
                    if((error) != nil){
                        if ((error as? NSError)?.code != 101){
                            print("查询USER发生错误:\(error?.localizedDescription ?? "fuckxxxx")")
                            return
                        }
                    }
                    // 第一个参数是 className，第二个参数是 objectId
                    if let downLoadUser = objects?.first as? GameUser {
                        let recordUser:GameUser = GameUser.init(className: "GameUser", objectId: downLoadUser.objectId!)
                        if newUser.accountName != nil{
                            recordUser.setObject(newUser.accountName, forKey: kAcountNameKey)
                        }
                        if newUser.profileImageUrl != nil{
                            recordUser.setObject(newUser.profileImageUrl, forKey: kProfileUrlKey)
                        }
                        recordUser.saveInBackground({ (success, error) in
                            if (success){
                                complete(true)
                            }
                        })
                    }
                    
                }
            }
        }

    }
    
    /*
     #pragma mark - Safe way to call block
     
     #define safeBlock(first_param) \
     if (block) { \
     if ([NSThread isMainThread]) { \
     block(first_param, error); \
     } else {\
     dispatch_async(dispatch_get_main_queue(), ^{ \
     block(first_param, error); \
     }); \
     } \
     }
     */
  
    
    
}
