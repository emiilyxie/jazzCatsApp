//
//  MusicSceneNotes.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/20/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension MusicScene {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let location = firstTouch.location(in: self)
            editNotes(location: location)
        }
    }
    
    func editNotes(location: CGPoint) {
        //var location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch currentMode {
        case "addMode": // if in addMode
            editNotesAdd(location: location, touchedNodes: touchedNodes)
        case "eraseMode": // if in eraseMode
            editNotesErase(location: location, touchedNodes: touchedNodes)
        case "sharpMode":
            editNotesSharp(location: location, touchedNodes: touchedNodes)
        case "flatMode":
            editNotesFlat(location: location, touchedNodes: touchedNodes)
        default: // not selected or navigateMode
            return
        }
        print(noteData)
    }
    
    @objc func editNotesAdd(location: CGPoint, touchedNodes: [SKNode]) {
        if barsNode.contains(location) {
            let barLocation = convert(location, to: barsNode)
            //location = touch.location(in: barsNode) // going to barsNode coords
            let maxX = CGFloat(LevelSetup.indentLength + resultWidth - divisionWidth/2)
            if barLocation.x >= CGFloat(LevelSetup.indentLength)/2 && barLocation.x < maxX {
            //if barLocation.x < maxX {
                addNote(noteType: selectedNote, notePosition: barLocation)
            }
        }
    }
    
    @objc func editNotesErase(location: CGPoint, touchedNodes: [SKNode]) {
        if let noteNode = atPoint(location) as? Note {
            noteNode.removeFromParent()
            noteData.remove(noteNode.getNoteInfo())
            let soundIndex = Sounds.getSound(from: GameUser.sounds, id: noteNode.noteType)?.index ?? 0
            noteSoundData[soundIndex].remove(noteNode.getNoteInfo())
            pages[pageIndex].removeAll { $0 == noteNode }
        }
    }
    
    func editNotesSharp(location: CGPoint, touchedNodes: [SKNode]) {
        let topNode = touchedNodes.first
        if let noteNode = topNode as? Note {
            let prevNoteAns = noteNode.getNoteInfo()
            if !noteNode.isSharp {
                editAccidental(accidental: "sharp", note: noteNode)
            }
            else {
                editAccidental(accidental: "natural", note: noteNode)
            }
            noteData.insert(noteNode.getNoteInfo())
            noteData.remove(prevNoteAns)
            let soundIndex = Sounds.getSound(from: GameUser.sounds, id: selectedNote)?.index ?? 0
            noteSoundData[soundIndex].insert(noteNode.getNoteInfo())
            noteSoundData[soundIndex].remove(prevNoteAns)
            GameUser.conductor?.playNoteSound(note: noteNode)
        }
    }
    
    func editNotesFlat(location: CGPoint, touchedNodes: [SKNode]) {
        let topNode = touchedNodes.first
        if let noteNode = topNode as? Note {
            let prevNoteAns = noteNode.getNoteInfo()
            if !noteNode.isFlat {
                editAccidental(accidental: "flat", note: noteNode)
            }
            else {
                editAccidental(accidental: "natural", note: noteNode)
            }
            noteData.insert(noteNode.getNoteInfo())
            noteData.remove(prevNoteAns)
            let soundIndex = Sounds.getSound(from: GameUser.sounds, id: selectedNote)?.index ?? 0
            noteSoundData[soundIndex].insert(noteNode.getNoteInfo())
            noteSoundData[soundIndex].remove(prevNoteAns)
            GameUser.conductor?.playNoteSound(note: noteNode)
        }
    }
    
    func addNote(noteType: String, notePosition: CGPoint) {
        let note = Note(type: noteType)
        note.name = "note"
        note.position = snapNoteLocation(touchedPoint: notePosition)
        
        barsNode.addChild(note)
        note.measure = getNoteMeasure(noteXPos: note.position.x - LevelSetup.indentLength)
        note.beat = getNoteBeat(noteXPos: note.position.x - LevelSetup.indentLength, noteMeasure: note.measure)
        note.staffLine = getNoteStaffLine(noteYPos: note.position.y)
        //note.isUserInteractionEnabled = true

        noteData.insert(note.getNoteInfo())
        let soundIndex = Sounds.getSound(from: GameUser.sounds, id: selectedNote)?.index ?? 0
        noteSoundData[soundIndex].insert(note.getNoteInfo())
        //print(noteData)
        pages[pageIndex].append(note)
        
        GameUser.conductor?.playNoteSound(note: note)
    }
    
    func addNote(with info: [CGFloat], on page: Int, soundID: String) {
        let notePosition = noteInfoToScenePos(noteInfo: info)
        let note = Note(type: soundID)
        note.name = "note"
        note.position = notePosition
        //note.position = snapNoteLocation(touchedPoint: notePosition)
        
        barsNode.addChild(note)
        //note.measure = getNoteMeasure(noteXPos: note.position.x - LevelSetup.indentLength)
        note.measure = Int(info[0])
        note.beat = getNoteBeat(noteXPos: note.position.x - LevelSetup.indentLength, noteMeasure: note.measure)
        note.staffLine = getNoteStaffLine(noteYPos: note.position.y)
        //note.isUserInteractionEnabled = true
        note.alpha = 1
        
        // add a flat if it should be flatted
        if shouldBeFlatted(midiVal: Int(info[2])) {
            editAccidental(accidental: "flat", note: note)
        }
        
        noteData.insert(note.getNoteInfo())
        let soundIndex = Sounds.getSound(from: GameUser.sounds, id: selectedNote)?.index ?? 0
        noteSoundData[soundIndex].insert(note.getNoteInfo())
        //print(noteData)
        pages[page].append(note)
        
        if page != pageIndex {
            //note.isHidden = true
            note.alpha = 0
            //note.isUserInteractionEnabled = false
            note.physicsBody?.categoryBitMask = PhysicsCategories.none
        }
        
    }
    
    func editAccidental(accidental: String, note: Note) {
        note.removeAllChildren()
        switch accidental {
        case "sharp":
            note.isSharp = true
            note.isFlat = false
            let sharp = SKSpriteNode(imageNamed: "sharp")
            sharp.size = CGSize(width: 30, height: 30)
            sharp.position = CGPoint(x: -30, y: 0)
            note.addChild(sharp)
        case "flat":
            note.isSharp = false
            note.isFlat = true
            let flat = SKSpriteNode(imageNamed: "flat")
            flat.size = CGSize(width: 30, height: 30)
            flat.position = CGPoint(x: -30, y: 0)
            note.addChild(flat)
        case "natural":
            note.isSharp = false
            note.isFlat = false
            //note.removeAllChildren()
        default:
            print("theres nothing to do")
        }
    }
    
    // conversion funcs
    
    func snapNoteLocation(touchedPoint: CGPoint) -> CGPoint {
        let xPos = round((touchedPoint.x - LevelSetup.indentLength) / divisionWidth) * divisionWidth + LevelSetup.indentLength
        let yPos = round(touchedPoint.y / staffBarHeight) * staffBarHeight
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getNoteMeasure(noteXPos: CGFloat) -> Int {
        let measureOnPage = Int(noteXPos/measureWidth.rounded(.down))
        let noteMeasure = pageIndex * numberOfMeasures + measureOnPage + 1
        return noteMeasure
    }
    
    func getNoteBeat(noteXPos: CGFloat, noteMeasure: Int) -> CGFloat {
        let longDecimal = Double(noteXPos/beatWidth)
        let decimalStr = String(String(longDecimal).prefix(5))
        let rounded = Double(round(100 * Double(decimalStr)!) / 100)
        //rounded = Double(round(100 * rounded) / 100)
        //let rounded = Double(String(format: "%.2f", longDecimal))!
        //return CGFloat(rounded)
        let measureOnPage = (noteMeasure - 1) % numberOfMeasures
        let beatInMeasure = Double(rounded) - Double(measureOnPage * bpm) + 1
        return CGFloat(beatInMeasure)
    }
    
    func getNoteStaffLine(noteYPos: CGFloat) -> Int {
        return Int(noteYPos/staffBarHeight)
    }
    
    func midiValToStaffLine(midiVal: Int) -> Int {
        let distFromC = midiVal - MusicValues.middleCMidi
        var notePos = 0
        // handling c flat for now
        if midiVal == 59 {
            return 0
        }
        if distFromC > 0 {

            let whichOctave = Int(floor(Double(distFromC / MusicValues.octaveSize)))
            let whichPos = distFromC % MusicValues.octaveSize
            let octavePos = whichOctave * 7
            if whichPos == 0 {
                return octavePos
            }
            notePos += octavePos
            var counter = 0
            for staffDist in 0...MusicValues.octaveStepSizes.count-1 {
                counter += MusicValues.octaveStepSizes[staffDist]
                if counter >= whichPos {
                    notePos += staffDist
                    break
                }
            }
            return notePos + 1 + MusicValues.middleCPos
        }
        else if distFromC < 0 {
            print("aah less than C")
            let absDist = abs(distFromC)
            let whichOctave = Int(floor(Double(absDist / MusicValues.octaveSize)))
            let whichPos = absDist % MusicValues.octaveSize
            let octavePos = whichOctave * 7
            notePos += octavePos
            var counter = 0
            for staffDist in 0...MusicValues.reversedOctaveStepSizes.count-1 {
                counter += MusicValues.reversedOctaveStepSizes[staffDist]
                if counter >= whichPos {
                    notePos += staffDist
                    break
                }
            }
            return MusicValues.middleCPos - notePos - 1
        }
        else {return 0}
    }
    
    func noteInfoToScenePos(noteInfo: [CGFloat]) -> CGPoint {
        let measureOnPage = Int(noteInfo[0] - 1) % numberOfMeasures + 1
        let addMeasureWidth = CGFloat(measureOnPage-1) * measureWidth
        let xPos = (noteInfo[1] - 1) * beatWidth + LevelSetup.indentLength + addMeasureWidth
        let staffLine = midiValToStaffLine(midiVal: Int(noteInfo[2]))
        let yPos = staffBarHeight * CGFloat(staffLine)
        let location = CGPoint(x: xPos, y: yPos)
        return location
    }
    
    func shouldBeFlatted(midiVal: Int) -> Bool {
        if midiVal == 59 { return true } // handling c flat for now
        if midiVal <= MusicValues.middleCMidi { return false }
        let whichNote = (midiVal - MusicValues.middleCMidi) % MusicValues.octaveSize
        var counter = 0
        if whichNote == 0 { return false }
        for i in 0...MusicValues.octaveStepSizes.count-1 {
            counter += MusicValues.octaveStepSizes[i]
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
