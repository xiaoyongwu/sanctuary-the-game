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
    var camera = SKNode()
    var overlay = SKNode()
    var player = Player(name: "Aer")
    
    func setMap () {
        map = JSTileMap(named: mapName)
    }
    
    override func didMoveToView(view: SKView) {
        game = Game(view: view, scene: self)
        /* Setup your scene here */
        setupScene()
    }
    
    func getMarkerPosition (markerName : String) -> CGPoint {
        var position : CGPoint = CGPointMake(0,0)
        
        if let markerLayer : TMXObjectGroup = self.map.groupNamed("markers") as? TMXObjectGroup {
            if let marker : NSDictionary = markerLayer.objectNamed(markerName) as? NSDictionary{
                position = CGPointMake(marker.valueForKey("x") as! CGFloat, marker.valueForKey("y") as! CGFloat)
            }
        }
        
        return position
    }
    
    func setupScene() {
        // Load Level
        setMap()
        let layer_meta = map.layerNamed("meta")
        self.map.zPosition = 0
        backgroundColor = UIColor(red: 165.0/255.0, green: 216.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        layer_meta.hidden = true
        self.addChild(map)
        
        // Set up overlay
        self.overlay.zPosition = 10000
        self.addChild(overlay)
        
        // Set up camera
        self.camera.position = CGPointMake(size.width * 0.5, size.height * 0.5)
        self.map.addChild(camera)
        
        // Set up player
        self.player.position = getMarkerPosition("startpoint")
        self.player.targetLocation = self.player.position
        self.map.addChild(self.player.sprite)
        
    }
    
    func updateView() {
        
        // Calculate clamped x and y locations
        var x = fmax(self.camera.position.x, self.size.width * 0.5)
        var y = fmax(self.camera.position.y, self.size.height * 0.38)
        x = fmin(x, (self.map.mapSize.width * self.map.tileSize.width) - (self.size.width * 0.5))
        y = fmin(y, (self.map.mapSize.height * self.map.tileSize.height) - (self.size.height * 0.38))
        
        // Debug info
        /*
        var values_label = SKLabelNode(text: "mapsize: \(self.map.mapSize.width) x \(self.map.mapSize.height)\ntilesize: \(self.map.tileSize.width) x \(self.map.tileSize.height)\nself: \(self.size.width) x \(self.size.height)")
        values_label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50)
        self.overlay.addChild(values_label)
        */
        
        // Move player
        self.player.update()
        
        // Center veiw on position of camera in the world
        self.map.position = CGPointMake((self.size.width * 0.5) - x,
                                            (self.size.height * 0.5) - y)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            var touchLocation = touch.locationInNode(self.map)
            /*
            var previousTouchLocation = touch.previousLocationInNode(self)
            var movement = CGPointMake(touchLocation.x - previousTouchLocation.x,
                touchLocation.y - previousTouchLocation.y)
            
            var targetLocation =  CGPointMake(self.camera.position.x + movement.x,
                self.camera.position.y + movement.y)
            */
            self.player.targetLocation = touchLocation
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.camera.position = CGPointMake(self.player.position.x, self.player.position.y)
        
        /* Called before each frame is rendered */
        self.overlay.removeAllChildren()
        updateView()
        
        var coordinates = self.camera.position
        // coordinates = self.map.position
        let coord_label = SKLabelNode(text: "x: \(coordinates.x) y: \(coordinates.y)")
        coord_label.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.overlay.addChild(coord_label)
    }
}
