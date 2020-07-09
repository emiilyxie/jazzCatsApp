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

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGraphics()
    }
    
    @IBOutlet var signInOptions: [UIButton]!
    @IBOutlet weak var warningPopup: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    
    func setUpGraphics() {
        for button in signInOptions {
            UIStyling.setButtonStyle(button: button)
        }
        UIStyling.setPopupBackground(popupView: warningPopup)
        UIStyling.setButtonStyle(button: cancelButton)
        UIStyling.setButtonStyle(button: continueButton)
    }

    @IBAction func signInWithApple(_ sender: UIButton) {
        print("cant signin w apple yet")
    }
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        print("cant signin w google yet")
    }
    @IBAction func signInWithEmail(_ sender: UIButton) {
        performSegue(withIdentifier: "fromSignInToSignInEmailSegue", sender: self)
    }
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        performSegue(withIdentifier: "fromSignInToSignUpEmailSegue", sender: self)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
