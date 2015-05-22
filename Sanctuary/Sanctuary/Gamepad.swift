//
//  Gamepad.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/22/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation
import SpriteKit

class ControlModel {
    var sprite : String
    var pos : CGPoint
    
    init (sprite : String, pos : CGPoint) {
        self.sprite = sprite
        self.pos = pos
    }
    
    func getSprite() -> SKSpriteNode? {
        var sprite = SKSpriteNode(imageNamed: self.sprite)
        sprite.position = pos
        return sprite
    }
}

class GamepadModel {
    var up : ControlModel
    var down : ControlModel
    var left : ControlModel
    var right : ControlModel
    
    init (up : ControlModel, down : ControlModel, left : ControlModel, right : ControlModel) {
        self.up = up
        self.down = down
        self.left = left
        self.right = right
    }
    
    func getSprites() -> [SKSpriteNode?] {
        var sprites = [
            self.up.getSprite(),
            self.down.getSprite(),
            self.left.getSprite(),
            self.right.getSprite()
        ]
        
        return sprites
    }
}

class Gamepad {
    var scene: SKScene
    
    let models = [
        "default": GamepadModel(
            up: ControlModel(sprite: "button_dir_up_0", pos: CGPoint(x: 0, y: 0)),
            down: ControlModel(sprite: "button_dir_down_0", pos: CGPoint(x: 0, y: 40)),
            left: ControlModel(sprite: "button_dir_left_0", pos: CGPoint(x: -20, y: 20)),
            right: ControlModel(sprite: "button_dir_right_0", pos: CGPoint(x: 20, y: 20))
            )
    ]
    
    init (scene: SKScene) {
        self.scene = scene
    }
    
    func draw (model: String) {
        let gamepad = self.models[model]!
        var sprites = gamepad.getSprites()
        for sprite in sprites {
            scene.addChild(sprite!)
        }
    }
}