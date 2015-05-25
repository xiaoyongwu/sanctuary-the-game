
//
//  Game.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/24/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin

class Game {
    static let POINTS_PER_LEVEL = 5
    enum ATTRS {
        case atk
        case def
        case spd
        case hp
        case stam
    }
    
    var view : SKView
    var current_scene : SKScene
    
    init (view: SKView, scene: SKScene) {
        self.view = view
        self.current_scene = scene
    }
    
    func gameover() {
        let scene = GameOver(size: self.current_scene.size)
        scene.scaleMode = .ResizeFill
        scene.size = self.view.bounds.size
        
        self.view.presentScene(scene)
    }
}


class Actor {
    var name : String
    
    var atk, def, spd : Int
    
    var hp, stam : Int
    
    init (name : String, atk : Int, def : Int, spd : Int, hp : Int, stam : Int) {
        self.name = name
        self.atk = atk
        self.def = def
        self.spd = spd
        self.hp = hp
        self.stam = stam
    }
}

class Monster : Actor {
    func exp_reward () -> Int {
        var attributes_sum = self.atk + self.def + self.spd + (self.hp/4) + (self.stam/2)
        
        return attributes_sum / 5
    }
}

class Player : Actor {
    var exp, level : Int
    var freepoints : Int
    var cur_hp : Int
    
    init (name : String) {
        self.exp = 0
        self.level = 1
        self.freepoints = 0
        self.cur_hp = 20
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
}

class Combat {
    var player : Player
    var monster : Monster
    
    init (player: Player, monster: Monster) {
        self.player = player
        self.monster = monster
    }
    
    func check_end () {
        
    }

}

