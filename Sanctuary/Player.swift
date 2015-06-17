//
//  Player.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/27/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class Player : Actor {
    var exp : Int
    var freepoints : Int
    var velocity : CGVector?
    var targetLocation : CGPoint!
    var targetPosition : CGPoint!
    var facingDirection : Directions = .down
    var lastFacingDirection : Directions = .down
    var showCollisionRect : Bool = false
    
    var movement : PlayerMovement
    var sprite : SKSpriteNode
    
    var attacks = [Attack.SpearThrust, Attack.SwordAttack]
    
    init (name : String) {
        self.exp = 0
        self.freepoints = 0
        
        self.movement = PlayerMovement()
        self.sprite = SKSpriteNode(texture: self.movement.movement(facingDirection)[0])
        
        super.init(name: name, level: 1, atk: 25, def: 15, spd: 5, hp : 1, stam : 10)
    }
    
    func collisionRectAtTarget() -> CGRect {
        // Calculate smaller rectangle
        let spriteFrame = self.sprite.frame
        var collisionRect = CGRectInset(spriteFrame, 4, 2)
        var movement = CGPointMake(self.targetPosition.x - self.position.x, self.targetPosition.y - self.position.y)
        
        // Move rectangle to target position
        collisionRect = CGRectOffset(collisionRect, movement.x, movement.y - 2)
        return collisionRect
    }
    
    func setMovementDirection(direction: Directions) {
        lastFacingDirection = facingDirection
        facingDirection = direction
    }
    
    func checkMovementDirection() {
        if targetPosition.x > position.x {
            setMovementDirection(.right)
        } else if targetPosition.x  < position.x {
            setMovementDirection(.left)
        }
        
        if targetPosition.y > position.y {
            setMovementDirection(.up)
        } else if targetPosition.y  < position.y {
            setMovementDirection(.down)
        }

    }
    
    func update(scene : MapScene) {
        if showCollisionRect {
            self.sprite.removeAllChildren()
            var box = SKShapeNode()
            box.path = CGPathCreateWithRect(self.collisionRectAtTarget(), nil)
            box.strokeColor = SKColor.redColor()
            box.lineWidth = 0.1
            box.position = CGPointMake(-self.targetPosition.x, -self.targetPosition.y)
            self.sprite.addChild(box)
        }
        self.move()
        // Implement collision logics
        let layer_meta = scene.map.layerNamed("meta")
        scene.collide(layer_meta)
        
        checkMovementDirection()
        self.position = self.targetPosition
    }
    
    func startWalking() {
        if self.sprite.actionForKey("walkingPlayer") == nil {
            self.sprite.runAction(SKAction.repeatActionForever(
                SKAction.animateWithTextures(self.movement.movement(facingDirection),
                    timePerFrame: 0.08,
                    resize: false,
                    restore: true)),
                withKey:"walkingPlayer")
        } else if lastFacingDirection != facingDirection {
            stopWalking()
            startWalking()
        }
    }
    
    func stopWalking() {
        if self.sprite.actionForKey("walkingPlayer") != nil {
            let endTexture = self.movement.movement(facingDirection)[0]
            
            self.sprite.removeActionForKey("walkingPlayer")
            self.sprite.texture = endTexture
        }
    }
    
    func move() {
        var targetExists = false

        
        let vel = CGFloat(6)
        let targetLocation = self.targetLocation
        let position = self.position
        self.targetPosition = position
        
        if targetLocation == position {
            self.stopWalking()
            return
        } else {
            self.startWalking()
        }
        
        self.velocity = CGVector()
        
        if position.x > targetLocation.x {
            self.velocity!.dx = fmax(vel * CGFloat(-1), targetLocation.x - position.x)
        } else {
            self.velocity!.dx = fmin(vel, targetLocation.x - position.x)
        }
        
        if position.y > targetLocation.y {
            self.velocity!.dy = fmax(vel * CGFloat(-1), targetLocation.y - position.y)
        } else {
            self.velocity!.dy = fmin(vel, targetLocation.y - position.y)
        }
        
        self.targetPosition = CGPointMake(position.x + self.velocity!.dx, position.y + self.velocity!.dy)
    }
    
    func give_points() {
        self.freepoints += Game.POINTS_PER_LEVEL
        self.atk += Int.random(1...5)
        self.def += Int.random(1...5)
        self.spd += Int.random(1...5)
        self.hp += Int.random(5...10)
        self.cur_hp = self.hp
    }
    
    func levelup(exp : Int) -> Bool {
        self.exp += exp
        
        let current_level = Int(log2(Double(self.exp)))
        if (current_level > self.level) {
            self.level++
            self.give_points()
            return true
        }
        
        return false
    }
    
    func set_position(pos : CGPoint) {
        self.sprite.position = pos
    }
    
    func stopMoving() {
        self.targetLocation = self.position
    }
    
    func attack(target : Actor) -> Bool {
        var attack = self.attacks[Int.random(0...attacks.count-1)]()
        var killed = attack.perform(target, attacker: self)
        
        return killed
    }
    
    var position : CGPoint {
        get {
            return self.sprite.position
        }
        
        set (newPosition) {
            self.sprite.position = newPosition
        }
    }
    
}
