//
//  FreestylePhysics.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension Freestyle {
    
    func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
}

extension Freestyle: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
            if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
                let whichInstrument = hitInstrument.noteType
                let whichNote = hitInstrument.getMidiVal()
                do {
                    switch whichInstrument {
                    case .piano:
                        try samplers[0].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                    case .snare:
                        try samplers[2].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                    case .cat:
                        try samplers[4].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                    default:
                        try samplers[0].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                    }
                    //try samplers[0].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                }
                catch {
                    print(error)
                }
            }
        }
        
        if contactMask == PhysicsCategories.measureBarCategory | PhysicsCategories.finalBarCategory {
            if pageIndex < maxPages - 1 {
                nextPage(index: 0)
                enterMode(index: 6)
            }
            else {
                enterMode(index: 5)
            }
        }
    }
}

