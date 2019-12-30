//
//  SignupViewController.swift
//  SignupModule
//
//  Created by Nirav Hathi on 15/07/19.
//  Copyright © 2019 Nirav Hathi. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    //IBoutlets
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Signup"
        
        textFieldFirstName.textType = .normal
        textFieldLastName.textType = .normal
        textFieldEmail.textType = .emailAddress
        textFieldPhone.textType = .phoneNumber
        textFieldPassword.textType = .password
        textFieldConfirmPassword.textType = .password
        
        textFieldPassword.placeholder = "Password"
        textFieldConfirmPassword.placeholder = "Retype Password"
        textFieldFirstName.placeholder = "First Name"
        textFieldLastName.placeholder = "Last Name"
        // Do any additional setup after loading the view.
    }
    
    // MARK: - User Interaction
    @IBAction func buttonSignupClicked(_ sender: UIButton) {
        
        if (textFieldFirstName.isEmpty) {
            showErrorAlert(withMessage: "Please enter first name")
            return
        }
        if (textFieldLastName.isEmpty) {
            showErrorAlert(withMessage: "Please enter last name")
            return
        }
        if (textFieldEmail.isEmpty || !(textFieldEmail.text?.isValidEmail)!) {
            showErrorAlert(withMessage: "Please enter valid E-mail")
            return
        }
        if (textFieldPhone.isEmpty || !(textFieldPhone.text?.isValidPhoneNumber)!) {
            //printError(log_message: "Please enter phone number")
            showErrorAlert(withMessage: "Please enter valid mobile number")
            return
        }
        
        if (textFieldPassword.isEmpty) {
            showErrorAlert(withMessage: "Please enter password")
            return
        }
        if (textFieldConfirmPassword.isEmpty) {
            showErrorAlert(withMessage: "Please enter confirm password")
            return
        }
        
        let options: PasswordOption = [.specialCharacter, .smallAlphabet, .numericValue, .capitalAlphabet]
        let password = textFieldPassword.text
        
        if (!(password?.isPasswordValid(forSelectedOptions: options, minLength: 5, maxLength: 15))!) {
            showErrorAlert(withMessage: "Password must be min. 6 length with one capital letter, one numeric, one special character and one small alphabetic character.")
            
            return
        }
        
        if (textFieldPassword.text != textFieldConfirmPassword.text) {
            showErrorAlert(withMessage: "Confirm password does not match")
            return
        }
        
        //API Request 
        let param: [String: Any] = [
            "email": "eve.holt@reqres.in",
            "password": "pistol"
        ]
        
        API.postRequest(relPath: "register", param: param) { (json, statusCode) in
            
            if statusCode == 200, let resObj: [String: Any] = json as? [String: Any] {
                // create object for login model
                let loginModel = Register(id: resObj["id"]! as? Int, token: (resObj["token"]! as! String), status: statusCode, error: nil)
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.performSegue(withIdentifier: "ShowUserList", sender: nil)
                }
                self.showAlertView(withTitle: "Success", message: "User successfully registered" + " " + loginModel.token!, withActions: [okAction], dismissOnOutisideTouch: true)
            } else if let errObj: [String: String] = json as? [String: String] {
                
                let loginModel = Register(id: nil, token: nil, status: statusCode, error: errObj["error"]!)
                self.showErrorAlert(withMessage: loginModel.error)
            }
        }
        
        //showAlertView(withTitle: "Success", message: "User successfully registered")
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
