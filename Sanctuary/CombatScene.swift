//
//  CombatScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/9/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class CombatScene : SKScene, SKPhysicsContactDelegate {
    var monster : Monster!
    var player : Player!
    
    override func didMoveToView(view: SKView) {
        var combat = Combat(player: player, monster: monster)
        
        
    }
}
