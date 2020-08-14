//
//  SignInVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/27/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInEmailVC: UIViewController {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tempTextField: UITextField!
    @IBOutlet weak var jamButton: UIButton!
    
    var currentlyEditing: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGraphics()
        setUpKeyboards()
    }
    
    func setUpGraphics() {
        self.view.backgroundColor = ColorPalette.brightManuscript
        UIStyling.setHeader(header: header)
        
        UIStyling.setButtonStyle(button: backButton)
        backButton.layer.cornerRadius = 5
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        UIStyling.setButtonStyle(button: jamButton)
        jamButton.backgroundColor = ColorPalette.friendlyGold
        jamButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        jamButton.layer.cornerRadius = 24
        
        UIStyling.setTextField(textField: emailTextField, placeholder: "Email")
        UIStyling.setTextField(textField: passwordTextField, placeholder: "Password")
        UIStyling.setTextField(textField: tempTextField, placeholder: "Temp")
        tempTextField.isHidden = true
    }
    
    func setUpKeyboards() {
        dismissKeyboard()
        tempTextField.returnKeyType = .done
    }
    
    
    @IBAction func emailPressed(_ sender: Any) {
        tempTextField.isHidden = false
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        
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
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        
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
        emailTextField.isHidden = false
        passwordTextField.isHidden = false

        currentlyEditing?.text = tempTextField.text
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            // then show the error message
            UIStyling.showAlert(viewController: self, text: error!)
            //errMessage.text = error
        }
        else {
            UIStyling.showLoading(view: self.view)
            // attempt sign in
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, err) in
                if err != nil {
                    UIStyling.hideLoading(view: self.view)
                    print(err!.localizedDescription)
                    UIStyling.showAlert(viewController: self, text: err!.localizedDescription)
                    return
                }
                else {
                    self.performSegue(withIdentifier: Constants.signInEmailToWelcome, sender: self)
                    UIStyling.hideLoading(view: self.view)
                }
            }
        }
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.signInEmailToSignIn, sender: self)
    }
    

}
