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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSignedInResponse()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var userIDLabel: UILabel!
    
    func isSignedInResponse() {
        
        let signInHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // if user is signed in, then cool
                // set data for the user struct
                self.setUpUser()
            }
            else {
                self.goToSignIn(self)
            }
        }
        
        Auth.auth().removeStateDidChangeListener(signInHandler)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError{
            print(signOutError)
        }
        goToSignIn(self)
    }
    
    func setUpUser() {
        guard let uid = Auth.auth().currentUser?.uid
        else {
            print("no current user uh oh")
            return
        }
        let userRef = Firestore.firestore().collection("/users").document(uid)
        userRef.getDocument { (document, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            if let document = document, document.exists {
                GameUser.uid = document.get("uid") as? String ?? nil
                GameUser.email = document.get("email") as? String ?? nil
                GameUser.nickname = document.get("nickname") as? String ?? nil
                GameUser.levelProgress = document.get("level-progress") as? Dictionary ?? [:]
                GameUser.gameCurrency = document.get("game-currency") as? Int ?? 100
                GameUser.hints = document.get("hints") as? Int ?? 10
                self.userIDLabel.text = "hi \(GameUser.nickname ?? "")!"
            }
            else {
                print("user doc doesn't exist")
            }
        }
    }
    
    // segue code
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if goingToFreestyle == true {
            if let gameVC = segue.destination as? GameViewController {
                gameVC.freestyleMode = true
            }
        }
    }
    
    func goToSignIn(_ sender: Any) {
        performSegue(withIdentifier: "fromWelcomeToSignInSegue", sender: self)
    }
    
    @IBAction func goToLevelGroups(_ sender: Any) {
        performSegue(withIdentifier: "fromWelcomeToLevelGroupsSegue", sender: self)
    }
    
    
    @IBAction func goToLevelSelect(_ sender: Any) {
        goingToFreestyle = false
        performSegue(withIdentifier: "fromWelcomeToLevelSelectSegue", sender: self)
    }
    
    @IBAction func goToFreestyle(_ sender: Any) {
        goingToFreestyle = true
        performSegue(withIdentifier: "fromWelcomeToFreestyleSegue", sender: self)
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
    @IBAction func backToWelcomeFromLevelGroups(segue: UIStoryboardSegue) {
        
    }
    
    // for when you dont wanna sign in yet
    /*
    func anonSignIn() {
        let handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            Auth.auth().signInAnonymously { (authResult, error) in
                guard let user = authResult?.user else { return }
                // isAnonymous = user.isAnonymous
                let uid = user.uid
                print("user id: \(uid)")
            }
        })
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        userIDLabel.text = uid
        
        let usersRef = Firestore.firestore().collection("users")
        usersRef.document(uid!).setData(["uid": uid!], merge: true)
        Auth.auth().removeStateDidChangeListener(handle)
    }
 */

}
