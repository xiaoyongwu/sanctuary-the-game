//
//  Extensions.swift
//  Sanctuary
//
//  Created by uriel bertoche on 5/24/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation
import SpriteKit

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xFF) / 255,
            G: CGFloat((hex >> 08) & 0xFF) / 255,
            B: CGFloat((hex >> 00) & 0xFF) / 255
        )

        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}


extension CGColor {
    class func colorWithHex(hex: Int) -> CGColorRef {
        return UIColor(hex: hex).CGColor
    }
}