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
    
    override func viewWillAppear(_ animated: Bool) {
        isSignedInResponse()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var userIDLabel: UILabel!
    
    func isSignedInResponse() {
        
        let signInHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if user is signed in, then cool
                self.userIDLabel.text = user.uid
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
    @IBAction func backToWelcomeFromCreateAcc(segue: UIStoryboardSegue) {}
    @IBAction func backToWelcomeFromSignIn(segue: UIStoryboardSegue) {}
    
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

}
