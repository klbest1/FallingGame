//
//  result.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

public class Result: AVObject {
     public var score: Int32 = 0
     public var level: Int16 = 0
     public var passLevel:Bool = false
     public var rangking:Int?
    
    class func parseClassName()->String {
        return "Result";
    }
    
    func createResult(compele: @escaping ((Result)->()))  {
        self.setObject(score, forKey: "score")
        self.setObject(level, forKey: "level")
        self.saveInBackground { (success, error) in
            if (error != nil){
                print("创建结果发生错误\(error?.localizedDescription ?? "result 创建失败了")" )
            }
            if (success ){
                self.updateRanking()
                compele(self)
            }
        }
    }
    
    func updateResult(newResult:Result ,compele: @escaping ((Result)->())) {
        self.setObject(newResult.score, forKey: "score")
        self.setObject(newResult.level, forKey: "level")
        self.saveInBackground { (success, error) in
            if (error != nil){
                print("更新玩耍结果发生错误\(error?.localizedDescription ?? "result 更新失败了")" )
            }
            if (success ){
                self.updateRanking()
                compele(self)
            }
        }
    }
    
    func updateRanking()  {
        let cql:String = "update Result set ranking = T.ranking from Result,(select score,row_number() over(order by ranking desc)ranking from Result) T where Result.score = T.score"
        AVQuery.doCloudQueryInBackground(withCQL: cql, callback: { (results, error) in
            if(error != nil){
                print("更新排名发生错误\(error?.localizedDescription)")
                return
            }
            print("排名更新成功，恭喜！")
        })
    }
}
