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
    var overlay = SKNode()
    var infoNode = SKNode()
    var fleeBtn : GGButton?
    var attackBtn : GGButton?
    
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
        
        var numberOfLoops = 0
        if loop {
            numberOfLoops = -1
        }
        
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.numberOfLoops = numberOfLoops
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
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
        background.zPosition = 0
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        background.size = self.size
        self.addChild(background)
        
        if image2 != "" {
            var foreground = SKSpriteNode(imageNamed: image2)
            foreground.zPosition = 1
            foreground.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            foreground.size = self.size
            self.addChild(foreground)
        }
    }
    
    func drawMonster() {
        game.monster!.sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        game.monster!.sprite.zPosition = 2
        self.addChild(game.monster!.sprite)
    }
    
    func drawInfos() {
        infoNode.removeAllChildren()
        if let monster = game.monster {
            var monster_title = SKLabelNode(text: "\(monster.name) Lvl\(monster.level)")
            var monster_hp = SKLabelNode(text: "\(monster.cur_hp) / \(monster.hp)")
            monster_title.position = CGPointMake(0, 0)
            monster_hp.position = CGPointMake(0, -40)
            
            infoNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))
            infoNode.addChild(monster_title)
            infoNode.addChild(monster_hp)
        } else {
            return
        }
    }
    
    func drawControllers() {
        self.overlay.zPosition = 10000
        self.overlay.addChild(infoNode)
        //self.overlay.userInteractionEnabled = true
        //self.userInteractionEnabled = true
        
        fleeBtn = GGButton(text: "Flee", color: UIColor.redColor(), size: CGSize(width: self.frame.width / 2, height: 50),
            buttonAction: self.flee)
        fleeBtn!.position = CGPointMake(CGRectGetMaxX(self.frame)/4, CGRectGetMinY(self.frame) + 120)
        fleeBtn!.zPosition = 10001
        
        attackBtn = GGButton(text: "Attack", color: UIColor.greenColor(), size: CGSize(width: self.frame.width / 2, height: 50), buttonAction: self.attack)
        attackBtn!.position = CGPointMake(CGRectGetMaxX(self.frame) - (CGRectGetMaxX(self.frame)/4), CGRectGetMinY(self.frame) + 120)
        attackBtn!.zPosition = 10002
        
        self.overlay.addChild(fleeBtn!)
        self.overlay.addChild(attackBtn!)
        
        self.addChild(overlay)
        
        //game.combat_log!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        //overlay.addChild(game.combat_log!)
    }
    
    override func didMoveToView(view: SKView) {
        game.enterScene(self)
        playMusic("boss battle 1.mp3", loop: true)
        drawBattledrop(Scenary.Forest)
        drawMonster()
        drawControllers()
        drawInfos()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            for touch : AnyObject in touches {
                var touchLocation = touch.locationInNode(self.overlay)
                
                var alt = UIAlertView(title: "Touch", message: "\(touchLocation.x):\(touchLocation.y) \n\(attackBtn!.position.x):\(attackBtn!.position.y)", delegate: nil, cancelButtonTitle: "OK")
                //alt.show()
                
                if attackBtn!.containsPoint(touchLocation) {
                    attack()
                }
                
                if fleeBtn!.containsPoint(touchLocation) {
                    flee()
                }
            }
        }
    }
    
    func backToWorld() {
        let scene = GameScene(size: self.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        backgroundMusicPlayer.stop()
        
        //self.view!.presentScene(scene, transition: transition)
        game.monster = nil
        game.combat_log = ""
        self.view!.presentScene(scene)
    }
    
    func attack() {
        var ngame = game
        if game.player.spd > game.monster!.spd {
            game.player.attack(game.monster!)
            if (game.monster!.isDead() == false) {
                game.monster!.attack(game.player)
                checkLiving()
            }
        } else {
            game.monster!.attack(game.player)
            if (game.player.isDead() == false) {
                game.player.attack(game.monster!)
                checkLiving()
            }
        }
        self.drawInfos()
    }
    
    func flee() {
        backToWorld()
    }
    
    func winBattle() {
        let exp_reward = game.monster!.exp_reward()
        game.player.levelup(exp_reward)
        
        var notification = UIAlertView(title: "You won!", message: "Exp rewarded: \(exp_reward)", delegate: nil, cancelButtonTitle: "Back to world")
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
