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
        
        // this code is kinda messy & repeats itself, dw i'll clean it later tho
        if field == "level-progress" {
            userRef.getDocument { (document, err) in
                if let document = document, document.exists {
                    
                    if let userData = document.data()![field] as? NSDictionary {
                        if userData[self.levelGroup!] != nil {
                            let userProgress = userData[self.levelGroup!] as! Int
                            let nextLevel = self.selectedLevel + 1
                            if userProgress < nextLevel {
                                print("updating level progress")
                                userRef.setData([
                                field : [self.levelGroup : self.selectedLevel + 1]], merge: true)
                            }
                            else {
                                print("you've already completed this level")
                            }
                        }
                        else {
                            print("initializing the key in the field")
                            userRef.setData([
                                field : [self.levelGroup : self.selectedLevel + 1]], merge: true)
                        }
                    }
                    else {
                        print("initializing the field")
                        userRef.setData([
                            field : [self.levelGroup : self.selectedLevel + 1]], merge: true)
                    }
                }
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

