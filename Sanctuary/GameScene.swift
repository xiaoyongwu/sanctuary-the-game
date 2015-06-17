//
//  GameScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/22/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import SpriteKit

class GameScene: MapScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.mapName = "town.tmx"
        
        var mGroup1 = MonstersGroup(monsters: [Monster.Spider, Monster.Bandit])
        var mobGroups = [
            1: mGroup1
        ]
        self.setMonsterGroups(mobGroups)
        
        super.didMoveToView(view)
    }
    
    
}