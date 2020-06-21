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
    
    override func setUpButtons() {
        guard let view = view else {
            return
        }
        
        let rightXinView = CGPoint(x: view.bounds.size.width, y: 0)
        let rightX = convertPoint(fromView: rightXinView).x
        let topYinView = CGPoint(x: 0, y: view.bounds.size.height*0.15)
        let bottomYinView = CGPoint(x: 0, y: view.bounds.size.height*0.85)
        let topY = convertPoint(fromView: topYinView).y
        let bottomY = convertPoint(fromView: bottomYinView).y
        
        _ = addButton(buttonImage: "play", buttonAction: returnToMainMenu, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: rightX*0.1, y: topY))
        _ = addButton(buttonImage: "play", buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: rightX*0.2, y: topY))
        _ = addButton(buttonImage: "pause", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: rightX*0.3, y: topY))
        _ = addButton(buttonImage: "stop", buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: rightX*0.4, y: topY))
        
        _ = addButton(buttonImage: "temp-sharp", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: rightX*0.2, y: bottomY))
        _ = addButton(buttonImage: "temp-flat", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: rightX*0.3, y: bottomY))
        //_ = addButton(buttonImage: "piano1", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: rightX*0.4, y: bottomY))
        _ = addButton(buttonImage: "snare1", buttonAction: displayPopup, buttonIndex: 2, name: "snareButton", buttonPosition: CGPoint(x: rightX*0.5, y: bottomY))
        noteButton = addButton(buttonImage: "cat_basic1", buttonAction: selectNoteType, buttonIndex: 4, name: "catButton", buttonPosition: CGPoint(x: rightX*0.6, y: bottomY))
        _ = addButton(buttonImage: "temp-eraser", buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: rightX*0.7, y: bottomY))
        
        _ = addButton(buttonImage: "audio", buttonAction: playSample, buttonIndex: 0, name: "audioSampleButton", buttonPosition: CGPoint(x: rightX*0.5, y: topY))
        _ = addButton(buttonImage: "hint", buttonAction: generateHint, buttonIndex: 0, name: "hintButton", buttonPosition: CGPoint(x: rightX*0.6, y: topY))
        _ = addButton(buttonImage: "temp-check", buttonAction: submitAns, buttonIndex: 0, name: "submitButton", buttonPosition: CGPoint(x: rightX*0.7, y: topY))
        
        _ = addButton(buttonImage: "temp-leftArrow", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: rightX*0.8, y: bottomY))
        _ = addButton(buttonImage: "temp-rightArrow", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: rightX*0.9, y: bottomY))
        
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Hiragino Mincho ProN"
        pgCountLabel.position = CGPoint(x: rightX*0.8, y: bottomY - 100)
        addChild(pgCountLabel)
    }
    
    func playSample(index: Int) {
        ansSongPlayer?.play()
    }
    
    func generateHint(index: Int) {
        print(GameUser.hints)
        if hintNum >= lvlAns[pageIndex].count || lvlAns[pageIndex].isEmpty {
            print("no more hints")
            return
        }
        if !GameUser.updateField(field: "hints", count: -1) {
            print("you're too broke in hints")
            return
        }
        for noteAnswer in lvlAns[pageIndex] {
            if !myAns[pageIndex].contains(noteAnswer) {
                
                // adding the note to the scene
                let currNotePos = ansArrayToScenePos(ansVal: noteAnswer)
                let currentNote = Note(type: selectedNote)
                currentNote.position = currNotePos
                currentNote.positionInStaff = getStaffPosition(notePosition: currNotePos)
                
                // add a flat if it should be flatted
                if shouldBeFlatted(midiVal: noteAnswer[1]) {
                    editAccidental(accidental: "flat", note: currentNote)
                }
                
                // add the note to the bar
                barsNode.addChild(currentNote)
                myAns[pageIndex].insert(currentNote.getAnsArray())
                pages[pageIndex].append(currentNote)
                hintNum += 1
                return
            }
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
    
    override func displayPopup(index: Int) {
        guard let gameVc = self.viewController as! GameViewController? else {
            return
        }
        gameVc.showNoteSelectPopover(gameVc)
    }
    
    func submitAns(index: Int) {
        if myAns.elementsEqual(lvlAns) {
            
            //display the "yay!"
            yayYouDidIt.zPosition = 100
            yayYouDidIt.run(SKAction.fadeIn(withDuration: 0.5))
            
            // update level progress
            guard let gameVC = self.viewController as? GameViewController else {
                return
            }
            //gameVC.updateUserValue(field: "level-progress", count: 1)
            GameUser.updateLevelProgress(levelGroup: gameVC.levelGroup, currentLevel: gameVC.selectedLevel)
        }
        else {
            
            // display the "nah"
            sorryTryAgain.zPosition = 100
            let fadeInOut = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)])
            sorryTryAgain.run(fadeInOut) {
                self.sorryTryAgain.zPosition = -100
            }
        }
        //print(myAns)
    }
    
    override func nextPage(index: Int) {
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
    
    override func prevPage(index: Int) {
        
        //has the same sort of logic as nextPage func
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
    
    func returnToMainMenu(index: Int) {
        
        // bye bye audiokit
        do {
            ansSongPlayer?.stop()
            AudioKit.disconnectAllInputs()
            try AudioKit.stop()
            try AudioKit.shutdown()
            AudioKit.output = nil
            print(AudioKit.engine.isRunning)
        }
        catch {
            print(error)
        }
        
        // killing the kids
        for child in self.children {
            child.removeAllActions()
        }
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
        self.view?.presentScene(nil)

        // calling the segue func
        guard let gameVC = self.viewController as! GameViewController? else {
            return
        }
        gameVC.unwindFromGameToLevelSelect(gameVC)
       }
}
