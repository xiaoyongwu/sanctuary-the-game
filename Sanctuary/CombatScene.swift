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
            print("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        do {
            backgroundMusicPlayer =
                try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            backgroundMusicPlayer = nil
        }
        if backgroundMusicPlayer == nil {
            print("Could not create audio player: \(error!)")
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
        
        let background = SKSpriteNode(imageNamed: image1)
        background.zPosition = 0
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        background.size = self.size
        self.addChild(background)
        
        if image2 != "" {
            let foreground = SKSpriteNode(imageNamed: image2)
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
            let monster_title = SKLabelNode(text: "\(monster.name) LVL: \(monster.level)")
            let monster_hp = SKLabelNode(text: "\(monster.cur_hp) / \(monster.hp)")
            monster_title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            monster_hp.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            monster_title.position = CGPointMake(10, -60)
            monster_hp.position = CGPointMake(10, -90)
            monster_hp.fontName = "AvenirNext-Bold"
            monster_title.fontName = "AvenirNext-Bold"
            monster_title.fontSize = 20
            monster_hp.fontSize = 20
            
            let player_name = SKLabelNode(text: "\(game.player.name) LVL: \(game.player.level)")
            let player_hp = SKLabelNode(text: "\(game.player.cur_hp) / \(game.player.hp)")
            player_name.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            player_hp.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            player_name.position = CGPointMake(1000, -480)
            player_hp.position = CGPointMake(1000, -510)
            player_hp.fontName = "AvenirNext-Bold"
            player_hp.fontSize = 20
            player_name.fontName = "AvenirNext-Bold"
            player_name.fontSize = 20
            
            infoNode.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)-100)
            infoNode.addChild(monster_title)
            infoNode.addChild(monster_hp)
            infoNode.addChild(player_name)
            infoNode.addChild(player_hp)
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
        game.combat_log = ""
        game.notifications = ""
        playMusic("boss battle 1.mp3", loop: true)
        drawBattledrop(Scenary.Forest)
        drawMonster()
        drawControllers()
        drawInfos()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            for touch : AnyObject in touches {
                let touchLocation = touch.locationInNode(self.overlay)
                
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
        let notificationsAlert = UIAlertView(title: "Notifications", message: game.notifications, delegate: nil, cancelButtonTitle: "OK")
        notificationsAlert.show()
        self.view!.presentScene(scene)
    }
    
    func attack() {
        game.combat_log = ""
        if game.monster!.isDead() || game.player.isDead() {
            return
        }
        
        var ngame = game
        if game.player.spd > game.monster!.spd {
            game.player.attack(game.monster!)
            if (game.monster!.isDead() == false) {
                game.monster!.attack(game.player)
                //checkLiving()
            }
        } else {
            game.monster!.attack(game.player)
            if (game.player.isDead() == false) {
                game.player.attack(game.monster!)
                //checkLiving()
            }
        }
        let combat_log = UIAlertView(title: "Combat log", message: game.combat_log, delegate: self, cancelButtonTitle: "OK")
        combat_log.show()
        self.drawInfos()
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex : Int) {
        switch buttonIndex {
            default:
                checkLiving()
                break
        }
    }
    
    func flee() {
        game.notifications += "You fled...\nA man that flies from his fear may find that he has only taken a short cut to meet it.\n\n"
        backToWorld()
    }
    
    func winBattle() {
        let exp_reward = game.monster!.exp_reward()
        //var notification = UIAlertView(title: "You won!", message: "Exp rewarded: \(exp_reward)", delegate: nil, cancelButtonTitle: "Back to world")
        game.notifications += "You won!\nExp rewarded: \(exp_reward)\n\n"
        game.player.levelup(exp_reward)
        //notification.show()
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
    
    override func update(currentTime: NSTimeInterval) {
        
    }
    
}
