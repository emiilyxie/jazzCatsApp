//
//  FreestyleNotes.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension Freestyle {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            editNotes(touch: firstTouch)
        }
    }
    
    func editNotes(touch: UITouch) {
        var location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch currentMode {
        case "addMode": // if in addMode
            if barsNode.contains(location) {
                location = touch.location(in: barsNode)
                let maxX = CGFloat(indentLength + resultWidth - divisionWidth/2)
                if location.x >= CGFloat(indentLength) && location.x < maxX {
                    let snappedLocation = snapNoteLocation(touchedPoint: location)
                    addNote(noteType: selectedNoteType, notePosition: snappedLocation)
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
                    let sharp = SKSpriteNode(imageNamed: "sharp.png")
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
                    let flat = SKSpriteNode(imageNamed: "flat.png")
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
    
    func addNote(noteType: NoteType, notePosition: CGPoint) {
        let note = Note(type: noteType)
        note.name = "note"
        note.position = notePosition
        //note.positionInStaff = getStaffPosition(notePosition: notePosition)
        note.physicsBody = SKPhysicsBody(rectangleOf: note.size)
        note.physicsBody?.isDynamic = false
        note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
        note.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        note.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        barsNode.addChild(note)
        note.setPositions()
        pages[pageIndex].append(note)
    }
    
    func snapNoteLocation(touchedPoint: CGPoint) -> CGPoint {
        let divisionWidthFloat = CGFloat(divisionWidth)
        let indentLengthFloat = CGFloat(indentLength)
        let xPos = Int(round((touchedPoint.x - indentLengthFloat) / divisionWidthFloat) * divisionWidthFloat) + indentLength
        
        let staffBarHeightFloat = CGFloat(staffBarHeight)
        //print("before: \(touchedPoint.y)")
        let yPos = Int(round(touchedPoint.y / staffBarHeightFloat) * staffBarHeightFloat - (staffBarHeightFloat / 2))
        //print("after: \(yPos)")
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getStaffPosition(notePosition: CGPoint) -> Array<Int> {
        let xPos = (Int(notePosition.x) - indentLength + 15) / divisionWidth
        let yPos = Int(notePosition.y) / staffBarHeight
        return [xPos, yPos]
    }
    
    func staffPosToScenePos(staffPos: [Int]) -> CGPoint {
        let xPos = indentLength + staffPos[0] * divisionWidth
        let yPos = staffPos[1] * staffBarHeight + (staffBarHeight / 2)
        return CGPoint(x: xPos, y: yPos)
    }
}
