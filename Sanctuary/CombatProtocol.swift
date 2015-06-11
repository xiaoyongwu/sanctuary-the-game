//
//  CombatProtocol.swift
//  Sanctuary
//
//  Created by uriel bertoche on 6/11/15.
//  Copyright (c) 2015 bertoche. All rights reserved.
//

import Foundation


protocol CombatProtocol {
    var attacks : [Int : Attack] { get set }
}