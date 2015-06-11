
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


class Combat {
    var player : Player
    var monster : Monster
    
    init (player: Player, monster: Monster) {
        self.player = player
        self.monster = monster
    }
    
    func atk()->Int {
        let Base = 5     //player.atk+arma.dmg
        return Base
    }
    
    func calc_damage()->Int {
        let damage = ((2*player.level+10)/250) * (player.atk/monster.def) * self.atk()+2
        return damage
    }
    
    func check_end () {
        if(player.hp<=0) {
            GameOver();
        }
        if(monster.hp<=0) {
            MapScene()
        }
    }
}

