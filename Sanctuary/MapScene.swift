//
//  MapScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/22/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import SpriteKit

class MapScene: SKScene, SKPhysicsContactDelegate {
    var lastMenuPosition = 0
    var game : Game?
    
    var mapName = ""
    var map:JSTileMap! //= JSTileMap(named: "town.tmx")
    var tileSize:CGSize!
    var camera:SKSpriteNode!
    
    func setMap () {
        map = JSTileMap(named: mapName)
    }
    
    override func didMoveToView(view: SKView) {
        game = Game(view: view, scene: self)
        /* Setup your scene here */
        setupScene()
    }
    
    func setupScene() {
        setMap()
        backgroundColor = UIColor(red: 165.0/255.0, green: 216.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        self.camera = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(5, 5))
        self.camera.position = CGPointMake(size.width * 0.5, size.height * 0.5)
        self.map.addChild(camera)
        
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: 0)
        
        let point = map.calculateAccumulatedFrame()
        let layer_meta = map.layerNamed("meta")
        layer_meta.hidden = true
        
        map.position = CGPoint(x: 0, y: 0)
        addChild(map)
        
        addFloor()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            var touchLocation = touch.locationInNode(self)
            var previousTouchLocation = touch.previousLocationInNode(self)
            var movement = CGPointMake(touchLocation.x - previousTouchLocation.x,
                                       touchLocation.y - previousTouchLocation.y)
            
            self.camera.position = CGPointMake(self.camera.position.x + movement.x,
                                               self.camera.position.y + movement.y)
        }
    }
    
    func addFloor() {
        for var a = 0; a < Int(map.mapSize.width); a++ {
            for var b = 0; b < Int(map.mapSize.height); b++ {
                let layerInfo:TMXLayerInfo = map.layers.firstObject as! TMXLayerInfo
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
    
    func updateView() {
        
        // Center veiw on position of camera in the world
        self.map.position = CGPointMake((self.size.width * 0.5 - self.camera.position.x),
                                            (self.size.height * 0.5 - self.camera.position.y))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /*
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        let meta_layer = tileMap.layerNamed("meta")
        let coord_touch = meta_layer.coordForPoint(location)
        let tile = meta_layer.layerInfo.tileGidAtCoord(coord_touch)
        
        let alert_view = UIAlertView(title: "Tile GID", message: "\(tile)", delegate: nil, cancelButtonTitle: "Close")
        
        // alert_view.show()
        */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        updateView()
    }
}
