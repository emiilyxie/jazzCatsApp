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
        //setUpPopups()
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
                let xPos = indentLength + i * divisionWidth
                let measureLine = SKShapeNode(rect: CGRect(x: xPos, y: 0, width: lineWidth, height: staffTotalHeight))
                measureLine.fillColor = UIColor.black
                measureLine.strokeColor = UIColor.clear
                barsNode.addChild(measureLine)
            }
        }
        
        // final bar with physics
        let finalBar = SKSpriteNode(color: UIColor.black, size: CGSize(width: 6, height: staffTotalHeight))
        finalBar.position = CGPoint(x: indentLength + totalDivision * divisionWidth, y: Int(finalBar.size.height) / 2)
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
        measureBar.position.x = CGFloat(Int(bgNode.frame.minX) + indentLength - 20)
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
    
    /*
    
    func setUpPopups() {
        settingsPopup = SKShapeNode(rect: CGRect(width: frame.width/2, height: frame.height*0.75), cornerRadius: CGFloat(5))
        settingsPopup.fillColor = UIColor(red: 0.97, green: 0.84, blue: 0.58, alpha: 1.00)
        settingsPopup.position = CGPoint(x: 0, y: 0)
        settingsPopup.zPosition = -100
        
        //let leftColX = CGFloat(10)
        //let rightColX = settingsPopup.frame.maxX-40
        
        createLabelNode(text: "pages: ", yPos: CGFloat(50))
        createLabelNode(text: "measures per page: ", yPos: CGFloat(100))
        createLabelNode(text: "beats per measure: ", yPos: CGFloat(150))
        createLabelNode(text: "subdivision per beat: ", yPos: CGFloat(200))

        createNumbersAndCtrls(num: maxPages, yPos: CGFloat(50), minNum: 1, maxNum: 8)
        createNumbersAndCtrls(num: numberOfMeasures, yPos: CGFloat(100), minNum: 1, maxNum: 4)
        createNumbersAndCtrls(num: bpm, yPos: CGFloat(150), minNum: 1, maxNum: 9)
        createNumbersAndCtrls(num: subdivision, yPos: CGFloat(200), minNum: 1, maxNum: 12)
        
        addChild(settingsPopup)
        settingsPopup.isHidden = true
        settingsPopup.isUserInteractionEnabled = false
    }
    
    func createLabelNode(text: String, yPos: CGFloat) {
        let leftColX = CGFloat(10)
        let labelNode = SKLabelNode(text: text)
        labelNode.fontColor = UIColor.black
        labelNode.fontSize = 30
        labelNode.fontName = "Hiragino Mincho ProN"
        labelNode.position = CGPoint(x: leftColX, y: yPos)
        settingsPopup.addChild(labelNode)
    }
    
    func createLabelNode(text: String, xPos: CGFloat, yPos: CGFloat) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontColor = UIColor.black
        labelNode.fontSize = 30
        labelNode.fontName = "Hiragino Mincho ProN"
        labelNode.position = CGPoint(x: xPos, y: yPos)
        settingsPopup.addChild(labelNode)
        return labelNode
    }
    
    func createNumbersAndCtrls(num: Int, yPos: CGFloat, minNum: Int, maxNum: Int) {
        let rightColX = settingsPopup.frame.maxX-40
        let xDisplacement = CGFloat(10)
        let labelNode = createLabelNode(text: "\(String(describing: num))",xPos: rightColX, yPos: yPos)
        let minusNumCtrl = NumberControls(minVal: minNum, maxVal: maxNum, isPlus: false)
        let plusNumCtrl = NumberControls(minVal: minNum, maxVal: maxNum, isPlus: true)
        minusNumCtrl.position = CGPoint(x: -xDisplacement, y: 0)
        plusNumCtrl.position = CGPoint(x: xDisplacement, y: 0)
        labelNode.addChild(minusNumCtrl)
        labelNode.addChild(plusNumCtrl)
    }
 */
    
    func reloadLayout() {
        totalDivision = numberOfMeasures * bpm * subdivision
        divisionWidth = (Int(self.frame.width) - indentLength) / totalDivision
        barsNode.removeAllChildren()
        barsNode.removeFromParent()
        setUpStaff()
        pageIndex = 0
        updatePgCount()
        repositionNotes()
    }
    
    func repositionNotes() {
        let oldDivision = numberOfMeasures * bpm * oldSubdivision
        //let oldDivWidth = (Int(self.frame.width) - indentLength) / oldDivision
        var newPgArray = [[Note]](repeating: [], count: maxPages)
        for i in 0...pages.count-1 {
            for j in 0...pages[i].count {
                if j == 0 {continue}
                let currentNote = pages[i][j-1]
                let maxNewArrayPos = maxPages * oldDivision
                if currentNote.positionInStaff[0]*(i+1) < maxNewArrayPos {
                    let universalNoteLocation = (currentNote.positionInStaff[0]) + (i * oldNumOfMeasures * oldBpm * oldSubdivision)
                    //print("universal note loc: \(universalNoteLocation)")
                    let newPgNum = Int(floor(universalNoteLocation/(oldDivision*numberOfMeasures)))
                    //print("new pg num: \(newPgNum)")
                    let newPos = universalNoteLocation % oldDivision
                    //print("new pos: \(newPos)")
                    currentNote.positionInStaff[0] = newPos
                    //let newXpos = indentLength + newPos * oldDivWidth
                    //let newYPos = currentNote.positionInStaff[1] * staffBarHeight + (staffBarHeight / 2)
                    let newScenePos = staffPosToScenePos(staffPos: currentNote.positionInStaff)
                    currentNote.position = newScenePos
                    barsNode.addChild(currentNote)
                    newPgArray[newPgNum].append(currentNote)
                }
            }
        }
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
