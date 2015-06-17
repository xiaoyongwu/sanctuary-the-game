
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

var game = Game(player : Player(name : "Player 1"))

enum Directions {
    case up
    case down
    case left
    case right
}

enum Scenary {
    case Meadow
    case Forest
    case Desert
    case Snow
}

class Game {
    static let POINTS_PER_LEVEL = 5
    enum ATTRS {
        case atk
        case def
        case spd
        case hp
        case stam
    }
    
    let encounter_base = 200
    // var view : SKView?
    var current_scene : SKScene?
    var player : Player
    var monster : Monster?
    var view : SKView?

    var combat_log = ""
    var current_map = ""
    
    init (player: Player) {
        self.player = player
    }
    
    func enterScene(scene : SKScene) {
        self.current_scene = scene
        self.view = scene.view!
        if scene.isKindOfClass(MapScene.self) {
            var mapScene = scene as! MapScene
            self.current_map = mapScene.mapName
        }
    }
    
    func setPlayerMapPosition(map: String, position : CGPoint) {
        if let current_position = self.player.targetLocation {
            if map != self.current_map {
                self.player.position = position
                self.player.targetLocation = position
            }
        } else {
            self.player.position = position
            self.player.targetLocation = position
        }
    }
    
    func gameover() {
        let scene = GameOver(size: self.current_scene!.size)
        scene.scaleMode = .ResizeFill
        scene.size = view!.bounds.size
        
        view!.presentScene(scene)
    }
}


class Actor {
    var name : String
    
    var atk, def, spd : Int
    
    var hp, stam : Int
    var cur_hp : Int
    
    var level : Int
    
    init (name : String, level: Int, atk : Int, def : Int, spd : Int, hp : Int, stam : Int) {
        self.name = name
        self.level = level
        self.atk = atk
        self.def = def
        self.spd = spd
        self.hp = hp
        self.cur_hp = self.hp
        self.stam = stam
    }
    
    func isDead() -> Bool {
        return cur_hp <= 0
    }
    
    func doDamage(damage: Int) -> Bool {
        cur_hp -= damage
        return isDead()
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

