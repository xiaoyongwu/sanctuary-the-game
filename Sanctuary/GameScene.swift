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
        playMusic("Opening 4.mp3", loop: true)
        
        var mobGroups = [
            1: MonstersGroup(monsters: [Monster.Spider, Monster.Bandit]),
            2: MonstersGroup(monsters: [Monster.Spider, Monster.Bandit, Monster.Bat]),
            3: MonstersGroup(monsters: [Monster.Bat, Monster.Demon, Monster.Ghost]),
            4: MonstersGroup(monsters: [Monster.Demon, Monster.Ghost]),
            5: MonstersGroup(monsters: [Monster.God])
            
        ]
        self.setMonsterGroups(mobGroups)
        
        super.didMoveToView(view)
    }
    
    
}