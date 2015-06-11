//
//  Monsters.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/27/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class Monster : Actor {
    
    var cur_hp : Int
    //var sprite : SKSpriteNode
    
    init (name : String) {
       self.cur_hp = 20
       
       //self.sprite = colocar o sprite do monstro e etc.
        
        super.init(name: name, atk: 5, def: 5, spd: 5, hp : 20, stam: 20)
    }
    
    func exp_reward () -> Int {
        var attributes_sum = self.atk + self.def + self.spd + (self.hp/4) + (self.stam/2)
        
        return attributes_sum / 5
    }
}

class MonstersGroup {
    var monsters : [Monster]
    
    init (monsters : [Monster]) {
        self.monsters = monsters
    }
    
    func getRandomMonster(roll : Float) -> Monster {
        return monsters[monsters.count - 1]
    }
}