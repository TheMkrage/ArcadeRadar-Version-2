//
//  SignupViewController.swift
//  Arcade Radar Version 2
//
//  Created by iOS Developer on 7/25/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

/*class SignupViewController: FormViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reenterPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signupButton.backgroundColor = Colors.yesColor
        self.signupButton.titleLabel?.addTextSpacing()
        self.signupButton.layer.cornerRadius = 15
        
        self.emailField.keyboardType = .emailAddress
        self.emailField.returnKeyType = .next
        self.usernameField.returnKeyType = .next
        self.passwordField.isSecureTextEntry = true
        self.passwordField.returnKeyType = .next
        self.reenterPasswordField.isSecureTextEntry = true
        self.reenterPasswordField.returnKeyType = .join
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        self.completedForm()
    }
    
    override func completedForm() {
        guard let email = self.emailField.text, let username = self.usernameField.text, let password = self.passwordField.text, let reenterPassword = self.reenterPasswordField.text else {
            return
        }
        if password != reenterPassword && password != "" {
            self.passwordField.layer.borderColor = UIColor.red.cgColor
            self.passwordField.layer.borderWidth = 1.0
            self.reenterPasswordField.layer.borderWidth = 1.0
            self.reenterPasswordField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if !email.contains("@") {
            self.emailField.layer.borderWidth = 1.0
            self.emailField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        UserSession.shared.createAccount(withUsername: username, email: email, password: password, callback: { (wasSuccessful) in
            print(wasSuccessful)
            if wasSuccessful {
                self.alert(title: "Woo Hoo!", message: "Account successfully created", alertTitle: "Awesome", handler: {
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                self.alert(title: "Oh no!", message: "There is already and account using this login information...", alertTitle: "Fix it", handler: nil)
            }
        })
    }
    
    
}*/
