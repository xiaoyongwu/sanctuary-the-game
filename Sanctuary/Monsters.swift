//
//  Monsters.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/27/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class Monster : Actor {
    
    var sprite : SKSpriteNode
    var attacks : [() -> Attack]
    
    init (name : String, level: Int, sprite : String, attacks : [() -> Attack]) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.attacks = attacks
        //self.sprite = colocar o sprite do monstro e etc.
        
        super.init(name: name, level: level, atk: 5, def: 5, spd: 5, hp : 20, stam: 20)
    }
    
    func exp_reward () -> Int {
        var attributes_sum = self.atk + self.def + self.spd + (self.hp/4) + (self.stam/2)
        
        return attributes_sum / 5
    }
    
    func attack (target : Actor) -> Bool {
        var attack = self.attacks[Int.random(0...attacks.count-1)]()
        var killed = attack.perform(target, attacker: self)
        
        return killed
    }
    
    static func Spider () -> Monster {
        var monster = Monster(name: "Spider", level:1, sprite: "Spider", attacks: [Attack.Bite])
        let atk_range = 8...12
        let def_range = 9...11
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        
        return monster
    }
    
    static func Bandit () -> Monster {
        var monster = Monster(name: "Bandit", level:1, sprite: "Bandit", attacks: [Attack.SwordAttack])
        let atk_range = 6...12
        let def_range = 4...8
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        
        return monster
    }
}

class MonstersGroup {
    var monsters : [() -> Monster]
    
    init (monsters : [() -> Monster]) {
        self.monsters = monsters
    }
    
    func getRandomMonster(roll : Float) -> Monster {
        let rand_range = 0...(monsters.count-1)
        let random_index = Int.random(rand_range)
        return monsters[random_index]()
    }
}