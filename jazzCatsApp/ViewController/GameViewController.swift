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
    
    //var audioPlayer = AVAudioPlayer()
    var selectedLevel: Int!
    //var skScene: SKScene!
    var currentScene: SKScene!
    var allScenes = [SKScene?](repeating: nil, count: 3)
    var totalLevels = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
             //let scene = LevelTemplate(size: CGSize(width: sceneWidth, height: sceneHeight))
                
             //loading a level
             if let scene = LevelTemplate(fileNamed: "LevelTemplate.sks") {
                 currentScene = scene
                 scene.viewController = self
                 prepareLevel(level: scene, levelNum: selectedLevel)
                 
                 scene.scaleMode = .resizeFill
                 // Present the scene
                 view.presentScene(scene)
                 view.ignoresSiblingOrder = true
                 view.showsFPS = true
                 view.showsNodeCount = true
                 //view.showsPhysics = true
                 
                 //allScenes[whichLevel-1] = currentScene
                 
             }

                
                /*
                // loading welcome scene
                let scene = WelcomeScene(size: CGSize(width: 100, height: 100))
                
                //setUpLevel(level: scene, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 2, lvlAns: lvl3Ans)
            
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                    
                // Present the scene
                view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                //view.showsPhysics = true
         */
            
        }

        /*
        if allScenes[selectedLevel-1] == nil {
            loadNewLevel(whichLevel: selectedLevel)
        }
        else {
            loadActiveLevel(whichLevel: selectedLevel)
        }
 */

    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackToMainMenu(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMainMenu", sender: self)
    }
   
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let view = self.view as! SKView? else {
            return
        }
        
        if segue.identifier == "levelSelectMenu" {
            currentScene.removeAllActions()
            currentScene.removeAllChildren()
            currentScene.removeFromParent()
            currentScene = nil
            
            view.presentScene(nil)
            
            //view.removeFromSuperview()
        }
        
        //currentScene.isHidden = true
        //currentScene.isPaused = true
    }
 */
    
    func loadActiveLevel(whichLevel: Int) {
        
        if let view = self.view as! SKView? {
            currentScene = allScenes[whichLevel-1]
            currentScene.isHidden = false
            currentScene.isPaused = false
            
            view.presentScene(currentScene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func loadNewLevel(whichLevel: Int) {
        if let view = self.view as! SKView? {
            //let scene = LevelTemplate(size: CGSize(width: sceneWidth, height: sceneHeight))
               
            //loading a level
            if let scene = LevelTemplate(fileNamed: "LevelTemplate.sks") {
                currentScene = scene
                scene.viewController = self
                prepareLevel(level: scene, levelNum: selectedLevel)
                
                scene.scaleMode = .resizeFill
                // Present the scene
                view.presentScene(scene)
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
                //view.showsPhysics = true
                
                allScenes[whichLevel-1] = currentScene
                
            }
       }
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        audioPlayer.play()
    }
 */
    
}

