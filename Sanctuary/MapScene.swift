//
//  MapScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/22/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import SpriteKit
import AVFoundation

class MapScene: SKScene, SKPhysicsContactDelegate {
    var lastMenuPosition = 0
    
    var mapName = ""
    var map:JSTileMap! //= JSTileMap(named: "town.tmx")
    var tileSize:CGSize!
    var mycamera = SKNode()
    var overlay = SKNode()
    var zones = [Zone]()
    var mobGroups = [Int: MonstersGroup]()
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    func playMusic(filename: String, loop: Bool = false) {
        let url = NSBundle.mainBundle().URLForResource(
            filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        do {
            backgroundMusicPlayer =
                try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            backgroundMusicPlayer = nil
        }
        if backgroundMusicPlayer == nil {
            print("Could not create audio player: \(error!)")
            return
        }
        
        var numberOfLoops = 0
        if loop {
            numberOfLoops = -1
        }
        
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.numberOfLoops = numberOfLoops
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
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
    
    func validTileCoord(tileCoord: CGPoint) -> Bool {
        return tileCoord.x >= 0
            && tileCoord.y >= 0
            && tileCoord.x <= self.map.mapSize.width
            && tileCoord.y <= self.map.mapSize.height
    }
    
    func rectForTileCoord(coord: CGPoint) -> CGRect {
        let x = coord.x * self.map.tileSize.width
        let mapHeight = self.map.mapSize.height * self.map.tileSize.height
        let y = mapHeight - ((coord.y + 1) * self.map.tileSize.height)
        
        return CGRectMake(x, y, self.map.tileSize.width, self.map.tileSize.height);
    }
    
    func collide(layer : TMXLayer) {
        let coordOffsets = [
            CGPointMake(0,1),
            CGPointMake(0,-1),
            CGPointMake(1,0),
            CGPointMake(-1,0),
            CGPointMake(1,-1),
            CGPointMake(-1,-1),
            CGPointMake(1,1),
            CGPointMake(-1,1)
        ]
        
        let playerCoord = layer.coordForPoint(game.player.targetPosition)
        
        // loop through tiles around player
        for tile : CGPoint in coordOffsets {
            // Get player collision rectangle
            let playerRect = game.player.collisionRectAtTarget()
            // Get tile coordinate
            let offset = tile
            let tileCoord = CGPointMake(playerCoord.x + offset.x, playerCoord.y + offset.y)
            
            let gid = layer.layerInfo.tileGidAtCoord(tileCoord)
            
            if gid != 0 {
                // Get intersection between player rect and tile
                let intersection = CGRectIntersection(playerRect, self.rectForTileCoord(tileCoord))
                
                if !CGRectIsNull(intersection) {
                    // Do we move the player horizontally or vertically?
                    
                    var resolveVertically = offset.x == 0 || (offset.y != 0 && intersection.size.height < intersection.size.width)
                    var positionAdjustment = CGPointZero
                    
                    //if resolveVertically {
                        // Calculate the distance we need to move the player.
                        positionAdjustment.y = intersection.size.height * offset.y;
                        // Stop player moving vertically.
                        //game.player.velocity = CGVectorMake(game.player.velocity!.dx, 0);
                    //} else {
                        // Calculate the distance we need to move the player.
                        positionAdjustment.x = intersection.size.width * -offset.x;
                        // Stop player moving horizontally.
                        //game.player.velocity = CGVectorMake(0, game.player.velocity!.dy);
                    //}
                    game.player.targetPosition = CGPointMake(game.player.targetPosition.x + positionAdjustment.x,
                        game.player.targetPosition.y + positionAdjustment.y);
                    
                }
            }
        }
    }
    
    func checkEncounter() -> Monster? {
        let zone = self.getPlayerInZone()
        if zone == nil {
            return nil
        }
        
        if let mob_gid = zone!.mob_gid as? Int {
            if mob_gid != 0 {
                let monsterGroup = mobGroups[mob_gid]
                let battle_monster = Int.random(0...game.encounter_base)
                let encounter_rate = zone!.encounter_rate
                if(battle_monster <= encounter_rate){
                    let monster = monsterGroup?.getRandomMonster()
                    return monster
                }
            }
        }
        return nil
    }
    
    func getPlayerInZone() -> Zone? {
        for zone in zones {
            if zone.isIn(game.player.position) {
                return zone
            }
        }
        
        return nil
    }
    
    func getZoneRects () {
        
        if let zoneLayer = self.map.groupNamed("zones") as? TMXObjectGroup {
            for object in zoneLayer.objects {
                if let zone = object as? NSDictionary {
                    let x = zone.valueForKey("x") as! CGFloat
                    let y = zone.valueForKey("y") as! CGFloat
                    let w = zone.valueForKey("width") as! NSString
                    let h = zone.valueForKey("height") as! NSString
                    let width = w.floatValue
                    let height = h.floatValue
                    let name = zone.valueForKey("name") as! String
                    let mid = zone.valueForKey("mob_gid") as! NSString
                    let mob_gid = mid.integerValue
                    let rect = CGRectMake(x, y, CGFloat(width), CGFloat(height))
                    let er = zone.valueForKey("encounter_rate") as? NSString
                    var encounter_rate = 1
                    if er != nil {
                        encounter_rate = er!.integerValue
                    }
                    let newZone = Zone(rect: rect, name: name, m_gid: mob_gid, encounter_rate: encounter_rate)
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
        self.mycamera.position = CGPointMake(size.width * 0.5, size.height * 0.5)
        self.map.addChild(mycamera)
        
        // Set up player
        let mapStartPoint = getMarkerPosition("startpoint")
        game.setPlayerMapPosition(self.mapName, position: mapStartPoint)
        self.map.addChild(game.player.sprite)
        
    }
    
    func updateView() {
        
        // Calculate clamped x and y locations
        var x = fmax(self.mycamera.position.x, self.size.width * 0.5)
        var y = fmax(self.mycamera.position.y, self.size.height * 0.38)
        x = fmin(x, (self.map.mapSize.width * self.map.tileSize.width) - (self.size.width * 0.5))
        y = fmin(y, (self.map.mapSize.height * self.map.tileSize.height) - (self.size.height * 0.38))
        
        // Debug info
        // To add here if needed
        self.overlay.removeAllChildren()
        let lives = SKLabelNode(text: "Lives: \(game.player.lives)")
        lives.fontName = "AvenirNext-Bold"
        lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lives.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        lives.position = CGPointMake(CGRectGetMaxX(self.frame) - 30, CGRectGetMaxY(self.frame) - 160)
        self.overlay.addChild(lives)
        
        
        // Move player
        game.player.update(self)
        if (game.player.position != game.player.targetLocation) {
            if let monster = checkEncounter() as Monster! {
                game.player.stopMoving()
                backgroundMusicPlayer.stop()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            let touchLocation = touch.locationInNode(self.map)
            game.player.targetLocation = touchLocation
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.mycamera.position = CGPointMake(game.player.position.x, game.player.position.y)
        
        /* Called before each frame is rendered */
        self.overlay.removeAllChildren()
        updateView()
        
        /*
        var coordinates = self.camera.position
        // coordinates = self.map.position
        let coord_label = SKLabelNode(text: "x: \(coordinates.x) y: \(coordinates.y)")
        coord_label.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.overlay.addChild(coord_label)
        */
    }
}

