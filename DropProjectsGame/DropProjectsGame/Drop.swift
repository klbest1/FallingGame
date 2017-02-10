//
//  Drop.swift
//  DropProjectsGame
//
//  Created by lin kang on 17/2/9.
//  Copyright © 2017年 lin kang. All rights reserved.
//

import UIKit

class Drop: UIView {
    var explodeLayer :  CAEmitterLayer!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func startExplode()  {
        explodeLayer = self.createExplode()
        explodeLayer.birthRate = 1
        self.perform(#selector(stopExplode), with: nil, afterDelay: 0.5)
    }
    
    func stopExplode()  {
        explodeLayer.birthRate = 0
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
