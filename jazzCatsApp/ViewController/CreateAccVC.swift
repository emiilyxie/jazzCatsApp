//
//  CreateAccVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/27/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccVC: UIViewController {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tempTextField: UITextField!
    @IBOutlet weak var jamButton: UIButton!
    
    var currentlyEditing: UITextField?
    var mergingAnon = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGraphics()
        setUpKeyboard()
    }
    
    func setUpGraphics() {
        self.view.backgroundColor = ColorPalette.brightManuscript
        UIStyling.setHeader(header: header)
        if mergingAnon {
            header.text = "Link your game progress with an account"
        }
        
        UIStyling.setButtonStyle(button: backButton)
        backButton.layer.cornerRadius = 5
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        UIStyling.setButtonStyle(button: jamButton)
        jamButton.backgroundColor = ColorPalette.friendlyGold
        jamButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        jamButton.layer.cornerRadius = 24
        
        UIStyling.setTextField(textField: nameTextField, placeholder: "Nickname")
        UIStyling.setTextField(textField: emailTextField, placeholder: "Email")
        UIStyling.setTextField(textField: passwordTextField, placeholder: "Password")
        UIStyling.setTextField(textField: tempTextField, placeholder: "Temp")
        tempTextField.isHidden = true
    }
    
    func setUpKeyboard() {
        dismissKeyboard()
        tempTextField.returnKeyType = .continue
    }
    
    @IBAction func namePressed(_ sender: Any) {
        tempTextField.isHidden = false
        nameTextField.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        
        //tempPressed(self)
        tempTextField.keyboardType = .default
        DispatchQueue.main.async {
            self.tempTextField.becomeFirstResponder()
        }
        tempTextField.placeholder = nameTextField.placeholder
        tempTextField.text = nameTextField.text
        currentlyEditing = nameTextField
    }
    
    @IBAction func emailPressed(_ sender: Any) {
        tempTextField.isHidden = false
        nameTextField.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        
        //tempPressed(self)
        tempTextField.keyboardType = .emailAddress
        DispatchQueue.main.async {
            self.tempTextField.becomeFirstResponder()
        }
        tempTextField.placeholder = emailTextField.placeholder
        tempTextField.text = emailTextField.text
        currentlyEditing = emailTextField
    }
    
    @IBAction func passwordPressed(_ sender: Any) {
        tempTextField.isHidden = false
        nameTextField.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        
        //tempPressed(self)
        tempTextField.keyboardType = .default
        DispatchQueue.main.async {
            self.tempTextField.becomeFirstResponder()
        }
        tempTextField.placeholder = passwordTextField.placeholder
        tempTextField.text = passwordTextField.text
        currentlyEditing = passwordTextField
    }
    
    @IBAction func tempDone(_ sender: Any) {
        tempTextField.isHidden = true
        nameTextField.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false

        currentlyEditing?.text = tempTextField.text
    }
    
    @IBAction func createAccButton(_ sender: Any) {
        // 1. validate fields
        let error = validateFields()
        if error != nil {
            // then show the error message
            UIStyling.showAlert(viewController: self, text: error!)
        }
        else {
            // continue with login
            UIStyling.showLoading(view: self.view)
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            if self.mergingAnon {
                self.mergeAnon()
            }
            
            else {
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, err) in
                    
                    if let err = err {
                        let errCode = AuthErrorCode(rawValue: err._code)
                        switch errCode {
                        case .networkError:
                            UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription). Check your network and try again", duration: 7)
                        default:
                            UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription).")
                        }
                        UIStyling.hideLoading(view: self.view)
                        return
                    }
                    else {
                        
                        // sign in the user
                        Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
                            if err != nil {
                                UIStyling.hideLoading(view: self.view)
                                UIStyling.showAlert(viewController: self, text: "Error: \(err!.localizedDescription). Check your network try again.", duration: 7)
                                return
                            }
                        }
                        
                        // create database entry
                        self.newDbEntry(email: email, password: password)
                        
                        // go to welcome screen
                        self.unwindFromCreateAccToWelcome(self)
                    }
                }
            }
        }
        
    }
    
    func mergeAnon() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let user = Auth.auth().currentUser {
                user.link(with: credential) { (authResult, error) in
                    
                    if let err = error {
                        print(err.localizedDescription)
                        let errCode = AuthErrorCode(rawValue: err._code)
                        switch errCode {
                        case .networkError:
                            UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription). Check your network and try again", duration: 7)
                        default:
                            UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription).")
                        }
                        UIStyling.hideLoading(view: self.view)
                        return
                    }
                    
                    let _ = GameUser.updateField(field: "email", text: email)
                    let _ = GameUser.updateField(field: "nickname", text: self.nameTextField.text ?? "")
                    
                    Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
                        if let err = error {
                            print(err.localizedDescription)
                            let errCode = AuthErrorCode(rawValue: err._code)
                            switch errCode {
                            case .networkError:
                                UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription). Check your network and try again", duration: 7)
                            default:
                                UIStyling.showAlert(viewController: self, text: "Error: \(err.localizedDescription).")
                            }
                            UIStyling.hideLoading(view: self.view)
                            return
                        }
                        self.performSegue(withIdentifier: Constants.createAccToWelcome, sender: self)
                    }
                    return
                }
            //}
        }
    }
    
    func validateFields() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "please fill in everything..."
        }
        if !isValidEmail(emailTextField.text!){
            return "Please put a valid email."
        }
        return nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func newDbEntry(email: String, password: String) {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let usersRef = Firestore.firestore().collection("users")
        usersRef.document(uid!).setData(["email" : email, "nickname" : self.nameTextField.text ?? "", "uid" : uid!, "level-progress" : [:], "game-currency" : 100, "hints" : 10, "unlocked-sounds" : ["cat_basic1", "drumsnare1", "vibes1"]], merge: true)
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // unwind segues
    @IBAction func unwindFromCreateAccToWelcome(_ sender: Any) {
        performSegue(withIdentifier: Constants.createAccToWelcome, sender: self)
        UIStyling.hideLoading(view: self.view)
    }
    
    @IBAction func unwindFromCreateAccToSignIn(_ sender: Any) {
        if mergingAnon {
            performSegue(withIdentifier: Constants.createAccToWelcome, sender: self)
        }
        else {
            performSegue(withIdentifier: Constants.createAccToSignIn, sender: self)
        }
    }
    

}
