//
//  String Extension.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/3.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit


extension String{
    static func getUUID()->String{
        let uuid:String = UUID().uuidString
        return uuid
    }
}
