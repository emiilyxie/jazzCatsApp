//
//  WelcomeScene.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit

class WelcomeScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.red
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else {
            return
        }
        
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
    }
    
    func addNewLevel() {
        
    }
    
}
