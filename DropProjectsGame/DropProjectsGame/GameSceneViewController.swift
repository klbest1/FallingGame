//
//  GameSceneViewController.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/1/7.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class GameSceneViewController: UIViewController {

    var gameSceneView:GameSceneView?  = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GameScene";
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let viewSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 49);

        gameSceneView = GameSceneView(frame:CGRect(origin: CGPoint.zero, size: viewSize));

        self.view.addSubview(gameSceneView!);
        
       testDicDecoding()
    }

    override func viewDidAppear(_ animated: Bool)
   {
        super.viewDidAppear(animated);
        gameSceneView!.animate = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        gameSceneView!.animate = false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testDataBase() {
        let me:GameUser = GameUser()
        me.accountName = "kanglin"
        me.ballImageUrl = "http://xx.com"
        me.lastLoginTime = "20/01/2017"
        me.profileImageUrl = "http://xx.com"
        
        let result = Result();
        result.level = 4;
        result.score = 4000
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate?.persistentContainer.viewContext.perform {
            //            _ = Users.userWithUserInfo(gameUser:me, result:result ,context: appDelegate!.persistentContainer.viewContext)
            _ = PlayIResults.playResultsUpdate(user: me, result: result, context: (appDelegate?.persistentContainer.viewContext)!)
            
            
            do{
                try appDelegate?.persistentContainer.viewContext.save()
            }catch let error as NSError{
                print(error);
            }
        }
        Users.printAllUsers(context: (appDelegate?.persistentContainer.viewContext)!)
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        print("path\(path)");
    }

    func testDicDecoding() {
        let _ = LevelManager()
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
