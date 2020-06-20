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
        divisionWidth = resultWidth / CGFloat(totalDivision)
        barsNode.removeAllChildren()
        barsNode.removeFromParent()
        setUpStaff()
        pageIndex = 0
        updatePgCount()
        repositionNotes()
    }
    
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
