//
//  result.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

public class Result: AVObject {
    //初始值
     public var score: Int32 = 0
     public var level: Int16 = 0
     public var passLevel:Bool = false
    // 注意 Number必须给初始值
     public var ranking:Int32 = 0
     public var user:GameUser?
    
    class func parseClassName()->String {
        return "Result";
    }
    
    func createResult(user:GameUser,compele: @escaping ((Result)->()))  {
        self.setObject(score, forKey: "score")
        self.setObject(level, forKey: "level")
        self.setObject(0, forKey: "ranking")
        self.saveInBackground { (success, error) in
            if (error != nil){
                print("创建结果发生错误\(error?.localizedDescription ?? "result 创建失败了")" )
            }
            if (success ){
                compele(self)
            }
        }
    }
    
    func updateResult(user:GameUser ,compele: @escaping ((Result)->())) {
        self.setObject(user.result!.score, forKey: "score")
        self.setObject(user.result!.level, forKey: "level")
        self.saveInBackground { (success, error) in
            if (error != nil){
                print("更新玩耍结果发生错误\(error?.localizedDescription ?? "result 更新失败了")" )
            }
            if (success ){
                compele(self)
            }
        }
    }
    
    func updateRanking(complete:@escaping ((_ objects:[Result])->()))  {
        let query : AVQuery = Result.query()
        query.order(byDescending: "score")
        query.findObjectsInBackground { (results, error) in
            if((error) != nil){
                if ((error as? NSError)?.code != 101){
                    print("查询玩耍结果发生错误:\(error?.localizedDescription ?? "fuckxxxx")")
                    return
                }
            }
            if (results != nil ){
                //笔记
                var updateResults = [Result]()
                for i in 0..<results!.count{
                    let resultItem = results![i] as? Result
                    let updateResultItem = Result(className: "Result", objectId: (resultItem?.objectId)!)
                    updateResultItem.setObject(i + 1, forKey: "ranking")
                    resultItem?.ranking = Int32( i + 1 )
                    updateResults.append(updateResultItem)
                }
                if (updateResults.count > 0){
                    AVObject.saveAll(inBackground: updateResults, block: { (succes, error) in
                        if((error) != nil){
                            if ((error as? NSError)?.code != 101){
                                print("更新排名发生错误:\(error?.localizedDescription ?? "fuckxxxx")")
                                return
                            }
                        }
                        complete(results as! [Result])
                        print("更新排名成功")
                    })
                }
            }
        }
    }
}
