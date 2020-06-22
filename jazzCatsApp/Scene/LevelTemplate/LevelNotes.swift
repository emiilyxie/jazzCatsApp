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
    
    override func editNotes(touch: UITouch) {
        var location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch currentMode {
        case "addMode": // if in addMode
            for node in touchedNodes {
                if let _ = node as? Note {
                    return
                }
            }
            if barsNode.contains(location) {
                location = touch.location(in: barsNode) // going to barsNode coords
                let maxX = CGFloat(LevelSetup.indentLength + resultWidth - divisionWidth/2)
                if location.x >= CGFloat(LevelSetup.indentLength) && location.x < maxX {
                    let snappedLocation = snapNoteLocation(touchedPoint: location)
                    addNote(noteType: selectedNote, notePosition: snappedLocation)
                }
            }
        case "eraseMode": // if in eraseMode
            for node in touchedNodes {
                if let noteNode = node as? Note {
                    noteNode.removeFromParent()
                    //myAns[pageIndex][noteNode.positionInStaff[0]].remove(noteNode.getNoteName())
                    myAns[pageIndex].remove(noteNode.getAnsArray())
                    pages[pageIndex].removeAll { $0 == noteNode }
                }
            }
        case "sharpMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                let prevNoteAns = noteNode.getAnsArray()
                if !noteNode.isSharp {
                    editAccidental(accidental: "sharp", note: noteNode)
                }
                else {
                    editAccidental(accidental: "natural", note: noteNode)
                }
                myAns[pageIndex].insert(noteNode.getAnsArray())
                myAns[pageIndex].remove(prevNoteAns)
            }
        case "flatMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                let prevNoteAns = noteNode.getAnsArray()
                if !noteNode.isFlat {
                    editAccidental(accidental: "flat", note: noteNode)
                }
                else {
                    editAccidental(accidental: "natural", note: noteNode)
                }
                myAns[pageIndex].insert(noteNode.getAnsArray())
                myAns[pageIndex].remove(prevNoteAns)
            }
        default: // not selected or navigateMode
            return
        }
    }
    
    override func addNote(noteType: String, notePosition: CGPoint) {
        let note = Note(type: noteType)
        note.name = "note"
        note.position = notePosition
        barsNode.addChild(note)
        note.setPositions()
        myAns[pageIndex].insert(note.getAnsArray())
        pages[pageIndex].append(note)
    }
    
    // Conversion Functions
    
    func midiValToNotePos(midiVal: Int) -> Int {
        let distFromC = midiVal - middleCMidi
        var notePos = 0
        // handling c flat for now
        if midiVal == 59 {
            return 0
        }
        if distFromC > 0 {
            //print("midival: \(midiVal)")
            let whichOctave = Int(floor(Double(distFromC / octaveSize)))
            let whichPos = distFromC % octaveSize
            let octavePos = whichOctave * 7
            if whichPos == 0 {
                return octavePos
            }
            notePos += octavePos
            var counter = 0
            for staffDist in 0...octaveStepSizes.count-1 {
                counter += octaveStepSizes[staffDist]
                if counter >= whichPos {
                    notePos += staffDist
                    break
                }
            }
            //print("note pos: \(notePos)")
            return notePos + 1 + middleCPos
        }
        else if distFromC < 0 {
            print("aah less than C")
            let absDist = abs(distFromC)
            let whichOctave = Int(floor(Double(absDist / octaveSize)))
            let whichPos = absDist % octaveSize
            let octavePos = whichOctave * 7
            notePos += octavePos
            var counter = 0
            for staffDist in 0...reversedOctaveStepSizes.count-1 {
                counter += reversedOctaveStepSizes[staffDist]
                if counter >= whichPos {
                    notePos += staffDist
                    break
                }
            }
            return middleCPos - notePos - 1
        }
        else {return 0}
    }
    
     func ansArrayToScenePos(ansVal: [Int]) -> CGPoint {
        let noteWhere = ansVal[0]
        let whichNote = midiValToNotePos(midiVal: ansVal[1])
        let scenePos = staffPosToScenePos(staffPos: [noteWhere, whichNote])
        return scenePos
    }
    
    func shouldBeFlatted(midiVal: Int) -> Bool {
        if midiVal == 59 { return true } // handling c flat for now
        if midiVal <= middleCMidi { return false }
        let whichNote = (midiVal - middleCMidi) % octaveSize
        print("midival: \(midiVal)")
        print("which note: \(whichNote)")
        var counter = 0
        if whichNote == 0 { return false }
        for i in 0...octaveStepSizes.count-1 {
            counter += octaveStepSizes[i]
            if counter > whichNote {
                return true
            }
            else if whichNote == counter {
                return false
            }
        }
        print("hmm uh oh cant determine flat")
        return false
    }
    
}
