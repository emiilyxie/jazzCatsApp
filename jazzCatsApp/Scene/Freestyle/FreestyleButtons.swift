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
    
    override func setUpButtons() {
        guard let view = view else {
            return
        }
        
        let rightX = self.size.width
        //let topY = self.size.height*0.15
        //let bottomY = self.size.height*0.85
        let topYinView = CGPoint(x: 0, y: view.bounds.size.height*0.15)
        let bottomYinView = CGPoint(x: 0, y: view.bounds.size.height*0.85)
        let topY = convertPoint(fromView: topYinView).y
        let bottomY = convertPoint(fromView: bottomYinView).y
        
        addButton(buttonImage: UIImage(named: "home"), buttonAction: displayPopup, buttonIndex: 2, name: "homeButton", label: "Home", buttonPosition: CGPoint(x: rightX*0.1, y: topY))
        addButton(buttonImage: UIImage(named: "play"), buttonAction: enterMode, buttonIndex: 3, name: "playButton", label: "Play", buttonPosition: CGPoint(x: rightX*0.2, y: topY))
        addButton(buttonImage: UIImage(named: "stop"), buttonAction: enterMode, buttonIndex: 5, name: "stopButton", label: "Stop", buttonPosition: CGPoint(x: rightX*0.3, y: topY))
        addButton(buttonImage: UIImage(named: "settings"), buttonAction: displayPopup, buttonIndex: 1, name: "displaySettingsButton", label: "Settings", buttonPosition: CGPoint(x: rightX*0.7, y: topY))
        addButton(buttonImage: UIImage(named: "share"), buttonAction: displayPopup, buttonIndex: 3, name: "shareCompButton", label: "Share", buttonPosition: CGPoint(x: rightX*0.8, y: topY))
        
        addButton(buttonImage: UIImage(named: "sharp"), buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", label: "Sharp", buttonPosition: CGPoint(x: rightX*0.1, y: bottomY))
        addButton(buttonImage: UIImage(named: "flat"), buttonAction: enterMode, buttonIndex: 8, name: "flatButton", label: "Flat", buttonPosition: CGPoint(x: rightX*0.2, y: bottomY))
        //_ = addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: 150, y: bottomY))
        addButton(buttonImage: UIImage(named: "select"), buttonAction: displayPopup, buttonIndex: 0, name: "selectNoteButton", label: "Select", buttonPosition: CGPoint(x: rightX*0.4, y: bottomY))
        addButton(buttonImage: UIImage(named: "cat_basic1"), buttonAction: enterMode, buttonIndex: 0, name: "addNotesButton", label: "Add", buttonPosition: CGPoint(x: rightX*0.5, y: bottomY))
        addButton(buttonImage: UIImage(named: "erase"), buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", label: "Erase", buttonPosition: CGPoint(x: rightX*0.6, y: bottomY))
        
        addButton(buttonImage: UIImage(named: "prev"), buttonAction: prevPage, buttonIndex: 0, name: "prevPage", label: "Prev", buttonPosition: CGPoint(x: rightX*0.8, y: bottomY))
        addButton(buttonImage: UIImage(named: "next"), buttonAction: nextPage, buttonIndex: 0, name: "nextPage", label: "Next", buttonPosition: CGPoint(x: rightX*0.9, y: bottomY))
        
        //buttons.object(forKey: "homeButton")?.bkgdShape.fillColor = ColorPalette.softAlert
        
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Gaegu"
        pgCountLabel.position = CGPoint(x: rightX*0.75, y: bottomY - 80)
        addChild(pgCountLabel)
        
        super.setUpButtons()
    }
    
    override func displayPopup(sender: Button?, index: Int) {
       guard let gameVC = self.viewController as? GameViewController else {
            print("cant get viewcontroller")
            return
        }
        
        switch index {
        case 0:
            gameVC.showPopover(gameVC, popupID: Constants.noteSelectID)
        case 1:
            gameVC.showPopover(gameVC, popupID: Constants.settingsID, disabledSettings: ["metronome"])
        case 2:
            gameVC.showPopover(gameVC, popupID: Constants.confirmNavID)
        case 3:
            gameVC.showPopover(gameVC, popupID: Constants.shareCompID)
        default:
            print("invalid popup index")
        }
        
        super.displayPopup(sender: sender, index: index)
    }
        
    func returnToWelcomeScreen() {
        self.destruct()
        
        guard let gameVC = self.viewController as! GameViewController? else {
            return
        }

        gameVC.unwindFromGameToWelcome(gameVC)
    }
}
