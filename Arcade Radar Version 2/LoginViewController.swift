//
//  LoginViewController.swift
//  Arcade Radar Version 2
//
//  Created by iOS Developer on 7/28/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

/*class LoginViewController: FormViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.backgroundColor = Colors.yesColor
        self.loginButton.titleLabel?.addTextSpacing()
        self.loginButton.layer.cornerRadius = 15
        
        self.usernameTextField.returnKeyType = .next
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.returnKeyType = .done

    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.completedForm()
    }
    
    override func completedForm() {
        UserSession.shared.loginToAccount(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "") { (wasSuccessful, message) in
            if wasSuccessful {
                self.alert(title: "Login Successful", message: message, alertTitle: "Awesome", handler: { 
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                self.alert(title: "Oh No!", message: message, alertTitle: "Fix it", handler: nil)
            }
        }
    }

}*/
