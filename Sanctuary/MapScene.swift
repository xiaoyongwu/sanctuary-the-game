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
    
    var mapName = ""
    var map:JSTileMap! //= JSTileMap(named: "town.tmx")
    var tileSize:CGSize!
    var camera = SKNode()
    var overlay = SKNode()
    var zones = [Zone]()
    var mobGroups = [Int: MonstersGroup]()
    
    func setMonsterGroups (mob_groups : [Int: MonstersGroup]) {
        mobGroups = mob_groups
    }
    
    func setMap () {
        map = JSTileMap(named: mapName)
    }
    
    override func didMoveToView(view: SKView) {
        game.enterScene(self)
        /* Setup your scene here */
        setupScene()
    }
    
    func checkEncounter() -> Monster? {
        if let mob_gid = getPlayerInZone() as? Int {
            if mob_gid != 0 {
                var monsterGroup = mobGroups[mob_gid]
                let battle_monster = arc4random_uniform(150)
                if(battle_monster < 1){
                    var monster = monsterGroup?.getRandomMonster(1.0)
                    return monster
                }
            }
        }
        return nil
    }
    
    func getPlayerInZone() -> Int {
        for zone in zones {
            if zone.isIn(game.player.position) {
                return zone.mob_gid
            }
        }
        
        return 0
    }
    
    func getZoneRects () {
        
        if let zoneLayer = self.map.groupNamed("zones") as? TMXObjectGroup {
            for object in zoneLayer.objects {
                if let zone = object as? NSDictionary {
                    let x = zone.valueForKey("x") as! CGFloat
                    let y = zone.valueForKey("y") as! CGFloat
                    var w = zone.valueForKey("width") as! NSString
                    var h = zone.valueForKey("height") as! NSString
                    var width = w.floatValue
                    var height = h.floatValue
                    let name = zone.valueForKey("name") as! String
                    let mid = zone.valueForKey("mob_gid") as! NSString
                    let mob_gid = mid.integerValue
                    var rect = CGRectMake(x, y, CGFloat(width), CGFloat(height))
                    let newZone = Zone(rect: rect, name: name, m_gid: mob_gid)
                    self.zones.append(newZone)
                }
            }
        }
    }
    
    func getMarkerPosition (markerName : String) -> CGPoint {
        var position : CGPoint = CGPointMake(0,0)
        
        if let markerLayer = self.map.groupNamed("markers") as? TMXObjectGroup {
            if let marker = markerLayer.objectNamed(markerName) as? NSDictionary{
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
        getZoneRects()
        self.addChild(map)
        
        // Set up overlay
        self.overlay.zPosition = 10000
        self.addChild(overlay)
        
        // Set up camera
        self.camera.position = CGPointMake(size.width * 0.5, size.height * 0.5)
        self.map.addChild(camera)
        
        // Set up player
        let mapStartPoint = getMarkerPosition("startpoint")
        game.setPlayerMapPosition(self.mapName, position: mapStartPoint)
        self.map.addChild(game.player.sprite)
        
    }
    
    func updateView() {
        
        // Calculate clamped x and y locations
        var x = fmax(self.camera.position.x, self.size.width * 0.5)
        var y = fmax(self.camera.position.y, self.size.height * 0.38)
        x = fmin(x, (self.map.mapSize.width * self.map.tileSize.width) - (self.size.width * 0.5))
        y = fmin(y, (self.map.mapSize.height * self.map.tileSize.height) - (self.size.height * 0.38))
        
        // Debug info
        // To add here if needed
        
        // Move player
        game.player.update()
        if (game.player.position != game.player.targetLocation) {
            if let monster = checkEncounter() as Monster! {
                game.player.stopMoving()
                game.monster = monster
                // let combat_alert = UIAlertView(title: monster.name, message: "Found", delegate: nil, cancelButtonTitle: "Close")
                // combat_alert.show()
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
                
                let scene = CombatScene(size: self.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                
                self.view!.presentScene(scene, transition: transition)
            }
            
        }
        
        // Center veiw on position of camera in the world
        self.map.position = CGPointMake((self.size.width * 0.5) - x,
                                            (self.size.height * 0.5) - y)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            var touchLocation = touch.locationInNode(self.map)
            game.player.targetLocation = touchLocation
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.camera.position = CGPointMake(game.player.position.x, game.player.position.y)
        
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

