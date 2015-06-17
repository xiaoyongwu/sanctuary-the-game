//
//  Attacks.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/11/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

func playMusic(filename: String, loop: Bool = false) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayer =
        AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    
    var numberOfLoops = 1
    if loop {
        numberOfLoops = -1
    }
    
    backgroundMusicPlayer.numberOfLoops = numberOfLoops
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

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
 
        return isDead
    }
    
    func animate() {
        if self.sound != "" {
            playMusic(self.sound)
        }
    }
    
    func getControl() -> SKNode? {
        return nil
    }
    
    
    // List of attacks
    static func Bite() -> Attack {
        var attack = Attack(name: "Bite", sound: "Bite.wav", power: 60)
        return attack
    }
    
    static func SwordAttack() -> Attack {
        var attack = Attack(name: "Sword Attack", sound: "Sword3.wav", power: 40)
        return attack
    }
    
    static func SpearThrust() -> Attack {
        var attack = Attack(name: "Spear Thrust", sound: "Wind7.wav", power: 100)
        return attack
    }
}