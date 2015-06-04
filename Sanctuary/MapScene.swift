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
    
    var mapName = "town.tmx"
    var tileMap:JSTileMap! //= JSTileMap(named: "town.tmx")
    var tileSize:CGSize!
    
    func setMap () {
        tileMap = JSTileMap(named: mapName)
    }
    
    override func didMoveToView(view: SKView) {
        game = Game(view: view, scene: self)
        /* Setup your scene here */
        setupScene()
    }
    
    func setupScene() {
        setMap()
        backgroundColor = UIColor(red: 165.0/255.0, green: 216.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: 0)
        
        let point = tileMap.calculateAccumulatedFrame()
        let layer_meta = tileMap.layerNamed("meta")
        layer_meta.hidden = true
        
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
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        let meta_layer = tileMap.layerNamed("meta")
        let coord_touch = meta_layer.coordForPoint(location)
        let tile = meta_layer.layerInfo.tileGidAtCoord(coord_touch)
        
        let alert_view = UIAlertView(title: "Tile GID", message: "\(tile)", delegate: nil, cancelButtonTitle: "Close")
        
        alert_view.show()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
