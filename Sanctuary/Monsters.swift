//
//  Monsters.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/27/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class Monster : Actor {
    func exp_reward () -> Int {
        var attributes_sum = self.atk + self.def + self.spd + (self.hp/4) + (self.stam/2)
        
        return attributes_sum / 5
    }
}