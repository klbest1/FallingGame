//
//  Users+CoreDataProperties.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users");
    }

    @NSManaged public var accountName: String?
    @NSManaged public var lastLoginTime: Date?
    @NSManaged public var ballImageUrl: String?
    @NSManaged public var profileImageUrl: String?
    @NSManaged public var isCurrentUser: Bool
    @NSManaged public var result: PlayIResults?

}
