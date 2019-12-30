//
//  ViewController.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginVC: UIViewController {
    let loginVM: LoginViewModel = LoginViewModel()

    /// Outlets
    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            self.txtPassword.delegate = self as? UITextFieldDelegate
            self.txtPassword.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            self.txtEmail.delegate = self as? UITextFieldDelegate
            self.txtEmail.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        }

    }
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnRegisterNow: UIButton!
    
    /// View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindLoginModel()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Setup
    fileprivate func setupUI() {
        self.btnSignIn.isEnabled = true
        txtEmail.textType = .emailAddress
        txtPassword.textType = .password
        
//        #if DEBUG
//        txtEmail.text = "shrenik@gmail.com"
//        txtPassword.text = "Shrenik12@"
//        #endif
    }
    
    // MARK: - Textfield Text change Handlers
    @objc func passwordTextFieldDidChange(textField: UITextField) {
        loginVM.password = textField.text ?? ""
    }
    
    @objc func emailTextFieldDidChange(textField: UITextField) {
        loginVM.emailAddress = textField.text ?? ""
    }
    
    fileprivate func bindLoginModel() {
        loginVM.emailAddress = txtEmail.text
        loginVM.password = txtPassword.text
    }
    
    // MARK: - Button Action Handler
    /// Sign-In Handler
    ///
    /// - Parameter sender: UIButton as sender
    @IBAction func signInButton_Clicked(_ sender: UIButton) {
        loginVM.validateUserInput(success: { (_) in
            self.performUserLogin()
        }) { (alertMsg) in
            self.showErrorAlert(withMessage: alertMsg)
        }
    }

    @IBAction func registerNow_Tapped(_ sender: Any) {
        performSegue(withIdentifier: "RegistrationSegue", sender: nil)
    }
    
    fileprivate func performUserLogin() {
        let model = LoginViewModel()
        
        SVProgressHUD.show()
        
        model.loginUser(withEmailAddress: txtEmail.text!, password: txtPassword.text!, success: { (objLogin) in
            SVProgressHUD.dismiss()
            printInfo(logMessage: "Login successful")
            if let id = objLogin.token {
                print("Login Successful for id :\(id)")
                self.performSegue(withIdentifier: "UserListSegue", sender: nil)
            } else {
                self.showErrorAlert(withMessage: "Invalid user details")
            }
        }) { (error) in
            SVProgressHUD.dismiss()
            print("error : \(error)")
            self.showErrorAlert(withMessage: error.localizedDescription)
            printError(logMessage: error.localizedDescription)
        }
    }
}
