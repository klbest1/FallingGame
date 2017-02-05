//
//  User.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/21.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

public class GameUser: NSObject {

     public var accountName: String?
     public var lastLoginTime: Date?
     public var isCurrentUser:Bool = false //  笔记
     public var ballImageUrl: String?
     public var profileImageUrl: String?
     public var result: Result?
    override init() {
        
    }
}
