//
//  Dictionary Extention.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/22.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

let classNameKey = "className"

extension NSDictionary{

    static func decodeDic(dicOrigin:[String:AnyObject])->AnyObject?{
        
        if let className:String = (dicOrigin[classNameKey] as? String){
//            print("xx:\(NSClassFromString(className) as? NSObject.Type)")
            if let classType = (NSClassFromString(className) as? NSObject.Type){
                //获取类实例
                let instance = classType.init()

                let keys = dicOrigin.keys;
                
                for  key in keys
                {
                    if key != classNameKey {
                        var value = dicOrigin[key];
                        //是数组，那么进行数组处理
                        if (value is NSArray) {
                            value = handleArray(originArray: value as! NSArray)
                        //是字典，那么是类，进行类处理
                        }else if (value is NSDictionary ){
                            value = decodeDic(dicOrigin: value as! [String : AnyObject]) as AnyObject?
                        }
                        //类属性赋值
                        if instance.responds(to: NSSelectorFromString(key)) {
                            instance.setValue(value, forKey: key )
                        }
                    }
                    
                }
                return instance ;
            }else{
                print("\(className)没有此类型")
            }
        }
        return nil
    }
    
    static func handleArray(originArray:NSArray)->NSArray{
        var arrayResult =  [AnyObject]()
        for item in originArray{
            var value = item
            //是数组继续迭代
            if item is NSArray {
               value = handleArray(originArray: item as! NSArray)
            }else if item is [String:AnyObject] {
                //是字典转为类的处理
                value =  NSDictionary.decodeDic(dicOrigin: item as! [String:AnyObject]) as AnyObject!
            }
            //其他类型则加入数组
            arrayResult.append(value as AnyObject)
        }
        return arrayResult as NSArray
    }
}


