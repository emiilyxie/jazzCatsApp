//
//  Configuration.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/16/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

struct PhysicsCategories {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let noteCategory: UInt32 = 0x1
    static let measureBarCategory: UInt32 = 0x1 << 1
    public static let finalBarCategory: UInt32 = 0x1 << 2

}

enum ButtonType: String {
    case add, erase, navigate, play, pause, stop
}

public var middleCMidi = 60
public let octaveSize = 12
public let octaveStepSizes = [2, 2, 1, 2, 2, 2, 1]
public let reversedOctaveStepSizes = [1, 2, 2, 2, 1, 2, 2]
public let middleCPos = 0

public var midiNoteDict = [("F2", 41), ("G2", 43), ("A2", 45), ("B2", 47), ("C3", 48), ("D3", 50), ("E3", 52), ("F3", 53), ("G3", 55), ("A3", 57), ("B3", 59), ("C4", 60), ("D4", 62), ("E4", 64), ("F4", 65), ("G4", 67), ("A4", 69), ("B4", 71), ("C5", 72), ("D5", 74), ("E5", 76), ("F5", 77), ("G5", 79)]

public var trebleMidiNoteDict = [("C4", 60), ("D4", 62), ("E4", 64), ("F4", 65), ("G4", 67), ("A4", 69), ("B4", 71), ("C5", 72), ("D5", 74), ("E5", 76), ("F5", 77), ("G5", 79)]

public var trebleNotes = ["B3", "C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5", "D5", "E5", "F5", "G5", "C4s", "D4s", "E4s", "F4s", "G4s", "A4s", "B4s", "C5s", "D5s", "E5s", "F5s", "G5s"]

public func scaleNode(size: CGSize, factor: Double) -> CGSize {
    return CGSize(width: size.width * CGFloat(factor), height: size.height * CGFloat(factor))
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
