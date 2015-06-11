//
//  Attacks.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/11/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

protocol AttackProtocol {
    var name : String { get set }
    var sound : String { get set }
    var power : Int { get set }
    var particles : SKEmitterNode? { get set }
    func attack(target : Actor) -> Bool
    func animate()
    
    func getControl() -> SKNode?
}

class Attack : AttackProtocol {
    var name : String
    var sound : String
    var power : Int
    var particles : SKEmitterNode?
    
    init (name : String, sound : String, power : Int, particles : SKEmitterNode?) {
        self.name = name
        self.sound = sound
        self.power = power
        self.particles = particles
    }
    
    func attack(target : Actor) -> Bool {
        return false
    }
    
    func animate() {
        
    }
    
    func getControl() -> SKNode? {
        return nil
    }
}

class Bite : Attack {
    init () {
        super.init(name: "Bite", sound: "None", power: 60, particles: nil)
    }
    
    override attack(target : Actor) -> Bool {
    
    }
}