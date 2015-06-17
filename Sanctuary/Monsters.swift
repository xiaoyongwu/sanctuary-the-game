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
        let atk_range = 4...8
        let def_range = 9...11
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        
        return monster
    }
    
    static func Bandit () -> Monster {
        var monster = Monster(name: "Bandit", level:1, sprite: "Bandit", attacks: [Attack.SwordAttack])
        let atk_range = 6...8
        let def_range = 4...8
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        
        return monster
    }
    
    static func Bat () -> Monster {
        var monster = Monster(name: "Bat", level:3, sprite: "Bat", attacks: [Attack.LifeSteal])
        let atk_range = 12...28
        let def_range = 8...12
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        monster.hp = Int.random(20...30)
        
        return monster
    }
    
    static func Demon() -> Monster {
        var monster = Monster(name: "Demon", level:5, sprite: "Demon", attacks: [Attack.Firebolt, Attack.SpearThrust])
        let atk_range = 26...32
        let def_range = 24...28
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        monster.hp = Int.random(50...100)
        
        return monster
    }
    
    static func Ghost() -> Monster {
        var monster = Monster(name: "Ghost", level:5, sprite: "Ghost", attacks: [Attack.Firebolt, Attack.LifeSteal])
        let atk_range = 20...25
        let def_range = 40...45
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        monster.hp = Int.random(30...60)
        
        return monster
    }
    
    static func God() -> Monster {
        var monster = Monster(name: "God", level:15, sprite: "God", attacks: [Attack.Firebolt, Attack.SpearThrust, Attack.SwordAttack])
        let atk_range = 126...232
        let def_range = 124...228
        monster.atk = Int.random(atk_range)
        monster.def = Int.random(def_range)
        monster.hp = Int.random(150...300)
        
        return monster
    }
}

class MonstersGroup {
    var monsters : [() -> Monster]
    
    init (monsters : [() -> Monster]) {
        self.monsters = monsters
    }
    
    func getRandomMonster() -> Monster {
        let rand_range = 0...(monsters.count-1)
        let random_index = Int.random(rand_range)
        return monsters[random_index]()
    }
}