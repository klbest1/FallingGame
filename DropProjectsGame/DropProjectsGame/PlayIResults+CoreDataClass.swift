//
//  PlayIResults+CoreDataClass.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import Foundation
import CoreData


public class PlayIResults: NSManagedObject {
    class func getUserResults(user:Users, context:NSManagedObjectContext)->PlayIResults?{
        let request:NSFetchRequest = PlayIResults.fetchRequest()
        request.predicate = NSPredicate.init(format: "user.accountName = %@", user.accountName!)
        if let findingResult  = (try? context.fetch(request))?.first{
            return findingResult;
        }
        return nil
    }
    
    class func playResultsUpdate(user:Users, result:Result, context:NSManagedObjectContext)->PlayIResults?{
        
        let request:NSFetchRequest = PlayIResults.fetchRequest()
        request.predicate = NSPredicate.init(format: "user.accountName = %@", user.accountName!)
        if let findingResult  = (try? context.fetch(request))?.first{
            findingResult.level = result.level;
            findingResult.score = result.score
            return findingResult;
        }else if let userResult = NSEntityDescription.insertNewObject(forEntityName: "PlayIResults", into: context) as? PlayIResults{
            userResult.user = user;
            userResult.score = result.score
            userResult.level = result.level
            print("用户名为：\(user.accountName)的游戏结果没有储存过,新建并插入第一条数据");
            return userResult
        }
        return nil
    }
}
