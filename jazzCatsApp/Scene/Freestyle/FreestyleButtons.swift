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

extension Freestyle {
    
    func setUpButtons() {
        guard let view = view else {
            return
        }
        
        let topYinView = CGPoint(x: 0, y: view.bounds.size.height*0.15)
        let bottomYinView = CGPoint(x: 0, y: view.bounds.size.height*0.85)
        let topY = convertPoint(fromView: topYinView).y
        let bottomY = convertPoint(fromView: bottomYinView).y
        
        addButton(buttonImage: "play.png", buttonAction: returnToWelcomeScreen, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: 50, y: topY))
        addButton(buttonImage: "play.png", buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: 100, y: topY))
        addButton(buttonImage: "pause.png", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: 150, y: topY))
        addButton(buttonImage: "stop.png", buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: 200, y: topY))
        
        addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: 150, y: bottomY))
        addButton(buttonImage: "snare.png", buttonAction: selectNoteType, buttonIndex: 2, name: "snareButton", buttonPosition: CGPoint(x: 200, y: bottomY))
        addButton(buttonImage: "cat.png", buttonAction: selectNoteType, buttonIndex: 4, name: "catButton", buttonPosition: CGPoint(x: 250, y: bottomY))
        addButton(buttonImage: "eraser.png", buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: 300, y: bottomY))
        addButton(buttonImage: "sharp.png", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: 50, y: bottomY))
        addButton(buttonImage: "flat.png", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: 100, y: bottomY))
        
        addButton(buttonImage: "leftArrow.png", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: 400, y: bottomY))
        addButton(buttonImage: "rightArrow.png", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: 450, y: bottomY))
        
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages!)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Hiragino Mincho ProN"
        pgCountLabel.position = CGPoint(x: 400, y: bottomY - 70)
        addChild(pgCountLabel)
        
        addButton(buttonImage: "snare.png", buttonAction: displayPopup, buttonIndex: 0, name: "displaySettingsButton", buttonPosition: CGPoint(x: 350, y: topY))
    }
    
    func addButton(buttonImage: String, buttonAction: @escaping (Int) -> (), buttonIndex: Int, name: String, buttonPosition: CGPoint) {
        let newButton = Button(defaultButtonImage: buttonImage, action: buttonAction, index: buttonIndex, buttonName: name)
        newButton.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y)
        addChild(newButton)
    }
    
    func addButton(button: Button, buttonPosition: CGPoint) {
        button.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y)
        addChild(button)
    }
    
    func enterMode(index: Int) {
        let measureBarResetPos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + LevelSetup.indentLength - 20), y: barsNode.position.y + measureBar.size.height/2)
        let measureBarContinuePos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + LevelSetup.indentLength), y: barsNode.position.y + measureBar.size.height/2)
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
    
    func nextPage(index: Int) {
        if pageIndex < maxPages - 1 {
            for note in pages[pageIndex] {
                note.isHidden = true
                note.physicsBody?.categoryBitMask = PhysicsCategories.none
            }
            pageIndex += 1
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
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
        }
        updatePgCount()
    }
    
    func updatePgCount() {
        pgCountLabel.text = "page: \(pageIndex+1)/\(maxPages!)"
    }
    /*
    func displayPopup(index: Int) {
        print("clicked display popup")
        switch index {
        case 0:
            settingsPopup.isUserInteractionEnabled = true
            settingsPopup.isHidden = false
            settingsPopup.zPosition = 100
            barsNode.isUserInteractionEnabled = false
        default:
            settingsPopup.zPosition = 100
        }
    }
 */
    
    func displayPopup(index: Int) {
        guard let gameVc = self.viewController as! GameViewController? else {
            return
        }
        gameVc.showSettingsPopover(gameVc)
    }
        
    func returnToWelcomeScreen(index: Int) {
        do {
            //mixer.stop()
            //mixer.detach()
            AudioKit.disconnectAllInputs()
            try AudioKit.shutdown()
            AudioKit.output = nil
        }
        catch {
            print(error)
        }

        for child in self.children {
            child.removeAllActions()
            child.removeFromParent()
        }
        self.scene!.removeAllActions()
        self.scene!.removeAllChildren()
        self.scene!.removeFromParent()
        self.view?.presentScene(nil)
        
        guard let gameVC = self.viewController as! GameViewController? else {
            return
        }

        gameVC.unwindFromGameToWelcome(gameVC)
        print("bye bitch")
    }
}
