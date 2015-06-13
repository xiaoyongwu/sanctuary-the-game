//
//  CombatScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/9/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class CombatScene : SKScene, SKPhysicsContactDelegate {
    var mapScene = MapScene()
    
    override func didMoveToView(view: SKView) {
        var player = mapScene.player
        var monster = mapScene.monster
        //var combat = Combat(player: player, monster: monster!)
        
        var background = SKSpriteNode(imageNamed: "Grassland")
        background.position = CGPointMake(0, 0)

        self.addChild(background)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            let mapView = self.view!
        }
        
    }
    
}
