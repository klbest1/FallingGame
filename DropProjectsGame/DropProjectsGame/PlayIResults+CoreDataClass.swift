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
    class func playResultsWithResults(user:Users, result:Result?, context:NSManagedObjectContext)->PlayIResults?{
        let request:NSFetchRequest = PlayIResults.fetchRequest()
        request.predicate = NSPredicate.init(format: "user.accountName = %@", user.accountName!)
        if let findingResult  = (try? context.fetch(request))?.first{
            return findingResult;
        }else if let userResult = NSEntityDescription.insertNewObject(forEntityName: "PlayIResults", into: context) as? PlayIResults{
            userResult.user = user;
            userResult.score = result!.score
            userResult.level = result!.level
            return userResult
        }
        return nil
    }
    
    class func playResultsUpdate(user:GameUser, result:Result, context:NSManagedObjectContext)->PlayIResults?{
        
        let request:NSFetchRequest = PlayIResults.fetchRequest()
        request.predicate = NSPredicate.init(format: "user.accountName = %@", user.accountName!)
        if let findingResult  = (try? context.fetch(request))?.first{
            findingResult.level = result.level;
            findingResult.score = result.score
            return findingResult;
        }else{
            print("没有找到文件用户名为：\(user.accountName)的游戏结果");
        }
        return nil
    }
}
