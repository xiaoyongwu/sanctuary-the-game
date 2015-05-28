//
//  Player.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/27/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class Player : Actor {
    var exp, level : Int
    var freepoints : Int
    var cur_hp : Int
    
    var movement : PlayerMovement
    var sprite : SKSpriteNode
    
    init (name : String) {
        self.exp = 0
        self.level = 1
        self.freepoints = 0
        self.cur_hp = 20
        
        self.movement = PlayerMovement()
        self.sprite = SKSpriteNode(texture: self.movement.movement_frame60())
        
        super.init(name: name, atk: 5, def: 5, spd: 5, hp : 20, stam : 10)
    }
    
    func give_points() {
        self.freepoints += Game.POINTS_PER_LEVEL
    }
    
    func levelup(exp : Int) -> Bool {
        self.exp += exp
        
        let current_level = Int(log2(Double(self.exp)))
        if (current_level > self.level) {
            self.level++
            self.give_points()
            return true
        }
        
        return false
    }
    
    func set_position(pos : CGPoint) {
        self.sprite.position = pos
    }
    
}
