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
    var offlineMode = false
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var freestyleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //clearAllFiles()
        saveInitialSounds()
        UIStyling.showLoading(viewController: self)
        isSignedInResponse()
        setUpGraphics()
    }
    
    func isSignedInResponse() {
        
        if !offlineMode {
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
        else {
            UIStyling.showAlert(viewController: self, text: "You are not connected to the internet. You will play in offline guest mode. Connect to the internet and restart to play online.", duration: 7)
            GameUser.unlockedSoundNames = GameUser.defaultUnlockedSoundNames
            GameUser.setSounds {
                UIStyling.hideLoading(view: self.view)
            }
        }
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
        if !offlineMode {
        
            guard let uid = Auth.auth().currentUser?.uid
            else {
                goToSignIn(self)
                return
            }
            //UserDefaults.standard.set("nothing", forKey: "uid")
            if let defaultsUID = UserDefaults.standard.string(forKey: "uid") {
                if uid == defaultsUID {
                    GameUser.getUserDefaults()
                    GameUser.setSounds() {
                        UIStyling.hideLoading(view: self.view)
                    }
                    return
                }
            }
            
            setUpUserFIR()
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
    
    func setUpUserFIR() {
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
                GameUser.updateUserDefaults()
                GameUser.setSounds() {
                    UIStyling.hideLoading(view: self.view)
                }
            }
            else {
                self.goToSignIn(self)
            }
        }
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
        if !offlineMode {
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.accountDetailsID) as! AccountDetailsPopupVC
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
        }
        else {
            UIStyling.showAlert(viewController: self, text: "You can't view this in offline mode.")
        }
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
        if !offlineMode {
            performSegue(withIdentifier: Constants.welcomeToLevelGroups, sender: self)
        }
        else {
            UIStyling.showAlert(viewController: self, text: "You can't view this in offline mode.")
        }
    }
    
    @IBAction func goToFreestyle(_ sender: Any) {
        goingToFreestyle = true
        UIStyling.showLoading(viewController: self)
        performSegue(withIdentifier: Constants.welcomeToFreestyle, sender: self)
    }
    
    // unwind segue destinations
    @IBAction func backToWelcomeFromLevelSelect(segue: UIStoryboardSegue) {}
    @IBAction func backToWelcomeFromGame(segue: UIStoryboardSegue) {}
    @IBAction func backToWelcomeFromCreateAcc(segue: UIStoryboardSegue) {
        isSignedInResponse()
        UIStyling.showLoading(viewController: self)
    }
    @IBAction func backToWelcomeFromSignIn(segue: UIStoryboardSegue) {
        isSignedInResponse()
        UIStyling.showLoading(viewController: self)
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
    
    func saveInitialSounds() {
        let initialSounds = GameUser.defaultUnlockedSoundNames
        
        for soundID in initialSounds {
            
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("cant get doc dir")
                return
            }
            let dirURL = docDirURL.appendingPathComponent("sounds/\(soundID)")
            let fileURL = dirURL.appendingPathComponent("\(soundID).json")
            let audioURL = dirURL.appendingPathComponent("\(soundID).mp3")
            let imgURL = dirURL.appendingPathComponent("\(soundID).png")
            
            if !FileManager.default.fileExists(atPath: fileURL.path) || !FileManager.default.fileExists(atPath: audioURL.path) || !FileManager.default.fileExists(atPath: imgURL.path) {
                
                
                guard let jsonFile = Bundle.main.url(forResource: soundID, withExtension: "json"),
                    let audioFile = Bundle.main.url(forResource: soundID, withExtension: "mp3"),
                    let imgFile = Bundle.main.url(forResource: soundID, withExtension: "png") else {
                        print("cant get files")
                        return
                }
                
                do {
                    try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
                    let jsonData = try Data(contentsOf: jsonFile)
                    let audioData = try Data(contentsOf: audioFile)
                    let imgData = try Data(contentsOf: imgFile)
                    
                    try jsonData.write(to: fileURL)
                    try audioData.write(to: audioURL)
                    try imgData.write(to: imgURL)
                } catch {
                    print(error)
                }
                
            }
        }
    }
    
    func clearAllFiles() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try fileManager.removeItem(at: myDocuments)
        } catch {
            return
        }
    }
}
