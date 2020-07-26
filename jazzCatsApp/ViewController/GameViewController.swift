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
    
    var levelGroup: String = ""
    var selectedLevel: Int = 0
    var maxlevel: Int = 0
    var freestyleMode = false
    var currentScene: SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIStyling.showLoading(view: self.view)
        
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
            return
        }
        
        setupLevel(levelGroup: levelGroup, levelNum: selectedLevel) { (scene) in
            scene.viewController = self
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            self.currentScene = scene
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            UIStyling.hideLoading(view: self.view)
        }
    }
    
    func showFreestyle() {
        guard let view = self.view as? SKView else {
            print("cant get view")
            return
        }
        let scene = Freestyle(size: LevelSetup.sceneSize)
        scene.viewController = self
    
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        self.currentScene = scene
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
        UIStyling.hideLoading(view: self.view)
    }
    
    func setupLevel(levelGroup: String, levelNum: Int, showScene: @escaping (LevelTemplate) -> ()) {
        let db = Firestore.firestore()
        let docPath = "/level-groups/\(levelGroup)/levels"
        let docRef = db.collection(docPath).document("level\(levelNum)")
        
        docRef.getDocument { (document, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            if let document = document, document.exists {
                let numberOfMeasures = document.get("number-of-measures") as? Int
                let bpm = document.get("bpm") as? Int
                let subdivision = document.get("subdivision") as? Int
                let maxPages = document.get("maxpages") as? Int
                let reward = document.get("reward") as? Dictionary<String, Any>
                let hasTutorial = document.get("tutorial") as? Bool
                let tutorialData = document.get("dialogue") as? Array<Dictionary<String, Any>>
                
                if let lvlAnsString = document.get("answer") as? String {
                    let level = LevelTemplate(size: LevelSetup.sceneSize, levelGroup: levelGroup, levelNum: levelNum, numberOfMeasures: numberOfMeasures, bpm: bpm, subdivision: subdivision, maxPages: maxPages, lvlAns: [], reward: reward)
                    let lvlAns = LevelSetup.parseLvlAns(json: lvlAnsString, maxPages: level.maxPages)
                    level.lvlAns = lvlAns
                    showScene(level)
                    if hasTutorial == true && tutorialData != nil {
                        self.showTutorialPopover(self, tutorialData: tutorialData!)
                    }
                }
            }
        }
    }
    
    func showPopover(_ sender: Any, popupID: String) {
        
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
            popoverVC.didMove(toParent: self)
        
        case Constants.confirmNavID:
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.confirmNavID) as! ConfirmNavPopupVC
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
            
        case Constants.levelCompleteID:
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.levelCompleteID) as! LevelCompletePopupVC
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
        performSegue(withIdentifier: "fromGameToWelcomeUSegue", sender: nil)
    }
    
    @IBAction func unwindFromGameToLevelSelect(_ sender: Any) {
        performSegue(withIdentifier: "fromGameToLevelSelectUSegue", sender: nil)
    }

    
}

