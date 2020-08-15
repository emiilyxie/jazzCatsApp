//
//  LevelNotes.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension LevelTemplate {
    
    override func editNotesAdd(location: CGPoint, touchedNodes: [SKNode]) {
        for node in touchedNodes {
            if let _ = node as? Note {
                return
            }
        }
        super.editNotesAdd(location: location, touchedNodes: touchedNodes)
    }
    
    override func editNotesErase(location: CGPoint, touchedNodes: [SKNode]) {
        for node in touchedNodes {
            if let noteNode = node as? Note {
                noteNode.removeFromParent()
                noteData.remove(noteNode.getNoteInfo())
                let soundIndex = Sounds.getSound(from: GameUser.sounds, id: selectedNote)?.index ?? 0
                noteSoundData[soundIndex].remove(noteNode.getNoteInfo())
                pages[pageIndex].removeAll { $0 == noteNode }
            }
        }
    }
}
