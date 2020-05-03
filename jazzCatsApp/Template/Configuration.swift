//
//  Configuration.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/16/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import CoreGraphics

struct PhysicsCategories {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let noteCategory: UInt32 = 0x1
    static let measureBarCategory: UInt32 = 0x1 << 1

}

enum NoteType: String {
    case piano, bass, snare, hihat
    static var allTypes: [NoteType] = [.piano, .bass, .snare, .hihat]
}

enum ButtonType: String {
    case add, erase, navigate, play, pause, stop
}

extension CGPoint {
    
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
}
