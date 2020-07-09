//
//  ConfirmNavPopupVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 7/3/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class ConfirmNavPopupVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGraphics()
    }
    
    func setUpGraphics() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            UIStyling.setPopupBackground(popupView: self.bgView)
            UIStyling.setButtonStyle(button: self.cancelButton)
            UIStyling.setButtonStyle(button: self.submitButton)
            self.cancelButton.layer.cornerRadius = 10
            self.submitButton.layer.cornerRadius = 10
        }
    }
    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        guard let gameVC = self.parent as? GameViewController else {
            print("cant get parent")
            return
        }
        if let freestyle = gameVC.currentScene as? Freestyle {
            self.view.removeFromSuperview()
            freestyle.returnToWelcomeScreen(index: 0)
            return
        }
        if let level = gameVC.currentScene as? LevelTemplate {
            self.view.removeFromSuperview()
            level.returnToMainMenu(index: 0)
            return
        }
        print("couldnt get scene")
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
