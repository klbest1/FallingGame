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
    
    static func getRandomString(length:Int) -> String {
        let sourceStr:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var userName = ""
        for _ in 0..<length{
            let randomIndex = arc4random() % UInt32((sourceStr as NSString).length)
            userName = userName.appending(sourceStr[Int(randomIndex)])
        }
        return userName
    }
    
}

//笔记
extension String {
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }
    
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }
}
