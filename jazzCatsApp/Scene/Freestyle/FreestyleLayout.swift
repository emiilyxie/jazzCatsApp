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
        
        for noteInfo in noteData {
            let noteMeasure = noteInfo[0]
            let noteBeat = noteInfo[1]
            print("note info: \(noteInfo)")
            let measurelessBeat = (noteMeasure - 1) * CGFloat(prevBpm) + noteBeat
            print("measureless beat: \(measurelessBeat)")
            let newPage = ((measurelessBeat - 1) / CGFloat(totalBeats)).rounded(.down)
            print("new page: \(newPage)")
            let newMeasure = ((measurelessBeat - 1) / CGFloat(bpm)).rounded(.down) + 1
            //let measureOnPage = (Int(noteMeasure) - 1) % numberOfMeasures
            let newBeat = measurelessBeat - ((newMeasure - 1) * CGFloat(bpm))
            let newNote = [newMeasure, newBeat, noteInfo[2]]
            newNoteData.insert(newNote)
            if Int(newPage) < maxPages {
                addNote(with: newNote, on: Int(newPage))
            }
        }
        
        noteData = newNoteData
    }
    
    /*
    func repositionNotes() {
        let oldDivision = numberOfMeasures * bpm * oldSubdivision
        var newPgArray = [[Note]](repeating: [], count: maxPages)
        let maxNewArrayPos = maxPages * oldDivision
        
        // get each note
        for i in 0...pages.count-1 {
            for j in 0...pages[i].count {
                if j == 0 {continue}
                let currentNote = pages[i][j-1]
                if currentNote.positionInStaff[0]*(i+1) < maxNewArrayPos {

                    let universalNoteLocation = currentNote.universalTimePos!
                    let newPgNum = Int(floor(universalNoteLocation/(bpm*numberOfMeasures)))
                    print("new pg num: \(newPgNum)")
                    let newPos = (Int(universalNoteLocation * oldSubdivision)) % oldDivision
                    currentNote.positionInStaff[0] = newPos // position is rounded
                    let universalPageLoc = universalNoteLocation - (newPgNum * numberOfMeasures * bpm)
                    let division = (resultWidth / CGFloat(bpm) / CGFloat(numberOfMeasures))
                    let newXpos = LevelSetup.indentLength + CGFloat(universalPageLoc) * division
                    let newYPos = CGFloat(currentNote.positionInStaff[1]) * staffBarHeight + (staffBarHeight / 2)
                    currentNote.position = CGPoint(x: newXpos, y: newYPos)
                    if newPgNum < maxPages {
                        barsNode.addChild(currentNote)
                        newPgArray[newPgNum].append(currentNote)
                    }
                }
            }
        }
        // refresh which notes are displayed
        pages = newPgArray
        for page in pages {
            for note in page {
                note.isHidden = true
            }
        }
        for note in pages[0] {
            note.isHidden = false
        }
    }
 */
    /*
    func addCamera() {
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: 0, y: 0)
        let maxScale = bgNode.size.width/frame.size.width
        gameCamera.setScale(maxScale)
        camera = gameCamera
    }
 */
}
