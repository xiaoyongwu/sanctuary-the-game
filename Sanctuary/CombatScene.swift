//
//  CombatScene.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/9/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation
import AVFoundation

class CombatScene : SKScene, SKPhysicsContactDelegate {
    var mapScene = MapScene()
    
    func drawBattledrop(scenary : Scenary) {
        var image1 = ""
        var image2 = ""
        
        switch scenary {
            case Scenary.Meadow:
                image1 = "Meadow"
                image2 = "Forest1"
            
            case Scenary.Forest:
                image1 = "GrassMaze"
                image2 = "Forest2"
            
            default:
                image1 = "Grassland"
        }
        
        var background = SKSpriteNode(imageNamed: image1)
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        background.size = self.size
        self.addChild(background)
        
        if image2 != "" {
            var foreground = SKSpriteNode(imageNamed: image2)
            foreground.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            foreground.size = self.size
            self.addChild(foreground)
        }
    }
    
    func drawMonster() {
        game.monster!.sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(game.monster!.sprite)
    }
    
    override func didMoveToView(view: SKView) {
        game.enterScene(self)
        drawBattledrop(Scenary.Forest)
        drawMonster()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            // let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
            
            attack()
        }
    }
    
    func backToWorld() {
        let scene = GameScene(size: self.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        
        //self.view!.presentScene(scene, transition: transition)
        game.monster = nil
        self.view!.presentScene(scene)
    }
    
    func attack() {
        if game.player.spd > game.monster!.spd {
            game.player.attack(game.monster!)
            checkLiving()
            game.monster!.attack(game.player)
            checkLiving()
        } else {
            game.monster!.attack(game.player)
            checkLiving()
            game.player.attack(game.monster!)
            checkLiving()
        }
    }
    
    func flee() {
        backToWorld()
    }
    
    func winBattle() {
        let exp_reward = game.monster!.exp_reward()
        game.player.levelup(exp_reward)
        
        let notification = UIAlertView(title: "You won!", message: "Exp rewarded: \(exp_reward)", delegate: nil, cancelButtonTitle: "Back to world")
        notification.show()
        backToWorld()
    }
    
    func checkLiving() {
        if game.monster!.isDead() {
            winBattle()
        }
        
        if game.player.isDead() {
            game.gameover()
        }
    }
    
    func updateView() {
        checkLiving()
    }
    
    override func update(currentTime: NSTimeInterval) {
        updateView()
    }
    
}
