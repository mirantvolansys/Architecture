//
//  SignupViewController.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupVC: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    let signupVM = SignupViewModel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupUI() {
        txtFirstName.placeholder = "First Name"
        txtLastName.placeholder = "Last Name"
        
        txtPassword.textType = .password
        txtConfirmPassword.textType = .password
        txtPhoneNumber.textType = .phoneNumber
        txtEmail.textType = .emailAddress
        
        txtConfirmPassword.placeholder = "Confirm Password"
    }
    fileprivate func bindSingupModel() {
        signupVM.emailAddress = txtEmail.text
        signupVM.password = txtPassword.text
        signupVM.firstName = txtFirstName.text
        signupVM.lastName = txtLastName.text
        signupVM.phone = txtPhoneNumber.text
        signupVM.confirmPassword = txtConfirmPassword.text
    }
    
    // MARK: - Button Action Handler
    @IBAction func registerButton_Tapped(_ sender: UIButton) {
        bindSingupModel()
        signupVM.validateUserInput(success: { (status) in
            self.signupVM.registerUser(success: { (status, _) in
                if status {
                    self.performSegue(withIdentifier: "ShowUsersSegue", sender: self)
                }
            }) { (error) in
                if let erroDesc = error?.localizedDescription {
                    self.showErrorAlert(withMessage: erroDesc)
                } else {
                    self.showErrorAlert(withMessage: "Unable to process your request. Please try again later!")
                }
            }
        }) { (alertMsg) in
            self.showErrorAlert(withMessage: alertMsg)
        }
    }
    
    fileprivate func isAllInputsValid() -> Bool {
        var msg = ""
        // check for username
        guard !txtFirstName.isEmpty else {
            msg = "Please enter first name"
            printError(logMessage: msg)
            self.showErrorAlert(withMessage: msg)
            return false
        }
        
        // check for username
        guard !txtLastName.isEmpty else {
            msg = "Please enter last name"
            printError(logMessage: msg)
            self.showErrorAlert(withMessage: msg)
            
            return false
        }
        
        // check for Email
        guard !txtEmail.isEmpty && txtEmail.text!.isValidEmail else {
            msg = "Please enter valid Email address"
            printError(logMessage: msg)
            self.showErrorAlert(withMessage: msg)
            return false
        }
        
        // check for Phone Number
        guard !txtPhoneNumber.isEmpty && txtPhoneNumber.text!.isValidPhoneNumber else {
            msg = "Please enter valid Phone Number"
            printError(logMessage: msg)
            self.showErrorAlert(withMessage: msg)
            return false
        }
        
        let options: PasswordOption = [.noRestriction]
        // check password
        guard !txtPassword.isEmpty && txtPassword.text!.isPasswordValid(forSelectedOptions: options, minLength: 5, maxLength: 15) else {
            msg = "Please enter valid password"
            printError(logMessage: msg)
            self.showErrorAlert(withMessage: msg)
            return false
        }
        
        // validate password and confirm password
        guard !txtConfirmPassword.isEmpty && (txtPassword.text == txtConfirmPassword.text) else {
            msg = "Password and Confirm password are not same"
            printError(logMessage: msg)
            self.showErrorAlert(withMessage: msg)
            return false
        }
        return true
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
