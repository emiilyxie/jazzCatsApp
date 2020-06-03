//
//  GameViewController.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/10/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import FirebaseAuth
import FirebaseFirestore

public var sceneWidth: CGFloat!
public var sceneHeight: CGFloat!

class GameViewController: UIViewController {
    
    var levelGroup: String!
    var selectedLevel: Int!
    var freestyleMode = false
    var currentScene: SKScene!
    var maxUnlockedLevel: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            if !freestyleMode {
                
                //loading a level
                if let scene = LevelTemplate(fileNamed: "LevelTemplate.sks") {
                    scene.viewController = self
                    scene.scaleMode = .aspectFill
                    sceneWidth = scene.size.width
                    sceneHeight = scene.size.height

                    LevelSetup.prepareLevel(level: scene, levelGroup: levelGroup, levelNum: selectedLevel) {
                        // Present the scene as completion func
                        view.presentScene(scene)
                        self.currentScene = scene
                        view.ignoresSiblingOrder = true
                        view.showsFPS = true
                        view.showsNodeCount = true
                        //view.showsPhysics = true
                    }
                }
             }
            else {
                if let scene = Freestyle(fileNamed: "LevelTemplate.sks") {
                    scene.viewController = self
                    LevelSetup.prepareFreestyle(freestyleLevel: scene)

                    scene.scaleMode = .aspectFill
                    sceneWidth = scene.size.width
                    sceneHeight = scene.size.height
                    
                    // Present the scene
                    view.presentScene(scene)
                    currentScene = scene
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    //view.showsPhysics = true
                }
            }
        }
    }
    
    func updateUserValue(field: String, count: Int) {
        let currentUserID = Auth.auth().currentUser!.uid
        let userRef = Firestore.firestore().collection("/users").document(currentUserID)
        
        if field == "level-progress" {
            if maxUnlockedLevel > selectedLevel+1 {
                print("wont change val bc youve already completed this")
            }
            else {
                print("updating progress")
                userRef.setData([
                    field : [self.levelGroup : self.selectedLevel + 1]], merge: true)
                maxUnlockedLevel += 1
            }
        }
        else {
            print("updating hints or currency")
            userRef.setData([
                field : FieldValue.increment(Int64(count))])
        }
    }
    
    @IBAction func showSettingsPopover(_ sender: Any) {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "settingsPopoverID") as! SettingsPopupVC
        self.addChild(popoverVC)
        popoverVC.view.frame = self.view.frame
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParent: self)
    }
    
    // unwind segues
    @IBAction func unwindFromGameToWelcome(_ sender: Any) {
        performSegue(withIdentifier: "fromGameToWelcomeUSegue", sender: nil)
    }
    
    @IBAction func unwindFromGameToLevelSelect(_ sender: Any) {
        performSegue(withIdentifier: "fromGameToLevelSelectUSegue", sender: nil)
    }

    
}

