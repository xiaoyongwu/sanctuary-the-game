//
//  GameScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/22/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var lastMenuPosition = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let world = SKSpriteNode(imageNamed: "light_world")
        world.xScale = 1
        world.yScale = 1
        world.position = CGPoint(x: -255, y: -255)
        //self.addChild(world)
        
        let gamepad = Gamepad(scene: self)
        gamepad.draw("default")
        
        
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        */
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
        */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
