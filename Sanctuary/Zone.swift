//
//  Zone.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/10/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation

class Zone {
    var rect : CGRect
    var name : String
    var mob_gid : Int
    
    func isIn(point : CGPoint) -> Bool {
        return rect.contains(point)
    }
    
    init (rect : CGRect, name : String, m_gid : Int) {
        self.rect = rect
        self.name = name
        self.mob_gid = m_gid
    }
}