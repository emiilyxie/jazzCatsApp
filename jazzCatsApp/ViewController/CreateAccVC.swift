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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dismissKeyboard()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func createAccButton(_ sender: Any) {
        // 1. validate fields
        let error = validateFields()
        if error != nil {
            // then show the error message
            errorMessage.text = error
            errorMessage.isHidden = false
        }
        else {
            // continue with login
            
            let email = emailTextField.text!
            let password = passwordTextField.text!
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, err) in
                
                if err != nil {
                    print(err!.localizedDescription)
                    self.errorMessage.text = err?.localizedDescription
                    self.errorMessage.isHidden = false
                    return
                }
                else {
                    
                    // sign in the user
                    Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
                        if err != nil {
                            print(err!.localizedDescription)
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
    
    func validateFields() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "please fill in everything..."
        }
        if !isValidEmail(emailTextField.text!){
            return "please put an actually valid email"
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
        usersRef.document(uid!).setData(["email" : email, "password" : password, "nickname" : self.nameTextField.text!, "uid" : uid!, "levels-completed" : 0, "game-currency" : 0], merge: true)
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func unwindFromCreateAccToWelcome(_ sender: Any) {
        performSegue(withIdentifier: "fromCreateAccToWelcomeUSegue", sender: nil)
    }
    
    @IBAction func unwindFromCreateAccToSignIn(_ sender: Any) {
        performSegue(withIdentifier: "fromCreateAccToSignInUSegue", sender: nil)
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
