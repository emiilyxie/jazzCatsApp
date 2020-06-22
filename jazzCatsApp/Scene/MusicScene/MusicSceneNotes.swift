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
            editNotes(touch: firstTouch)
        }
    }
    
    @objc func editNotes(touch: UITouch) {
        var location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch currentMode {
        case "addMode": // if in addMode
            if barsNode.contains(location) {
                location = touch.location(in: barsNode)
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
                    pages[pageIndex].removeAll { $0 == noteNode }
                }
            }
        case "sharpMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                if noteNode.isFlat {
                    noteNode.toggleFlat()
                    noteNode.removeAllChildren()
                }
                noteNode.toggleSharp()
                if noteNode.isSharp {
                    let sharp = SKSpriteNode(imageNamed: "temp-sharp")
                    sharp.size = scaleNode(size: sharp.size, factor: Double(0.05))
                    sharp.position = CGPoint(x: -20, y: 0)
                    noteNode.addChild(sharp)
                }
                else {
                    noteNode.removeAllChildren()
                }
            }
        case "flatMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                if noteNode.isSharp {
                    noteNode.toggleSharp()
                    noteNode.removeAllChildren()
                }
                noteNode.toggleFlat()
                if noteNode.isFlat {
                    let flat = SKSpriteNode(imageNamed: "temp-flat")
                    flat.size = scaleNode(size: flat.size, factor: Double(0.025))
                    flat.position = CGPoint(x: -20, y: 0)
                    noteNode.addChild(flat)
                }
                else {
                    noteNode.removeAllChildren()
                }
            }
        default: // not selected or navigateMode
            return
        }
    }
    
    @objc func addNote(noteType: String, notePosition: CGPoint) {
        let note = Note(type: noteType)
        note.name = "note"
        note.position = notePosition
        
        barsNode.addChild(note)
        note.setPositions()
        pages[pageIndex].append(note)
    }
    
    func editAccidental(accidental: String, note: Note) {
        switch accidental {
        case "sharp":
            note.isSharp = true
            note.isFlat = true
            let sharp = SKSpriteNode(imageNamed: "temp-sharp")
            sharp.size = CGSize(width: 20, height: 20)
            sharp.position = CGPoint(x: -40, y: 0)
            note.addChild(sharp)
        case "flat":
            note.isSharp = false
            note.isFlat = true
            let flat = SKSpriteNode(imageNamed: "temp-flat")
            flat.size = CGSize(width: 20, height: 20)
            flat.position = CGPoint(x: -40, y: 0)
            note.addChild(flat)
        case "natural":
            note.isSharp = false
            note.isFlat = false
            note.removeAllChildren()
        default:
            print("theres nothing to do")
        }
    }
    
    func snapNoteLocation(touchedPoint: CGPoint) -> CGPoint {
        let xPos = round((touchedPoint.x - LevelSetup.indentLength) / divisionWidth) * divisionWidth + LevelSetup.indentLength
        let yPos = round(touchedPoint.y / staffBarHeight) * staffBarHeight
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getStaffPosition(notePosition: CGPoint) -> Array<Int> {
        let xPos = Int((notePosition.x - LevelSetup.indentLength + 15) / divisionWidth)
        let yPos = Int(notePosition.y / staffBarHeight)
        return [xPos, yPos]
    }
    
    func staffPosToScenePos(staffPos: [Int]) -> CGPoint {
        let xPos = LevelSetup.indentLength + CGFloat(staffPos[0]) * divisionWidth
        let yPos = CGFloat(staffPos[1]) * staffBarHeight
        return CGPoint(x: xPos, y: yPos)
    }
}
