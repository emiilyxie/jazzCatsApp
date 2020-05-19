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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            //let scene = LevelTemplate(size: CGSize(width: sceneWidth, height: sceneHeight))
            
            /* loading a level
            if let scene = LevelTemplate(fileNamed: "LevelTemplate.sks"){
                sceneWidth = CGFloat(scene.size.width)
                sceneHeight = CGFloat(scene.size.height)
                
                setUpLevel(level: scene, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 2, lvlAns: lvl3Ans)
            
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                    
                // Present the scene
                view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                //view.showsPhysics = true
            }
 */
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
        }
        
        
        /*
        let sound = Bundle.main.path(forResource: "kitten-meow", ofType: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch {
            print(error)
        }
         */
    }
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        audioPlayer.play()
    }
 */
}
