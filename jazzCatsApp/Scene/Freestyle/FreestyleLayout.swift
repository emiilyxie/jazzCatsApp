//
//  FreestyleLayout.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension Freestyle {
        
    func reloadLayout() {
        totalDivision = numberOfMeasures * bpm * subdivision
        totalBeats = numberOfMeasures * bpm
        divisionWidth = resultWidth / CGFloat(totalDivision)
        beatWidth = resultWidth / CGFloat(totalBeats)
        pages = [[Note]](repeating: [], count: maxPages)
        barsNode.removeAllChildren()
        barsNode.removeFromParent()
        barVelocity = CGFloat(tempo) / 60 * beatWidth
        setUpStaff()
        pageIndex = 0
        updatePgCount()
        repositionNotes()
    }
    
    func repositionNotes() {
        guard let prevBpm = oldBpm else {
            print("cant get old values")
            return
        }
        
        var newNoteData = Set<[CGFloat]>()
        var newNoteSoundData = Array<Set<[CGFloat]>>(repeating: [], count: (GameUser.sounds.last?.index ?? 20) + 1)
        
        for instrumentIndex in 0..<noteSoundData.count {
            for noteInfo in noteSoundData[instrumentIndex] {
                
                let noteMeasure = noteInfo[0]
                let noteBeat = noteInfo[1]
                let measurelessBeat = (noteMeasure - 1) * CGFloat(prevBpm) + noteBeat
                let newPage = ((measurelessBeat - 1) / CGFloat(totalBeats)).rounded(.down)
                let newMeasure = ((measurelessBeat - 1) / CGFloat(bpm)).rounded(.down) + 1
                let newBeat = measurelessBeat - ((newMeasure - 1) * CGFloat(bpm))
                let newNote = [newMeasure, newBeat, noteInfo[2]]
                
                newNoteData.insert(newNote)
                newNoteSoundData[instrumentIndex].insert(newNote)
                if Int(newPage) < maxPages {
                    let sound = Sounds.getSound(from: GameUser.sounds, index: instrumentIndex) ?? GameUser.sounds[0]
                    addNote(with: newNote, on: Int(newPage), soundID: sound.id)
                }
            }
        }
        noteData = newNoteData
        noteSoundData = newNoteSoundData
        /*
        var newNoteData = Set<[CGFloat]>()
        
        for noteInfo in noteData {
            
            let noteMeasure = noteInfo[0]
            let noteBeat = noteInfo[1]
            let measurelessBeat = (noteMeasure - 1) * CGFloat(prevBpm) + noteBeat
            let newPage = ((measurelessBeat - 1) / CGFloat(totalBeats)).rounded(.down)
            let newMeasure = ((measurelessBeat - 1) / CGFloat(bpm)).rounded(.down) + 1
            let newBeat = measurelessBeat - ((newMeasure - 1) * CGFloat(bpm))
            let newNote = [newMeasure, newBeat, noteInfo[2]]
            
            newNoteData.insert(newNote)
            if Int(newPage) < maxPages {
                addNote(with: newNote, on: Int(newPage))
            }
        }
        noteData = newNoteData
 */
    }
}
