//
//  MusicScenePhysics.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/20/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension MusicScene {
    func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
}

extension MusicScene: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
           let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
           
           if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
               if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
                GameUser.conductor?.playNoteSound(note: hitInstrument)
                
                /*
                   let whichInstrument = hitInstrument.noteType
                   let whichNote = hitInstrument.getMidiVal()
                   let soundIndex = currentSounds.firstIndex(of: whichInstrument)
                   if soundIndex == nil {
                       print("couldn't get sound")
                       return
                   }
                   do {
                       try samplers[soundIndex!].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                   }
                   catch {
                       print(error)
                   }
 */
               }
           }
           
           if contactMask == PhysicsCategories.measureBarCategory | PhysicsCategories.finalBarCategory {
               if pageIndex < maxPages - 1 {
                    nextPage(sender: nil, index: 0)
                    enterMode(sender: nil, index: 6)
               }
               else {
                   enterMode(sender: nil, index: 5)
               }
           }
       }
}
