//
//  WelcomeScreen.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/20/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class WelcomeScreen: UIViewController {
    
    var goingToFreestyle = false
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var freestyleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIStyling.showLoading(view: self.view)
        isSignedInResponse()
        setUpGraphics()
    }
    
    func isSignedInResponse() {
        let signInHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // if user is signed in, then cool
                // set data for the user struct
                self.setUpUser()
            }
            else {
                self.goToSignIn(self)
                UIStyling.hideLoading(view: self.view)
            }
        }
        
        Auth.auth().removeStateDidChangeListener(signInHandler)
    }
    
    func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError{
            UIStyling.showAlert(viewController: self, text: "Error: \(signOutError). Check your network and try again.", duration: 7)
        }
        goToSignIn(self)
    }
    
    func setUpUser() {
        guard let uid = Auth.auth().currentUser?.uid
        else {
            goToSignIn(self)
            return
        }
        let userRef = Firestore.firestore().collection("/users").document(uid)
        userRef.getDocument { (document, err) in
            if let err = err {
                UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription). Check your network and try again.", duration: 7)
                return
            }
            if let document = document, document.exists {
                GameUser.uid = document.get("uid") as? String ?? nil
                GameUser.email = document.get("email") as? String ?? nil
                GameUser.nickname = document.get("nickname") as? String ?? nil
                GameUser.levelProgress = document.get("level-progress") as? Dictionary ?? [:]
                GameUser.gameCurrency = document.get("game-currency") as? Int ?? 100
                GameUser.hints = document.get("hints") as? Int ?? 10
                GameUser.unlockedSoundNames = document.get("unlocked-sounds") as? [String] ?? ["cat_basic1", "drumsnare1", "vibes1"]
                GameUser.setSounds()
                //GameUser.sortSounds()
            }
            else {
                self.goToSignIn(self)
            }
            UIStyling.hideLoading(view: self.view)
        }
    }
    
    func setUpGraphics() {
        UIStyling.setViewBg(view: self.view, bgImage: "cafe1")
        
        gameNameLabel.backgroundColor = UIColor.white.withAlphaComponent(CGFloat(0.8))
        gameNameLabel.textColor = .black
        //gameNameLabel.font = UIFont(name: "Gaegu-Bold", size: CGFloat(70))
        
        UIStyling.setButtonStyle(button: accountButton)
        accountButton.layer.cornerRadius = 22
        
        UIStyling.setButtonStyle(button: playButton)
        playButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        playButton.layer.cornerRadius = 24
        
        UIStyling.setButtonStyle(button: freestyleButton)
        freestyleButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        freestyleButton.layer.cornerRadius = 24
    }
    
    // segue code
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //exportData()
        if let gameVC = segue.destination as? GameViewController {
            gameVC.sourceVC = self
        }
        if goingToFreestyle == true {
            print("pressed freestyle segue")
            if let gameVC = segue.destination as? GameViewController {
                gameVC.freestyleMode = true
            }
        }
    }
    
    @IBAction func accountButtonPressed(_ sender: UIButton) {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.accountDetailsID) as! AccountDetailsPopupVC
        self.addChild(popoverVC)
        popoverVC.view.frame = self.view.frame
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParent: self)
    }
    
    
    func goToSignIn(_ sender: Any) {
        GameUser.conductor?.stopAudioKit()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError{
            UIStyling.showAlert(viewController: self, text: "Error: \(signOutError). Check your network and try again.", duration: 7)
            print("no ones even signed in")
        }
        performSegue(withIdentifier: Constants.welcomeToSignIn, sender: self)
    }
    
    @IBAction func goToLevelGroups(_ sender: Any) {
        performSegue(withIdentifier: Constants.welcomeToLevelGroups, sender: self)
    }
    
    @IBAction func goToFreestyle(_ sender: Any) {
        goingToFreestyle = true
        UIStyling.showLoading(view: self.view)
        performSegue(withIdentifier: Constants.welcomeToFreestyle, sender: self)
    }
    
    // unwind segue destinations
    @IBAction func backToWelcomeFromLevelSelect(segue: UIStoryboardSegue) {}
    @IBAction func backToWelcomeFromGame(segue: UIStoryboardSegue) {}
    @IBAction func backToWelcomeFromCreateAcc(segue: UIStoryboardSegue) {
        isSignedInResponse()
    }
    @IBAction func backToWelcomeFromSignIn(segue: UIStoryboardSegue) {
        isSignedInResponse()
    }
    @IBAction func backToWelcomeFromLevelGroups(segue: UIStoryboardSegue) {}
    
    // for exporting documents
    
/*
    func exportData() {
        let db = Firestore.firestore()
        let docData = //data here

        db.document("/level-groups/basics/levels/level20").setData(docData, merge: true) { (err) in
            if err != nil {
                print(err!.localizedDescription)
            }
        }
    }
 */
     
}
