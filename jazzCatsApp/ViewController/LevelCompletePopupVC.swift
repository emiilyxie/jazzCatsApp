//
//  LevelCompletePopupVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 7/8/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class LevelCompletePopupVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nextLevelButton: UIButton!
    @IBOutlet weak var earnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGraphics()
        displayRewards()
    }
    
    func setUpGraphics() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            UIStyling.setPopupBackground(popupView: self.bgView)
            UIStyling.setButtonStyle(button: self.nextLevelButton)
        }
    }
    
    func displayRewards() {
        guard let gameVC = self.parent as? GameViewController else {
            print("cant get parent")
            return
        }
        
        guard let level = gameVC.currentScene as? LevelTemplate else {
            print("cant get level")
            return
        }
        
        earnLabel.text = String(describing: level.reward)
    }
    
    @IBAction func nextLevelPressed(_ sender: UIButton) {
        guard let gameVC = self.parent as? GameViewController else {
            print("cant get parent")
            return
        }
        
        gameVC.selectedLevel += 1
        if gameVC.selectedLevel <= gameVC.maxlevel {
            gameVC.showLevel()
        }
        else {
            gameVC.unwindFromGameToLevelSelect(self)
        }
        gameVC.view.subviews.forEach({$0.removeFromSuperview()})
    }
    

}
