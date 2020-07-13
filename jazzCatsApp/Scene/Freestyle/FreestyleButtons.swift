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
        
        let defaultConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light, scale: .default)
        
        addButton(buttonImage: UIImage(systemName: "house", withConfiguration: defaultConfig), buttonAction: displayPopup, buttonIndex: 2, name: "homeButton", buttonPosition: CGPoint(x: rightX*0.1, y: topY))
        addButton(buttonImage: UIImage(systemName: "play", withConfiguration: defaultConfig), buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: rightX*0.2, y: topY))
        addButton(buttonImage: UIImage(systemName: "stop", withConfiguration: defaultConfig), buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: rightX*0.3, y: topY))
        addButton(buttonImage: UIImage(systemName: "slider.horizontal.3", withConfiguration: defaultConfig), buttonAction: displayPopup, buttonIndex: 1, name: "displaySettingsButton", buttonPosition: CGPoint(x: rightX*0.7, y: topY))
        addButton(buttonImage: UIImage(systemName: "square.and.arrow.up", withConfiguration: defaultConfig), buttonAction: displayPopup, buttonIndex: 3, name: "shareCompButton", buttonPosition: CGPoint(x: rightX*0.8, y: topY))
        
        addButton(buttonImage: UIImage(named: "sharp"), buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: rightX*0.1, y: bottomY))
        addButton(buttonImage: UIImage(named: "flat"), buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: rightX*0.2, y: bottomY))
        //_ = addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: 150, y: bottomY))
        addButton(buttonImage: UIImage(systemName: "pencil", withConfiguration: defaultConfig), buttonAction: displayPopup, buttonIndex: 0, name: "selectNoteButton", buttonPosition: CGPoint(x: rightX*0.3, y: bottomY))
        addButton(buttonImage: UIImage(named: "cat_basic1"), buttonAction: selectNoteType, buttonIndex: 4, name: "addNotesButton", buttonPosition: CGPoint(x: rightX*0.4, y: bottomY))
        addButton(buttonImage: UIImage(systemName: "trash", withConfiguration: defaultConfig), buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: rightX*0.5, y: bottomY))
        
        addButton(buttonImage: UIImage(systemName: "chevron.left", withConfiguration: defaultConfig), buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: rightX*0.7, y: bottomY))
        addButton(buttonImage: UIImage(systemName: "chevron.right", withConfiguration: defaultConfig), buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: rightX*0.8, y: bottomY))
        
        /*
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Hiragino Mincho ProN"
        pgCountLabel.position = CGPoint(x: rightX*0.7, y: bottomY - 70)
        addChild(pgCountLabel)
 */
    }
    
    override func displayPopup(index: Int) {
       guard let gameVC = self.viewController as? GameViewController else {
            print("cant get viewcontroller")
            return
        }
        
        switch index {
        case 0:
            gameVC.showNoteSelectPopover(gameVC)
        case 1:
            gameVC.showSettingsPopover(gameVC)
        case 2:
            gameVC.showConfirmNavPopover(gameVC)
        case 3:
            gameVC.showShareCompPopover(gameVC)
        default:
            print("invalid popup index")
        }
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
    }
}
