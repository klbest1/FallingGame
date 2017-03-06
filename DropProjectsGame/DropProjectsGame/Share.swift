//
//  Share.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/3/5.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import Foundation

let keyLinkURL = "linkURL"
let keyTagName = "linkTagName"
let keyTitle = "linkTitle"
let keyLinkDesc = "linkDesc"
let keyLinkImg = "linkImgName"

class Share: AVObject {
    //注意：Key值和对象名保持一致
    var linkURL:String = kLinkURL
    var linkTagName:String = kLinkTagName
    var linkTitle:String = kLinkTitle
    var linkDesc:String = kLinkDescription
    var linkImgName:String = kLinkImgName
    
    class func parseClassName()->String {
        return "Share";
    }
    
     func getShareData(compelete:@escaping (Share)->())  {
        let query:AVQuery = Share.query()
        query.findObjectsInBackground { (objects, error) in
            if((error) != nil){
                if ((error as? NSError)?.code != 101){
                    print("查询Share发生错误:\(error?.localizedDescription ?? "fuckxxxx")")
                    return
                }
            }
            
            if objects != nil && (objects?.count)! > 0{
                compelete(objects?.first as! Share)
            }else {
                self.setObject(self.linkURL, forKey: keyLinkURL)
                self.setObject(self.linkTagName, forKey: keyTagName)
                self.setObject(self.linkTitle, forKey: keyTitle)
                self.setObject(self.linkDesc, forKey: keyLinkDesc)
                self.setObject(self.linkImgName, forKey: keyLinkImg)
               self.saveInBackground({ (success, error) in
                if( error != nil){
                    print("创建Share表出错\(error)")
                }else{
                    compelete(self)
                }
               })
            }
        }
    }
    
    func updateShare(compelete:@escaping (Bool)->()){
        let query:AVQuery = Share.query()
        query.findObjectsInBackground { (objects, error) in
            if((error) != nil){
                if ((error as? NSError)?.code != 101){
                    print("查询Share发生错误:\(error?.localizedDescription ?? "fuckxxxx")")
                    return
                }
            }
            if objects != nil && (objects?.count)! > 0{
                let shareFromRemote = objects?.first as! Share
                let updateShare = Share.init(className:"Share",objectId:shareFromRemote.objectId!)
                updateShare.setObject(self.linkURL, forKey: keyLinkURL)
                updateShare.setObject(self.linkTagName, forKey: keyTagName)
                updateShare.setObject(self.linkTitle, forKey: keyTitle)
                updateShare.setObject(self.linkDesc, forKey: keyLinkDesc)
                updateShare.setObject(self.linkImgName, forKey: keyLinkImg)
                updateShare.saveInBackground({ (success, error) in
                    compelete(success)
                    if( error != nil){
                        print("更新Share表出错\(error)")
                    }else{
                        print("更新Share表成功!")
                    }
                })
            }
        }
     
        
    }
    
}
