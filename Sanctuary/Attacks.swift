//
//  Attacks.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/11/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation
import AVFoundation

protocol AttackProtocol {
    var name : String { get set }
    var sound : String { get set }
    var power : Int { get set }
    func perform(target : Actor, attacker : Actor) -> Bool
    func animate()
    
    func getControl() -> SKNode?
}

class Attack : AttackProtocol {
    var name : String
    var sound : String
    var power : Int
    
    var soundEffects: AVAudioPlayer!
    
    func playMusic(filename: String, loop: Bool = false) {
        let url = NSBundle.mainBundle().URLForResource(
            filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        do {
            soundEffects =
                try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            soundEffects = nil
        }
        if soundEffects == nil {
            print("Could not create audio player: \(error!)")
            return
        }
        
        var numberOfLoops = 0
        if loop {
            numberOfLoops = -1
        }
        
        soundEffects.numberOfLoops = numberOfLoops
        soundEffects.prepareToPlay()
        soundEffects.play()
    }
    
    init (name : String, sound : String, power : Int) {
        self.name = name
        self.sound = sound
        self.power = power
    }
    
    func perform(target : Actor, attacker : Actor) -> Bool {
        animate()
        let random = Float(Int.random(85...100)) / 100.0
        
        let level_adjustment = Float((2 * attacker.level + 10)) / 250.0
        let stat_diff = Float(attacker.atk / target.def)
        
        let base_damage = level_adjustment * stat_diff * Float(self.power) + 2
        
        var critical_hit = 1
        
        if Int.random(1...16) == 16 {
            critical_hit = 2
        }
        
        let modifier = Float(critical_hit) * random
        
        let damage = Int(base_damage * modifier)
        
        let isDead = target.doDamage(damage)
        
        game.combat_log += "\(attacker.name) used \(self.name) on \(target.name) dealing \(damage) damage.\n"
 
        return isDead
    }
    
    func animate() {
        if self.sound != "" {
            self.playMusic(self.sound)
            sleep(1)
        }
    }
    
    func getControl() -> SKNode? {
        return nil
    }
    
    
    // List of attacks
    static func Bite() -> Attack {
        let attack = Attack(name: "Bite", sound: "Bite.wav", power: 60)
        return attack
    }
    
    static func SwordAttack() -> Attack {
        let attack = Attack(name: "Sword Attack", sound: "Sword3.wav", power: 50)
        return attack
    }
    
    static func SpearThrust() -> Attack {
        let attack = Attack(name: "Spear Thrust", sound: "Wind7.wav", power: 100)
        return attack
    }
    
    static func LifeSteal() -> Attack {
        let attack = Attack(name: "Life Steal", sound: "Decision2.wav", power: 30)
        return attack
    }
    
    static func Firebolt() -> Attack {
        let attack = Attack(name: "Firebolt", sound: "", power: 50)
        return attack
    }
    
    
}