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
                self.goToCreateAcc(self)
            }
        }
        Auth.auth().removeStateDidChangeListener(signInHandler)
    }
    
    func goToCreateAcc(_ sender: Any ) {
        performSegue(withIdentifier: "fromWelcomeToCreateAccSegue", sender: self)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError{
            print(signOutError)
        }
        goToCreateAcc(self)
    }
    
    @IBAction func goToLevelSelect(_ sender: Any) {
        goingToFreestyle = false
        performSegue(withIdentifier: "fromWelcomeToLevelSelectSegue", sender: self)
    }
    
    @IBAction func goToFreestyle(_ sender: Any) {
        goingToFreestyle = true
        performSegue(withIdentifier: "fromWelcomeToFreestyleSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if goingToFreestyle == true {
            if let gameVC = segue.destination as? GameViewController {
                gameVC.freestyleMode = true
            }
        }
    }
    
    @IBAction func backToWelcomeFromGame(segue: UIStoryboardSegue) {}
    @IBAction func backToWelcomeFromCreateAcc(segue: UIStoryboardSegue) {}
    
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
        //print(user?.uid)
        userIDLabel.text = uid
        
        let usersRef = Firestore.firestore().collection("users")
        //let uidDoc = usersRef.document(uid!)
        /*
        uidDoc.getDocument { (document, err) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("document data: \(dataDescription)")
            }
            else {
                print("document currently doesn't exist")
                uidDoc.collection("users").document(uid!).setData(["uid" : uid!]) {
                    err in
                    if let err = err {
                        print("error writing doc: \(err)")
                    }
                    else {
                        print("wrote new doc!!")
                    }
                }
            }
        }
 */
        usersRef.document(uid!).setData(["uid": uid!], merge: true)
        
        Auth.auth().removeStateDidChangeListener(handle)
    }

}
