//
//  AccountDetailsPopupVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 7/4/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseAuth
import SafariServices

class AccountDetailsPopupVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGraphics()
        setUpLabels()
    }
    
    func setUpGraphics() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            UIStyling.setPopupBackground(popupView: self.bgView)
            self.scrollContentView.backgroundColor = ColorPalette.friendlyGold
            
            for button in self.buttons {
                UIStyling.setButtonStyle(button: button)
            }
            self.backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.backButton.layer.cornerRadius = 5
        }
    }
    
    func setUpLabels() {
        nicknameLabel.text = GameUser.nickname
        emailLabel.text = GameUser.email
        userIDLabel.text = GameUser.uid
    }

    @IBAction func guideButtonPressed(_ sender: Any) {
        //show tutorial
        if let url = URL(string: "http://emily.xie.fm/activities/jazzcats.html") {
            //let config = SFSafariViewController.Configuration()
            //config.entersReaderIfAvailable = true

            UIApplication.shared.open(url)
            //let vc = SFSafariViewController(url: url)
            //vc.delegate = self
            //present(vc, animated: true)
        }
        else {
            UIStyling.showAlert(viewController: self, text: "Coming Soon!")
        }
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        UIStyling.showAlert(viewController: self, text: "Coming Soon!")
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        UIStyling.showAlert(viewController: self, text: "Coming Soon!")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        guard let welcomeScreen = self.parent as? WelcomeScreen else {
            print("cant get welcomescreen vc")
            return
        }
        self.view.removeFromSuperview()
        welcomeScreen.signOut(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != bgView {
            self.view.removeFromSuperview()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeFromParent()
        self.dismiss(animated: animated, completion: nil)
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

extension AccountDetailsPopupVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            self.backButtonPressed(UIButton())
        }
    }
}
