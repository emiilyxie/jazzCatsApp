//
//  MusicSceneButtons.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/20/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension MusicScene {
    
    @objc func setUpButtons() {
        //preconditionFailure("must override setupbuttons")
        
        if let addNoteButton = self.buttons.object(forKey: "addNotesButton") {
            selectButton(button: addNoteButton)
            selectedButton = addNoteButton
        }
    }
    
    func addButton(buttonImage: UIImage?, buttonAction: @escaping (Button?, Int) -> (), buttonIndex: Int, name: String, label: String, buttonPosition: CGPoint) {
        let newButton = Button(defaultButtonImage: buttonImage, action: buttonAction, index: buttonIndex, buttonName: name, buttonLabel: label)
        buttons.setObject(newButton, forKey: name as NSString)
        newButton.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y+20)
        addChild(newButton)
    }
    
    func addButton(button: Button, buttonPosition: CGPoint) {
        button.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y+20)
        addChild(button)
    }
    
    func enterMode(sender: Button?, index: Int) {
        
        if let pressedButton = sender  {
            unselectCurrentButton()
            selectButton(button: pressedButton)
            selectedButton = sender
        }
        
        let measureBarResetPos = CGPoint(x: frame.minX + LevelSetup.indentLength - 50.0, y: barsNode.position.y + measureBar.size.height/2)
        let measureBarContinuePos = CGPoint(x: frame.minX + LevelSetup.indentLength - 3, y: barsNode.position.y + measureBar.size.height/2)
        let resetPostion = SKAction.move(to: measureBarResetPos, duration: 0)
        let continuePos = SKAction.move(to: measureBarContinuePos, duration: 0)
        
        switch index {
        case 0:
            currentMode = "addMode"
        case 1:
            currentMode = "eraseMode"
        //case 2:
            //currentMode = "navigateMode"
        case 3:
            //currentMode = "playMode"
            //measureBar.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
            measureBar.physicsBody?.velocity = CGVector(dx: barVelocity, dy: 0)
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
    
    @objc func displayPopup(sender: Button?, index: Int) {
        //preconditionFailure("must override displaypopup")
        timedUnselectButton(sender: sender)
    }
    
    func nextPage(sender: Button?, index: Int) {
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
        if sender != nil {
            enterMode(sender: nil, index: 5)
        }
        updatePgCount()
        timedUnselectButton(sender: sender)
    }
    
    func prevPage(sender: Button?, index: Int) {
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
        if sender != nil {
            enterMode(sender: nil, index: 5)
        }
        updatePgCount()
        timedUnselectButton(sender: sender)
    }
    
    func updatePgCount() {
        pgCountLabel.text = "page: \(pageIndex+1)/\(maxPages)"
    }
    
    func selectButton(button: Button) {
        button.bkgdShape.fillColor = ColorPalette.brightManuscript
        button.selected = true
        //selectedButton = button
    }
    
    func unselectCurrentButton() {
        selectedButton?.bkgdShape.fillColor = ColorPalette.unselectedButton
        selectedButton?.selected = false
    }
    
    func unselectCurrentButton(button: Button) {
        button.bkgdShape.fillColor = ColorPalette.unselectedButton
        button.selected = false
    }
    
    func timedUnselectButton(sender: Button?) {
        
        if let button = sender {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.unselectCurrentButton(button: button)
            }
        }
    }
    
    func destruct() {
        do {
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
    }
}
