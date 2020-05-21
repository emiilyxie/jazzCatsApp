//
//  GameViewController.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/10/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
//import AVFoundation

public var sceneWidth: CGFloat!
public var sceneHeight: CGFloat!

class GameViewController: UIViewController {
    
    var selectedLevel: Int!
    var freestyleMode = false
    var totalLevels = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if !freestyleMode {
                //loading a level
                if let scene = LevelTemplate(fileNamed: "LevelTemplate.sks") {
                    scene.viewController = self
                    prepareLevel(level: scene, levelNum: selectedLevel)

                    scene.scaleMode = .resizeFill
                    // Present the scene
                    view.presentScene(scene)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    //view.showsPhysics = true
                }
             }
            else {
                if let scene = Freestyle(fileNamed: "LevelTemplate.sks") {
                    scene.viewController = self
                    prepareFreestyle(freestyleLevel: scene)

                    scene.scaleMode = .resizeFill
                    // Present the scene
                    view.presentScene(scene)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    //view.showsPhysics = true
                }
            }
        }
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnToLevelSelect(_ sender: Any) {
        performSegue(withIdentifier: "gameToLevelSelectSegue", sender: self)
    }
    
    @IBAction func returnToWelcomeScreen(_ sender: Any) {
        performSegue(withIdentifier: "gameToWelcomeScreenSegue", sender: self)
    }

}

