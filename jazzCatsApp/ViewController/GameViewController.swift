//
//  GameViewController.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/10/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import FirebaseFirestore

class GameViewController: UIViewController {
    
    weak var sourceVC: UIViewController?
    var levelGroup: String = ""
    var selectedLevel: Int = 0
    var maxlevel: Int = 0
    var freestyleMode = false
    var currentScene: SKScene?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIStyling.showLoading(viewController: self)
        
        if let source = sourceVC {
            UIStyling.hideLoading(view: source.view)
        }
        
        if !freestyleMode {
            showLevel()
         }
        
        else {
            showFreestyle()
        }
    }
    
    func showLevel() {
        guard let view = self.view as? SKView else {
            print("cant get view")
            UIStyling.showAlert(viewController: self, text: "Error: please restart the app and try again.")
            return
        }
        
        self.children.forEach({ $0.view.removeFromSuperview() })
        self.children.forEach({ $0.removeFromParent() })
        
        setupLevel(levelGroup: levelGroup, levelNum: selectedLevel) { (scene) in
            scene.viewController = self
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            self.currentScene = scene
            view.ignoresSiblingOrder = true
            //view.showsFPS = true
            //view.showsNodeCount = true
            
            //UIStyling.hideLoading(view: self.view)
        }
    }
    
    func showFreestyle() {
        guard let view = self.view as? SKView else {
            UIStyling.showAlert(viewController: self, text: "Error: please restart the app and try again.")
            return
        }
        
        self.children.forEach({ $0.view.removeFromSuperview() })
        self.children.forEach({ $0.removeFromParent() })
        
        let scene = Freestyle(size: LevelSetup.sceneSize)
        scene.viewController = self
    
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        self.currentScene = scene
        view.ignoresSiblingOrder = true
        //view.showsFPS = true
        //view.showsNodeCount = true
        //view.showsPhysics = true
        //UIStyling.hideLoading(view: self.view)
    }
    
    func setupLevel(levelGroup: String, levelNum: Int, showScene: @escaping (LevelTemplate) -> ()) {
        let db = Firestore.firestore()
        let docPath = "/level-groups/\(levelGroup)/levels"
        let docRef = db.collection(docPath).document("level\(levelNum)")
        
        docRef.getDocument { (document, err) in
            if let err = err {
                UIStyling.hideLoading(view: self.view)
                UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription). Check your network and try again.", duration: 7)
                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                    self.unwindFromGameToLevelSelect(self)
                    return
                }
            }
            if let document = document, document.exists {
                let tempo = document.get("tempo") as? Int
                let numberOfMeasures = document.get("number-of-measures") as? Int
                let bpm = document.get("bpm") as? Int
                let subdivision = document.get("subdivision") as? Int
                let maxPages = document.get("maxpages") as? Int
                let from = document.get("from") as? String
                let reward = document.get("reward") as? Dictionary<String, Any>
                let hasTutorial = document.get("tutorial") as? Bool
                let tutorialData = document.get("dialogue") as? Array<Dictionary<String, Any>>
                let hiddenButtons = document.get("hidden-buttons") as? Array<String>
                let firstNote = document.get("display-first-note") as? Array<Double>
                
                if let lvlAnsString = document.get("answer") as? String {
                    let level = LevelTemplate(size: LevelSetup.sceneSize, levelGroup: levelGroup, levelNum: levelNum, from: from, tempo: tempo, numberOfMeasures: numberOfMeasures, bpm: bpm, subdivision: subdivision, maxPages: maxPages, lvlAns: [], reward: reward)
                    let lvlAns = LevelSetup.parseLvlAns(json: lvlAnsString, maxPages: level.maxPages)
                    level.lvlAns = lvlAns
                    showScene(level)
                    
                    if let _ = hiddenButtons {
                        level.hideButtons(buttons: hiddenButtons!)
                    }
                    
                    if hasTutorial == true && tutorialData != nil {
                        self.showTutorialPopover(self, tutorialData: tutorialData!)
                    }
                    
                    if firstNote != nil {
                        let firstNoteData = firstNote!.map{CGFloat($0)}
                        level.addNote(with: firstNoteData, on: 0, soundID: level.selectedNote)
                        //UIStyling.showAlert(viewController: self, text: "First note is on beat \(firstNote![1]).")
                    }
                }
            }
        }
    }
    
    func showPopover(_ sender: Any, popupID: String, disabledSettings: [String]? = nil, rewardMessage: String? = nil) {
        
        switch popupID {
            
        case Constants.noteSelectID:
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.noteSelectID) as! NoteSelectPopupVC
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
            
        case Constants.settingsID:
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.settingsID) as! SettingsPopupVC
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            popoverVC.processDisabled(disabled: disabledSettings)
            popoverVC.didMove(toParent: self)
        
        case Constants.confirmNavID:
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.confirmNavID) as! ConfirmNavPopupVC
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
            
        case Constants.levelCompleteID:
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.levelCompleteID) as! LevelCompletePopupVC
            popoverVC.gameVC = self
            popoverVC.rewardMessage = rewardMessage
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
            
        case Constants.shareCompID:
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.shareCompID) as! ShareCompVC
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
            
        default:
            print("dont recognize popover")
            return
        }
        
    }
    
    @IBAction func showTutorialPopover(_ sender: Any, tutorialData: Array<Dictionary<String, Any>>) {
        let tutorialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tutorialPopoverID") as! TutorialPopupVC
        self.addChild(tutorialVC)
        tutorialVC.view.frame = self.view.frame
        tutorialVC.tutorialData = tutorialData
        tutorialVC.startTutorial()
        self.view.addSubview(tutorialVC.view)
        tutorialVC.didMove(toParent: self)
    }
    
    // unwind segues
    @IBAction func unwindFromGameToWelcome(_ sender: Any) {
        performSegue(withIdentifier: "fromGameToWelcomeUSegue", sender: self)
    }
    
    @IBAction func unwindFromGameToLevelSelect(_ sender: Any) {
        performSegue(withIdentifier: "fromGameToLevelSelectUSegue", sender: self)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.children.forEach { $0.dismiss(animated: animated, completion: nil) }
        super.viewDidDisappear(animated)
    }
}

