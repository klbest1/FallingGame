//
//  Dictionary Extention.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/22.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

let classNameKey = "className"
let resultsKey = "results"

extension NSDictionary{

    static func decodeDic(dicOrigin:[String:AnyObject])->[AnyObject]?{
        
        if let className:String = (dicOrigin[classNameKey] as? String){
//            print("xx:\(NSClassFromString(className) as? NSObject.Type)")
            if let classType = (NSClassFromString(className) as? NSObject.Type){
                var objects = [AnyObject]()
                
                let results:[AnyObject] = (dicOrigin[resultsKey] as? [AnyObject])!
                for var dicItem in results{
                    let instance = classType.init()
                    let keys  = (dicItem as! NSDictionary).allKeys
                    for key in keys{
                        let value:AnyObject = dicItem[key] as AnyObject;
                        if instance.responds(to: NSSelectorFromString(key as! String)) {
                            instance.setValue(value, forKey: key as! String)
                        }
                    }
                    objects.append(instance)
                }
                return objects

            }else{
                print("\(className)没有此类型")
            }
        }
        return nil
    }
}
