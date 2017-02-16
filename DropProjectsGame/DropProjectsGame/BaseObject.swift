//
//  BaseObject.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/13.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

public class BaseObject: AVObject {
    func createLeanClass() {
        self.saveInBackground { (success, error) in
            if (error != nil){
                print(error?.localizedDescription ?? "创建类失败")
            }
        }
    }
}
