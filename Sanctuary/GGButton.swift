//
//  GGButton.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/17/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation
import SpriteKit

class GGButton: SKSpriteNode {
    //var action: () -> Void
    var text: SKLabelNode
    
    init(text: String, color: UIColor, size: CGSize, buttonAction: () -> Void) {
        self.text = SKLabelNode(text: text)
        //self.action = buttonAction
        
        super.init(texture: nil, color: color, size: size)
        
        self.text.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-10)
        self.text.fontName = "AvenirNext-Bold"
        self.addChild(self.text)
        
        //self.userInteractionEnabled = true
    }
    
    /*
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            var touchLocation = touch.locationInNode(self)
        
            if self.containsPoint(touchLocation) {
                action()
            }
        }
    }
    */
    
    /**
    Required so XCode doesn't throw warnings
    */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}