//
//  GameScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/22/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var lastMenuPosition = 0
    var game : Game?
    var gamepad : Gamepad?
    
    var tileMap = JSTileMap(named: "town.tmx")
    var tileSize:CGSize!
    var xPointsToMovePerSecond:CGFloat = 0
    
    override func didMoveToView(view: SKView) {
        game = Game(view: view, scene: self)
        /* Setup your scene here */
        setupScene()
        
        gamepad = Gamepad(scene: self)
    }
    
    func setupScene() {
        backgroundColor = UIColor(red: 165.0/255.0, green: 216.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        physicsWorld.gravity = CGVectorMake(0, -9.8)
        physicsWorld.contactDelegate = self
        
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: 0)
        
        let point = tileMap.calculateAccumulatedFrame()
        let layer_meta = tileMap.layerNamed("meta")
        layer_meta.hidden = true

        println(point)
        tileMap.position = CGPoint(x: 0, y: 0)
        addChild(tileMap)
        
        addFloor()
    }
    
    func addFloor() {
        for var a = 0; a < Int(tileMap.mapSize.width); a++ {
            for var b = 0; b < Int(tileMap.mapSize.height); b++ {
                let layerInfo:TMXLayerInfo = tileMap.layers.firstObject as! TMXLayerInfo
                let point = CGPoint(x: a, y: b)
                //gid is the order of the tiles in Tiled starting at 1 (wierddd)
                let gid = layerInfo.layer.tileGidAt(layerInfo.layer.pointForCoord(point))
                
                if gid == 2 || gid == 9 || gid == 8{
                    let node = layerInfo.layer.tileAtCoord(point)
                    node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size)
                    node.physicsBody?.dynamic = false
                }
            }
        }
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
