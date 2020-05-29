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
    
    func layoutScene() {
        setUpBackground()
        setUpStaff()
        setUpMeasureBar()
        setUpButtons()
    }
    
    func setUpBackground() {
        if let bgNode = childNode(withName: "background") as? SKSpriteNode {
            self.bgNode = bgNode
        }
    }
    
    func setUpStaff() {
        barsNode.position = CGPoint(x: 0, y: staffHeightFromGround)
        
        // creating the staff
        for i in 0...staffBarNumber - 1 {
            let staffBar = StaffBar(barIndex: i, barHeight: staffBarHeight)
            staffBar.anchorPoint = CGPoint(x: 0, y: 0)
            staffBar.position = CGPoint(x: 0, y: (i * Int(staffBar.size.height)))
            staffBar.name = "staffBar"
            if i == 0 {
                continue
            }
                
            else if i % 2 == 0 {
                staffBar.drawLineThru()
            }

            barsNode.addChild(staffBar)
        }
        
        // creating the staff & its time
        for i in 0...totalDivision - 1 {
            var lineWidth = 0
            if i % subdivision == 0 {
                lineWidth += 2
            }
            if i % (totalDivision / numberOfMeasures) == 0 {
                lineWidth += 2
            }
            if lineWidth == 0 {
                continue
            }
            else {
                let xPos = LevelSetup.indentLength + i * divisionWidth
                let measureLine = SKShapeNode(rect: CGRect(x: xPos, y: 0, width: lineWidth, height: staffTotalHeight))
                measureLine.fillColor = UIColor.black
                measureLine.strokeColor = UIColor.clear
                barsNode.addChild(measureLine)
            }
        }
        
        // final bar with physics
        let finalBar = SKSpriteNode(color: UIColor.black, size: CGSize(width: 6, height: staffTotalHeight))
        finalBar.position = CGPoint(x: LevelSetup.indentLength + totalDivision * divisionWidth, y: Int(finalBar.size.height) / 2)
        finalBar.physicsBody = SKPhysicsBody(rectangleOf: finalBar.size)
        finalBar.physicsBody?.isDynamic = false
        finalBar.physicsBody?.categoryBitMask = PhysicsCategories.finalBarCategory
        finalBar.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        finalBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        barsNode.addChild(finalBar)
        addChild(barsNode)
    }
    
    func setUpMeasureBar() {
        // adding white measure bar to hit notes
        measureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 4, height: staffTotalHeight + 30))
        measureBar.position.x = CGFloat(Int(bgNode.frame.minX) + LevelSetup.indentLength - 20)
        measureBar.position.y = barsNode.position.y + measureBar.size.height/2
        measureBar.zPosition = 20
        measureBar.physicsBody = SKPhysicsBody(rectangleOf: measureBar.size)
        measureBar.physicsBody?.categoryBitMask = PhysicsCategories.measureBarCategory
        measureBar.physicsBody?.contactTestBitMask = PhysicsCategories.noteCategory | PhysicsCategories.finalBarCategory
        measureBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        measureBar.physicsBody?.affectedByGravity = false
        measureBar.physicsBody?.friction = 0
        measureBar.physicsBody?.linearDamping = 0
        addChild(measureBar)
    }
    
    func setUpImages() {
        // adding treble clef
        let trebleClef = SKSpriteNode(imageNamed: "treble_clef.png")
        let trebleClefScaledSize = CGSize(width: trebleClef.frame.width / 8, height: trebleClef.frame.height / 8)
        trebleClef.scale(to: trebleClefScaledSize)
        trebleClef.anchorPoint = CGPoint(x: 0, y: 0)
        trebleClef.position = CGPoint(x: 0, y: 0)
        barsNode.addChild(trebleClef)
    }
    
    func reloadLayout() {
        totalDivision = numberOfMeasures * bpm * subdivision
        divisionWidth = resultWidth / totalDivision
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
                    let newXpos = LevelSetup.indentLength + universalPageLoc * (resultWidth / bpm / numberOfMeasures)
                    let newYPos = currentNote.positionInStaff[1] * staffBarHeight + (staffBarHeight / 2)
                    currentNote.position = CGPoint(x: newXpos, y: Double(newYPos))
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
    
    func addCamera() {
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: 0, y: 0)
        let maxScale = bgNode.size.width/frame.size.width
        gameCamera.setScale(maxScale)
        camera = gameCamera
    }
}
