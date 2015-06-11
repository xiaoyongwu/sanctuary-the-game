//
//  Player.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/27/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class Player : Actor {
    var exp, level : Int
    var freepoints : Int
    var cur_hp : Int
    var velocity : CGVector?
    var targetLocation : CGPoint!
    var targetPosition : CGPoint!
    var showCollisionRect : Bool = false
    
    var movement : PlayerMovement
    var sprite : SKSpriteNode
    
    init (name : String) {
        self.exp = 0
        self.level = 1
        self.freepoints = 0
        self.cur_hp = 20
        
        self.movement = PlayerMovement()
        self.sprite = SKSpriteNode(texture: self.movement.movement_frame60())
        
        super.init(name: name, atk: 5, def: 5, spd: 5, hp : 20, stam : 10)
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
    
    func update() {
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
        
        self.position = self.targetPosition
    }
    
    func move() {
        var targetExists = false

        
        let vel = CGFloat(10)
        let targetLocation = self.targetLocation
        let position = self.position
        self.targetPosition = position
        
        if targetLocation == position {
            return
        } else {
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
    
    var position : CGPoint {
        get {
            return self.sprite.position
        }
        
        set (newPosition) {
            self.sprite.position = newPosition
        }
    }
    
}
