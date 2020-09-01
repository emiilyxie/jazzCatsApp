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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var nextLevelButton: UIButton!
    @IBOutlet weak var lvlCompleteLabel: UILabel!
    @IBOutlet weak var earnLabel: UILabel!
    var rewardMessage: String?
    weak var gameVC: GameViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        
        parentVC.currentScene?.isUserInteractionEnabled = false
        parentVC.currentScene?.isPaused = true
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGraphics()
        displayRewards()
    }
    
    func setUpGraphics() {
        self.view.backgroundColor = .clear
        lvlCompleteLabel.font = UIFont(name: "Gaegu-Bold", size: 20)
        UIStyling.setPopupBackground(popupView: self.bgView)
        UIStyling.setButtonStyle(button: self.menuButton)
        UIStyling.setButtonStyle(button: self.nextLevelButton)
    }
    
    func displayRewards() {
        earnLabel.text = rewardMessage
    }
    
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        guard let _ = gameVC,
            let levelScene = gameVC!.currentScene as? LevelTemplate else {
            print("cant get parent")
            return
        }
        //gameVC.view.subviews.forEach({$0.removeFromSuperview()})
        self.view.removeFromSuperview()
        levelScene.returnToMainMenu()
        
    }
    
    @IBAction func nextLevelPressed(_ sender: UIButton) {
        guard let _ = gameVC,
            let levelScene = gameVC!.currentScene as? LevelTemplate else {
            print("cant get parent")
            return
        }
        
        gameVC!.selectedLevel += 1
        if gameVC!.selectedLevel <= gameVC!.maxlevel {
            UIStyling.showLoading(view: gameVC!.view)
            self.view.removeFromSuperview()
            levelScene.destruct()
            gameVC!.showLevel()
        }
        else {
            self.view.removeFromSuperview()
            levelScene.returnToMainMenu()
        }
        //gameVC.view.subviews.forEach({$0.removeFromSuperview()})
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeFromParent()
        self.dismiss(animated: animated, completion: nil)
    }
}
