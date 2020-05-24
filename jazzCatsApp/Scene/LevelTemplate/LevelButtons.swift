//
//  LevelButtons.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension LevelTemplate {
    
    func setUpButtons() {
        
        guard let view = view else {
            return
        }
        
        let topYinView = CGPoint(x: 0, y: view.bounds.size.height*0.15)
        let bottomYinView = CGPoint(x: 0, y: view.bounds.size.height*0.85)
        let topY = convertPoint(fromView: topYinView).y
        let bottomY = convertPoint(fromView: bottomYinView).y
        
        addButton(buttonImage: "play.png", buttonAction: returnToMainMenu, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: 50, y: topY))
        addButton(buttonImage: "play.png", buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: 100, y: topY))
        addButton(buttonImage: "pause.png", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: 150, y: topY))
        addButton(buttonImage: "stop.png", buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: 200, y: topY))
        
        
        addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: 150, y: bottomY))
        addButton(buttonImage: "snare.png", buttonAction: selectNoteType, buttonIndex: 2, name: "snareButton", buttonPosition: CGPoint(x: 200, y: bottomY))
        addButton(buttonImage: "cat.png", buttonAction: selectNoteType, buttonIndex: 4, name: "catButton", buttonPosition: CGPoint(x: 250, y: bottomY))
        addButton(buttonImage: "eraser.png", buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: 300, y: bottomY))
        addButton(buttonImage: "sharp.png", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: 50, y: bottomY))
        addButton(buttonImage: "flat.png", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: 100, y: bottomY))
        
        addButton(buttonImage: "audio.png", buttonAction: playSample, buttonIndex: 0, name: "audioSampleButton", buttonPosition: CGPoint(x: 350, y: topY))
        addButton(buttonImage: "lightbulb.png", buttonAction: generateHint, buttonIndex: 0, name: "hintButton", buttonPosition: CGPoint(x: 400, y: topY))
        addButton(buttonImage: "check.png", buttonAction: submitAns, buttonIndex: 0, name: "submitButton", buttonPosition: CGPoint(x: 450, y: topY))
        
        addButton(buttonImage: "leftArrow.png", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: 400, y: bottomY))
        addButton(buttonImage: "rightArrow.png", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: 450, y: bottomY))
        
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages!)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Hiragino Mincho ProN"
        pgCountLabel.position = CGPoint(x: 400, y: bottomY - 100)
        addChild(pgCountLabel)
    }
    
    func addButton(buttonImage: String, buttonAction: @escaping (Int) -> (), buttonIndex: Int, name: String, buttonPosition: CGPoint) {
        //let buttonYPosition = staffHeightFromGround - 20
        let newButton = Button(defaultButtonImage: buttonImage, action: buttonAction, index: buttonIndex, buttonName: name)
        newButton.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y)
        //buttonXPosition += 40
        addChild(newButton)
    }
    
    func enterMode(index: Int) {
        let measureBarResetPos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + indentLength - 20), y: barsNode.position.y + measureBar.size.height/2)
        let measureBarContinuePos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + indentLength), y: barsNode.position.y + measureBar.size.height/2)
        let resetPostion = SKAction.move(to: measureBarResetPos, duration: 0)
        let continuePos = SKAction.move(to: measureBarContinuePos, duration: 0)
        
        switch index {
        case 0:
            currentMode = "addMode"
        case 1:
            currentMode = "eraseMode"
        case 2:
            currentMode = "navigateMode"
        case 3:
            currentMode = "playMode"
            measureBar.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
        case 4:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        case 5:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            measureBar.run(resetPostion)
        case 6:
            measureBar.run(continuePos)
        case 7:
            currentMode = "sharpMode"
        case 8:
            currentMode = "flatMode"
        default:
            currentMode = "addMode"
        }
    }
    
    func selectNoteType(index: Int) {
        currentMode = "addMode"
        switch index {
        case 0:
            selectedNoteType = NoteType.piano
        case 1:
            selectedNoteType = NoteType.bass
        case 2:
            selectedNoteType = NoteType.snare
        case 3:
            selectedNoteType = NoteType.hihat
        case 4:
            selectedNoteType = NoteType.cat
        default:
            selectedNoteType = NoteType.piano
        }
    }
    
    func playSample(index: Int) {
        //barsNode.run(SKAction.playSoundFileNamed("lvl3song.mp3", waitForCompletion: false))
        ansSongPlayer.play()
    }
    
    func generateHint(index: Int) {
        if hintNum < lvlAns[pageIndex].count && !lvlAns[pageIndex].isEmpty {
            for noteAnswer in lvlAns[pageIndex] {
                if !myAns[pageIndex].contains(noteAnswer) {
                    let currNotePos = ansArrayToScenePos(ansVal: noteAnswer)
                    //addNote(noteType: selectedNoteType, notePosition: currNotePos)
                    //let currentNote = pages[pageIndex].last!
                    let currentNote = Note(type: selectedNoteType)
                    currentNote.name = "note"
                    currentNote.position = currNotePos
                    currentNote.positionInStaff = getStaffPosition(notePosition: currNotePos)
                    currentNote.physicsBody = SKPhysicsBody(rectangleOf: currentNote.size)
                    currentNote.physicsBody?.isDynamic = false
                    currentNote.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
                    currentNote.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
                    currentNote.physicsBody?.collisionBitMask = PhysicsCategories.none
                    if shouldBeFlatted(midiVal: noteAnswer[1]) {
                    //if currentNote.getNoteName().contains("s") {
                        currentNote.toggleFlat()
                        let flat = SKSpriteNode(imageNamed: "flat.png")
                        flat.size = scaleNode(size: flat.size, factor: Double(0.05))
                        flat.position = CGPoint(x: -20, y: 0)
                        currentNote.addChild(flat)
                    //}
                    }
                    barsNode.addChild(currentNote)
                    myAns[pageIndex].insert(currentNote.getAnsArray())
                    pages[pageIndex].append(currentNote)
                    hintNum += 1
                    return
                }
                /*
                if !pitches.isEmpty && hintNum < lvlAns[pageIndex].count {
                    let xPos = hintNum * divisionWidth + indentLength
                    var yPos = (trebleNotes.firstIndex(of: pitches)! - 1) * staffBarHeight + 10
                    if pitches.contains("3") { // if it's gonna be B3 or C flat
                        yPos = 10
                        addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                        let currentNote = pages[pageIndex].last!
                        currentNote.toggleFlat()
                        let flat = SKSpriteNode(imageNamed: "flat.png")
                        flat.size = scaleNode(size: flat.size, factor: Double(0.05))
                        flat.position = CGPoint(x: -20, y: 0)
                        currentNote.addChild(flat)
                        //myAns[pageIndex][hintNum].remove("C4")
                        //myAns[pageIndex][hintNum].insert(currentNote.getNoteName())
                    }
                    else if pitches.contains("s") {
                        yPos = (trebleNotes.firstIndex(of: pitches)! - 13) * staffBarHeight + 10
                        addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                        let currentNote = pages[pageIndex].last!
                        currentNote.toggleSharp()
                        let sharp = SKSpriteNode(imageNamed: "sharp.png")
                        sharp.size = scaleNode(size: sharp.size, factor: Double(0.05))
                        sharp.position = CGPoint(x: -20, y: 0)
                        currentNote.addChild(sharp)
                        let naturalNote = String(pitches.prefix(2))
                        //myAns[pageIndex][hintNum].remove(naturalNote)
                        //myAns[pageIndex][hintNum].insert(currentNote.getNoteName())
                    }
                    else {
                        addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                        let currentNote = pages[pageIndex].last!
                        myAns[pageIndex][hintNum].insert(currentNote.getNoteName())
                    }
 */
                
            }
        }
        else {
            print("no more hints")
        }
    }
    
    /*
    func generatePage(index: Int) {
        var count = 0
        let noteSet = lvlAns[pageIndex]
        for note in noteSet {
            if !note.isEmpty {
                for pitch in note {
                    let xPos = count * divisionWidth + indentLength
                    let yPos = trebleNotes.firstIndex(of: pitch)! * staffBarHeight
                    addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                    count += 1
                }
            }
            else {
                count += 1
            }
        }
    }
 */
    
    func submitAns(index: Int) {
        if myAns.elementsEqual(lvlAns) {
            yayYouDidIt.zPosition = 100
            yayYouDidIt.run(SKAction.fadeIn(withDuration: 0.5))
        }
        else {
            sorryTryAgain.zPosition = 100
            let fadeInOut = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)])
            sorryTryAgain.run(fadeInOut) {
                self.sorryTryAgain.zPosition = -100
            }
        }
        //print(myAns)
    }
    
    func nextPage(index: Int) {
        if pageIndex < maxPages - 1 {
            for note in pages[pageIndex] {
                note.isHidden = true
                note.physicsBody?.categoryBitMask = PhysicsCategories.none
            }
            pageIndex += 1
            hintNum = 0
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
        }
        updatePgCount()
    }
    
    func prevPage(index: Int) {
        if pageIndex >= 1 {
            for note in pages[pageIndex] {
                note.isHidden = true
                note.physicsBody?.categoryBitMask = PhysicsCategories.none
            }
            pageIndex -= 1
            hintNum = 0
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
            updatePgCount()
        }
    }
    
    func updatePgCount() {
        pgCountLabel.text = "page: \(pageIndex+1)/\(maxPages!)"
    }
    
    func returnToMainMenu(index: Int) {
           do {
                ansSongPlayer.stop()
               AudioKit.disconnectAllInputs()
               try AudioKit.shutdown()
               AudioKit.output = nil
           }
           catch {
               print(error)
           }

           for child in self.children {
               child.removeAllActions()
           }
           self.removeAllActions()
           self.removeAllChildren()
           self.removeFromParent()
           self.view?.presentScene(nil)
    
           guard let gameVC = self.viewController as! GameViewController? else {
               return
           }
           gameVC.unwindFromGameToLevelSelect(gameVC)
           
           print("bye bitch")
       }
}
