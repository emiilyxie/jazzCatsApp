//
//  SignInVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 7/1/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInVC: UIViewController {

    @IBOutlet var signInOptions: [UIButton]!
    @IBOutlet weak var warningPopup: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGraphics()
    }
    
    func setUpGraphics() {
        self.view.backgroundColor = ColorPalette.goldWood
        
        for button in signInOptions {
            UIStyling.setButtonStyle(button: button)
        }
        
        UIStyling.setPopupBackground(popupView: warningPopup)
        UIStyling.setButtonStyle(button: cancelButton)
        UIStyling.setButtonStyle(button: continueButton)
    }

    @IBAction func signInWithApple(_ sender: UIButton) {
        print("cant signin w apple yet")
        UIStyling.showAlert(viewController: self, text: "Sign In with Apple Coming Soon!")
    }
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        print("cant signin w google yet")
        UIStyling.showAlert(viewController: self, text: "Sign In with Google Coming Soon!")
    }
    @IBAction func signInWithEmail(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.signInToSignInEmail, sender: self)
    }
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.signInToCreateAcc, sender: self)
    }
    @IBAction func playAsGuest(_ sender: UIButton) {
        // for when you dont wanna sign in yet
        warningPopup.isHidden = false
    }
    
    @IBAction func cancelWarning(_ sender: UIButton) {
        warningPopup.isHidden = true
    }
    
    @IBAction func continueWarning(_ sender: UIButton) {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user else { return }
            // isAnonymous = user.isAnonymous
            let uid = user.uid
            print("user id: \(uid)")
            let usersRef = Firestore.firestore().collection("users")
            usersRef.document(uid).setData(["email" : "anonymous", "nickname" : "anonymous", "uid" : uid, "level-progress" : [:], "game-currency" : 100, "hints" : 10], merge: true)
            self.performSegue(withIdentifier: "fromSignInToWelcomeUSegue", sender: self)
        }
    }
    
    @IBAction func backToSignInFromSignInEmail(sender: UIStoryboardSegue) {}
    
    @IBAction func backToSignInFromCreateAcc(sender: UIStoryboardSegue) {}
    
}
