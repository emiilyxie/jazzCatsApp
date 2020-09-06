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
        //let topYinView = CGPoint(x: 0, y: view.bounds.size.height*0.1)
        //let bottomYinView = CGPoint(x: 0, y: view.bounds.size.height*0.9)
        let topYinView = CGPoint(x: 0, y: 0)
        let bottomYinView = CGPoint(x: 0, y: view.bounds.size.height)
        let topY = convertPoint(fromView: topYinView).y - CGFloat(100)
        let bottomY = convertPoint(fromView: bottomYinView).y + CGFloat(100)
        
        addButton(buttonImage: UIImage(named: "home"), buttonAction: displayPopup, buttonIndex: 2, name: "homeButton", label: "Home", buttonPosition: CGPoint(x: rightX*0.1, y: topY))
        addButton(buttonImage: UIImage(named: "play"), buttonAction: enterMode, buttonIndex: 3, name: "playButton", label: "Play", buttonPosition: CGPoint(x: rightX*0.2, y: topY))
        //_ = addButton(buttonImage: "pause", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: rightX*0.3, y: topY))
        addButton(buttonImage: UIImage(named: "stop"), buttonAction: enterMode, buttonIndex: 5, name: "stopButton", label: "Stop", buttonPosition: CGPoint(x: rightX*0.3, y: topY))
        
        addButton(buttonImage: UIImage(named: "sharp"), buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", label: "Sharp", buttonPosition: CGPoint(x: rightX*0.1, y: bottomY))
        addButton(buttonImage: UIImage(named: "flat"), buttonAction: enterMode, buttonIndex: 8, name: "flatButton", label: "Flat", buttonPosition: CGPoint(x: rightX*0.2, y: bottomY))
        //_ = addButton(buttonImage: "piano1", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: rightX*0.4, y: bottomY))
        addButton(buttonImage: UIImage(named: "select"), buttonAction: displayPopup, buttonIndex: 0, name: "selectNoteButton", label: "Select", buttonPosition: CGPoint(x: rightX*0.4, y: bottomY))
        addButton(buttonImage: UIImage(named: "cat_basic1"), buttonAction: enterMode, buttonIndex: 0, name: "addNotesButton", label: "Add", buttonPosition: CGPoint(x: rightX*0.5, y: bottomY))
        addButton(buttonImage: UIImage(named: "erase"), buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", label: "Erase", buttonPosition: CGPoint(x: rightX*0.6, y: bottomY))
        
        addButton(buttonImage: UIImage(named: "settings"), buttonAction: displayPopup, buttonIndex: 1, name: "displaySettingsButton", label: "Settings", buttonPosition: CGPoint(x: rightX*0.5, y: topY))
        addButton(buttonImage: UIImage(named: "audio"), buttonAction: playSample, buttonIndex: 0, name: "audioSampleButton", label: "Audio", buttonPosition: CGPoint(x: rightX*0.6, y: topY))
        addButton(buttonImage:  UIImage(named: "hint"), buttonAction: generateHint, buttonIndex: 0, name: "hintButton", label: "Hint", buttonPosition: CGPoint(x: rightX*0.7, y: topY))
        addButton(buttonImage: UIImage(named: "submit"), buttonAction: submitAns, buttonIndex: 0, name: "submitButton", label: "Submit", buttonPosition: CGPoint(x: rightX*0.8, y: topY))
        
        addButton(buttonImage: UIImage(named: "prev"), buttonAction: prevPage, buttonIndex: 0, name: "prevPage", label: "Prev", buttonPosition: CGPoint(x: rightX*0.8, y: bottomY))
        addButton(buttonImage: UIImage(named: "next"), buttonAction: nextPage, buttonIndex: 0, name: "nextPage", label: "Next", buttonPosition: CGPoint(x: rightX*0.9, y: bottomY))
        
        //buttons.object(forKey: "homeButton")?.bkgdShape.fillColor = ColorPalette.softAlert
        
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Gaegu"
        pgCountLabel.position = CGPoint(x: rightX*0.85, y: bottomY - 80)
        addChild(pgCountLabel)
        
        let hintNotification = SKShapeNode(circleOfRadius: CGFloat(20))
        hintNotification.fillColor = ColorPalette.softAlert
        hintNotification.lineWidth = 0
        hintNotification.zPosition = 500
        hintNotification.addChild(hintCount)
        if let hintButton = buttons.object(forKey: "hintButton") {
            hintButton.addChild(hintNotification)
            hintNotification.position = CGPoint(x: 50, y: 30)
        }
        
        super.setUpButtons()
    }
    
    func playSample(sender: Button?, index: Int) {
        //ansSongPlayer?.play()
        
        guard let sequencer = GameUser.conductor?.sequencer, let samplers = GameUser.conductor?.samplers else {
            print("cant get sequencer or sampler")
            return
        }
        
        if let soundIndex = GameUser.unlockedSoundNames.firstIndex(of: selectedNote) {
            
            //let sampler = samplers.object(forKey: selectedNote as NSString)
            sequencer.tracks[0].setMIDIOutput(samplers[soundIndex].midiIn)
                    }
        else {
            print("couldnt get soundindex")
            //let sampler = samplers.object(forKey: selectedNote as NSString)
            //sequencer.tracks[0].setMIDIOutput(sampler?.midiIn ?? 0)
            sequencer.tracks[0].setMIDIOutput(samplers[0].midiIn)
        }
        if sequencer.isPlaying {
            sequencer.stop()
            sequencer.rewind()
            if let button = sender {
                unselectCurrentButton(button: button)
            }
        }
        else {
            sequencer.play()
            
            let sequenceTime = AKDuration(beats: maxPages * numberOfMeasures * bpm, tempo: BPM(tempo))
            DispatchQueue.main.asyncAfter(deadline: .now() + sequenceTime.seconds) {
                if sequencer.currentPosition >= AKDuration(beats: self.maxPages * self.numberOfMeasures * self.bpm - 1.0) {
                    sequencer.stop()
                    sequencer.rewind()
                    if let button = sender {
                        self.unselectCurrentButton(button: button)
                    }
                }
            }
        }
    }
    
    func generateHint(sender: Button?, index: Int) {
        
        if lvlAns.isEmpty || lvlAns.isSubset(of: noteData) {
            if let gameVc = viewController as? GameViewController {
                UIStyling.showAlert(viewController: gameVc, text: "No more hints.")
            }
            return
        }
        
        if !GameUser.enoughValue(field: "hints", count: -1) {
            if let gameVc = viewController as? GameViewController {
                UIStyling.showAlert(viewController: gameVc, text: "You don't have enough hints.")
            }
            return
        }
        /*
        if !GameUser.updateField(field: "hints", count: -1) {
            if let gameVc = viewController as? GameViewController {
                UIStyling.showAlert(viewController: gameVc, text: "You don't have enough hints.")
            }
            return
        }
 */
        
        let measuresOnPage = pageIndex * numberOfMeasures + 1...pageIndex * numberOfMeasures + numberOfMeasures
        for noteAnswer in lvlAns {
            if !noteData.contains(noteAnswer){
                if measuresOnPage.contains(Int(noteAnswer[0])) {
                    
                    print("note ans: \(noteAnswer)")
                    addNote(with: noteAnswer, on: pageIndex, soundID: selectedNote)
                    _ = GameUser.updateField(field: "hints", count: -1)
                    hintCount.text = String(GameUser.hints)
                    timedUnselectButton(sender: sender)
                    return
                    
                }
            }
        }
        if let gameVc = viewController as? GameViewController {
            UIStyling.showAlert(viewController: gameVc, text: "No more hints for this page.")
        }
        timedUnselectButton(sender: sender)
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
    
    override func displayPopup(sender: Button?, index: Int) {
        guard let gameVC = self.viewController as? GameViewController else {
            print("cant get viewcontroller")
            return
        }
        
        switch index {
        case 0:
            //gameVC.showNoteSelectPopover(gameVC)
            gameVC.showPopover(gameVC, popupID: Constants.noteSelectID)
        case 1:
            //gameVC.showSettingsPopover(gameVC)
            gameVC.showPopover(gameVC, popupID: Constants.settingsID, disabledSettings: ["pgs", "mpp", "bpm"])
        case 2:
            //gameVC.showConfirmNavPopover(gameVC)
            gameVC.showPopover(gameVC, popupID: Constants.confirmNavID)
        default:
            print("invalid popup index")
        }
        super.displayPopup(sender: sender, index: index)
        timedUnselectButton(sender: sender)
    }
    
    func hideButtons(buttons: [String]) {
        for buttonName in buttons {
            if let button = self.buttons.object(forKey: buttonName as NSString) {
                button.isHidden = true
            }
        }
    }
    
    func submitAns(sender: Button?, index: Int) {
        /*
        if let button = sender {
            button.isUserInteractionEnabled = false
        }
 */
        
        if noteData == lvlAns {
            
            // update level progress
            guard let gameVC = self.viewController as? GameViewController else {
                return
            }
            var rewardMessage = ""
            if let from = from {
                rewardMessage = "transcription from: \(from)\n\n"
            }
            rewardMessage = "\(rewardMessage)You earned:\n"
            
            if GameUser.levelAlreadyCompleted(levelGroup: gameVC.levelGroup, currentLevel: gameVC.selectedLevel) {
                rewardMessage = "\(rewardMessage)Nothing, because you've already completed this level"
                gameVC.showPopover(gameVC, popupID: Constants.levelCompleteID, rewardMessage: rewardMessage)
            }
            else {
                if reward.keys.contains("sound") {
                    
                    UIStyling.showLoading(viewController: gameVC)
                    UIStyling.showAlert(viewController: gameVC, text: "Downloading a new Jazzcat! Please stay connected to the internet.", duration: 5)
                    GameUser.updateSounds(newSound: reward["sound"] as! String) {
                        rewardMessage = "\(rewardMessage)\(GameUser.updateLevelProgress(levelGroup: gameVC.levelGroup, currentLevel: gameVC.selectedLevel, reward: self.reward))"
                        gameVC.showPopover(gameVC, popupID: Constants.levelCompleteID, rewardMessage: rewardMessage)
                        UIStyling.hideLoading(view: gameVC.view)
                    }
                }
                else {
                    rewardMessage = "\(rewardMessage)\(GameUser.updateLevelProgress(levelGroup: gameVC.levelGroup, currentLevel: gameVC.selectedLevel, reward: reward))"
                    gameVC.showPopover(gameVC, popupID: Constants.levelCompleteID, rewardMessage: rewardMessage)
                }
            }
            
            
            /*
            if reward.keys.contains("sound") {
                GameUser.updateSounds(newSound: reward["sound"] as! String) {
                    let rewardMessage = GameUser.updateLevelProgress(levelGroup: gameVC.levelGroup, currentLevel: gameVC.selectedLevel, reward: self.reward)
                    gameVC.showPopover(gameVC, popupID: Constants.levelCompleteID, rewardMessage: rewardMessage)
                }
            }
            else {
                let rewardMessage = GameUser.updateLevelProgress(levelGroup: gameVC.levelGroup, currentLevel: gameVC.selectedLevel, reward: reward)
                gameVC.showPopover(gameVC, popupID: Constants.levelCompleteID, rewardMessage: rewardMessage)
            }*/
            /*
            do {
                try AudioKit.shutdown()
            }
            catch {
                print(error)
            }
 */
        }
        else {
            
            // display the "nah"
            if let gameVc = viewController as? GameViewController {
                UIStyling.showAlert(viewController: gameVc, text: "Try Again.")
            }
            /*
            sorryTryAgain.zPosition = 100
            let fadeInOut = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)])
            sorryTryAgain.run(fadeInOut) {
                self.sorryTryAgain.zPosition = -100
             }
 */
        }
        timedUnselectButton(sender: sender)
        
        /*
        if let button = sender {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                button.isUserInteractionEnabled = true
            }
        }
 */
    }
    /*
    override func nextPage(sender: Button?, index: Int) {
        if pageIndex < maxPages - 1 {
            enterMode(sender: nil, index: 5)
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
        timedUnselectButton(sender: sender)
    }
    
    override func prevPage(sender: Button?, index: Int) {
        
        //has the same sort of logic as nextPage func
        if pageIndex >= 1 {
            enterMode(sender: nil, index: 5)
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
        timedUnselectButton(sender: sender)
    }*/
    
    func returnToMainMenu() {
        
        // bye bye audiokit
        //ansSongPlayer?.stop()
        self.destruct()

        // calling the segue func
        guard let gameVC = self.viewController as! GameViewController? else {
            return
        }
        gameVC.unwindFromGameToLevelSelect(gameVC)
    }
}
