//
//  User.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

let kAcountNameKey = "accountName"
let kProfileUrlKey = "profileImageUrl"

public class GameUser: BaseObject {

     class func parseClassName()->String {
        return "GameUser";
    }

     public var accountName: String?
     public var lastLoginTime: Date?
     public var isCurrentUser:Bool = false 
     public var ballImageUrl: String?
     public var profileImageUrl: String?
     public var result: Result?
//    override init() {
//        super.init()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func createUser(createSuccess:@escaping (Bool)->())  {
        self.result?.createResult(user: self, compele: { (result) in
            self.setObject(self.accountName, forKey: kAcountNameKey)
            self.setObject(self.profileImageUrl, forKey: kProfileUrlKey)
            self.setObject(self.result, forKey: "result")
            self.saveInBackground { (success, error) in
                createSuccess(success)
                if (error != nil){
                    print("创建用户发生错误\(error?.localizedDescription ?? "fuck创建失败")")
                }
                if (success){
                    self.result?.setObject(self, forKey: "user")
                    self.result?.save()
                }
            }
        })
    }
    /*
     UPDATE 成绩表
     SET 排名 = T.排名
     FROM 成绩表,
     (select 姓名,学号,总分,row_number() over(order by 总分 desc)排名
     from 成绩表) T
     WHERE 成绩表.学号 = T.学号
     */
    /*
     NSString *cql = [NSString stringWithFormat:@"select * from %@ where status = 1", @"Todo"];
     [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error)
     {
     NSLog(@"results:%@", result.results);
     }];
     */
    func updateUser(newUser:GameUser,compelete:@escaping (Bool)->())  {
        self.result?.updateResult(user: newUser, compele: { (result) in
            self.setObject(self.profileImageUrl, forKey: kProfileUrlKey)
            self.setObject(result, forKey: "result")
            self.saveInBackground { (success, error) in
                compelete(success)
                if (error != nil){
                    print("更新用户玩耍结果发生错误\(error?.localizedDescription ?? "fuck更新失败")")
                }
                if success{
                    print("用户玩耍信息更新成功")
                    if (success){
                        self.result?.setObject(self, forKey: "user")
                        self.result?.save()
                    }
                }
            }
        })
    }
    
}
