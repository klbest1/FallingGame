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

    class func getCurrentUser(context:NSManagedObjectContext)->Users?{
        let request:NSFetchRequest = Users.fetchRequest()
        request.predicate = NSPredicate.init(format: "isCurrentUser = true")
        if let user = (try? context.fetch(request))?.first  {
            return user
        }
        return nil
    }
    
    class func updateUser(user:GameUser,context:NSManagedObjectContext) ->Users?{
        let request:NSFetchRequest = Users.fetchRequest()
        request.predicate = NSPredicate.init(format: "accountName = %@", user.accountName!)
        if let user = (try? context.fetch(request))?.first {
            return user
        }else if let inserUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context) as? Users{
            inserUser.accountName = user.accountName
            inserUser.lastLoginTime = user.lastLoginTime
            inserUser.isCurrentUser = user.isCurrentUser
            inserUser.profileImageUrl = user.profileImageUrl
            inserUser.result = PlayIResults.playResultsUpdate(user: inserUser, result: user.result!, context: context)
            return inserUser
        }
        return nil
    }
    
    class func printAllUsers(context:NSManagedObjectContext) {
        let request:NSFetchRequest = Users.fetchRequest()
        let results = (try? context.fetch(request))?.first
        print("all Users:\(results?.result)")
    }
}
