//
//  PlayIResults+CoreDataProperties.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import Foundation
import CoreData


extension PlayIResults {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayIResults> {
        return NSFetchRequest<PlayIResults>(entityName: "PlayIResults");
    }

    @NSManaged public var score: Int32
    @NSManaged public var user: Users?
    @NSManaged public var level: Int16

}
