//
//  ViewController.swift
//  Component_Mirant
//
//  Created by Mirant Patel on 15/07/19.
//  Copyright © 2019 Mirant Patel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.textType = .emailAddress
        passwordTextField.textType = .password
        //mobileNoTextField.isEnabled = false
        //emailTextField.text = "eve.holt@reqres.in"
        //passwordTextField.text = "pistol"
    }
    
    // MARK: - User Interaction
    @IBAction func buttonSignIn(_ sender: Any) {
        let options: PasswordOption = [.specialCharacter, .smallAlphabet, .numericValue, .capitalAlphabet]
        let password = passwordTextField.text
        
        if (emailTextField.isEmpty) {
            showAlertView(withTitle: "Alert", message: "Please enter email id")
            emailTextField.clear()
            mobileNoTextField.clear()
        } else if (passwordTextField.isEmpty) {
            showErrorAlert(withMessage: "Please enter password")
        } else if (!emailTextField.isEmpty && !emailTextField.text!.isValidEmail) {
            showErrorAlert(withMessage: "Please enter valid email")
        } else if (!(password?.isPasswordValid(forSelectedOptions: options, minLength: 5, maxLength: 15))!) {
            showErrorAlert(withMessage: "Please enter valid password")
        } else {
            //API Request
            let param: [String: Any] = [
                "email": "eve.holt@reqres.in",
                "password": "cityslicka"
            ]
            API.postRequest(relPath: "login", param: param) { (json, statusCode) in
                
                if statusCode == 200, let resObj: [String: String] = json as? [String: String] {
                    // create object for login model
                    let loginModel = Login(token: resObj["token"]!, status: statusCode, error: nil)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                        self.performSegue(withIdentifier: "ShowUserList", sender: nil)
                    }
                    self.showAlertView(withTitle: "Success", message: "Logged-In successfully!" + " " + loginModel.token!, withActions: [okAction], dismissOnOutisideTouch: true)
                } else if let errObj: [String: String] = json as? [String: String] {
                    
                    let loginModel = Login(token: nil, status: statusCode, error: errObj["error"]!)
                    self.showErrorAlert(withMessage: loginModel.error)
                }
            }
        }
    }
}
