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
        self.mapName = "town.tmx"
        game = Game(view: view, scene: self)
        
        var mGroup1 = MonstersGroup(monsters: [Monster(name: "Spider")])
        var mobGroups = [
            1: mGroup1
        ]
        self.setMonsterGroups(mobGroups)
        /* Setup your scene here */
        setupScene()
    }
    
    
}




