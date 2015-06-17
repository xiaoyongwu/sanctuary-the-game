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

extension Int {
    static func random (range: Range<Int> ) -> Int {
        var offset = 0
        
        if range.startIndex < 0 { // Allow negative ranges
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}