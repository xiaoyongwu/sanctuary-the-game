//
//  GameScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/22/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        let gameover_text = SKLabelNode(fontNamed: "Chalkduster")
        gameover_text.text = "GAME OVER"
        gameover_text.fontColor = UIColor(hex: 0x660000)
        gameover_text.fontSize = 80
        gameover_text.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(gameover_text)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    }
}
