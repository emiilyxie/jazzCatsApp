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

public var sceneWidth: CGFloat!
public var sceneHeight: CGFloat!

class GameViewController: UIViewController {
    
    var selectedLevel: Int!
    var freestyleMode = false
    var totalLevels = 3
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

                    LevelSetup.prepareLevel(level: scene, levelNum: selectedLevel) {
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

