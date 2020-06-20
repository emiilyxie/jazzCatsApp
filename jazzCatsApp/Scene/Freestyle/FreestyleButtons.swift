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
        
        let rightXinView = CGPoint(x: view.bounds.size.width, y: 0)
        let rightX = convertPoint(fromView: rightXinView).x
        let topYinView = CGPoint(x: 0, y: view.bounds.size.height*0.15)
        let bottomYinView = CGPoint(x: 0, y: view.bounds.size.height*0.85)
        let topY = convertPoint(fromView: topYinView).y
        let bottomY = convertPoint(fromView: bottomYinView).y
        
        _ = addButton(buttonImage: "play", buttonAction: returnToWelcomeScreen, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: rightX*0.1, y: topY))
        _ = addButton(buttonImage: "play", buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: rightX*0.2, y: topY))
        _ = addButton(buttonImage: "pause", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: rightX*0.3, y: topY))
        _ = addButton(buttonImage: "stop", buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: rightX*0.4, y: topY))
        _ = addButton(buttonImage: "snare1", buttonAction: displayPopup, buttonIndex: 0, name: "displaySettingsButton", buttonPosition: CGPoint(x: rightX*0.7, y: topY))
        
        _ = addButton(buttonImage: "temp-sharp", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: rightX*0.1, y: bottomY))
        _ = addButton(buttonImage: "temp-flat", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: rightX*0.2, y: bottomY))
        //_ = addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: 150, y: bottomY))
        _ = addButton(buttonImage: "snare1", buttonAction: displayPopup, buttonIndex: 1, name: "snareButton", buttonPosition: CGPoint(x: rightX*0.3, y: bottomY))
        noteButton = addButton(buttonImage: "cat_basic1", buttonAction: selectNoteType, buttonIndex: 4, name: "catButton", buttonPosition: CGPoint(x: rightX*0.4, y: bottomY))
        _ = addButton(buttonImage: "temp-eraser", buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: rightX*0.5, y: bottomY))
        
        _ = addButton(buttonImage: "temp-leftArrow", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: rightX*0.7, y: bottomY))
        _ = addButton(buttonImage: "temp-rightArrow", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: rightX*0.8, y: bottomY))
        
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Hiragino Mincho ProN"
        pgCountLabel.position = CGPoint(x: rightX*0.7, y: bottomY - 70)
        addChild(pgCountLabel)
    }
    
    override func displayPopup(index: Int) {
        guard let gameVc = self.viewController as! GameViewController? else {
            return
        }
        
        switch index {
        case 0:
            gameVc.showSettingsPopover(gameVc)
        default:
            gameVc.showNoteSelectPopover(gameVc)
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
        print("bye bitch")
    }
}
