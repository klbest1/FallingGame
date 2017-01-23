//
//  Users+CoreDataClass.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import Foundation
import CoreData


public class Users: NSManagedObject {

    class func userWithUserInfo( gameUser:GameUser ,result:Result ,context:NSManagedObjectContext)->Users?{
        let request:NSFetchRequest = Users.fetchRequest()
        request.predicate = NSPredicate.init(format: "accountName = %@", gameUser.accountName!)
        if let user = (try? context.fetch(request))?.first  {
            return user
        }else if let insertUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context) as? Users{
            insertUser.accountName = gameUser.accountName
            insertUser.ballImageUrl = gameUser.ballImageUrl
            insertUser.lastLoginTime = gameUser.lastLoginTime
            insertUser.profileImageUrl = gameUser.profileImageUrl
            insertUser.result = PlayIResults.playResultsWithResults(user:insertUser , result:result,context: context)
        }
        return nil
    }
    
    class func printAllUsers(context:NSManagedObjectContext) {
        let request:NSFetchRequest = Users.fetchRequest()
        let results = (try? context.fetch(request))?.first
        print("all Users:\(results?.result)")
    }
}
