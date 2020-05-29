//
//  SignInVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/27/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
    }
    
    @IBOutlet weak var errMessage: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            // then show the error message
            errMessage.text = error
            errMessage.isHidden = false
        }
        else {
            // attempt sign in
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, err) in
                if err != nil {
                    print(err!.localizedDescription)
                    self.errMessage.text = err?.localizedDescription
                    self.errMessage.isHidden = false
                    return
                }
                else {
                    self.performSegue(withIdentifier: "backToWelcomeFromSignInUSegue", sender: self)
                }
            }
        }
        
    }
    
    @IBAction func newAccButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "fromSignInToCreateAccSegue", sender: self)
    }
    
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func backToSignInFromCreateAcc(segue: UIStoryboardSegue) {}

}
