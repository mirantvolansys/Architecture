//
//  RegistrationViewModel.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 31/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupViewModel {
    var objRegistrationUser: User?
    var emailAddress: String?
    var password: String?
    var phone: String?
    var firstName: String?
    var lastName: String?
    var confirmPassword: String?
    
    func validateUserInput(success: @escaping (Bool) -> Void, failure: @escaping (String) -> Void) {
        let passwordOptions: PasswordOption = [.smallAlphabet, .capitalAlphabet, .specialCharacter, .numericValue]
        
        if self.firstName!.isBlank {
            failure("Please enter first name")
            return
        }
        
        if self.lastName!.isBlank {
            failure("Please enter last name")
            return
        }
        
        if self.emailAddress!.isBlank || !self.emailAddress!.isValidEmail {
            failure("Please enter valid Email")
            return
        }
        
        if self.phone!.isBlank || !self.phone!.isValidPhoneNumber {
            failure("Please enter valid phone number")
            return
        }
        
        if self.password!.isBlank || !(self.password!.isPasswordValid(forSelectedOptions: passwordOptions, minLength: 5, maxLength: 16)) {
            failure("Please enter valid password. It should contain minimum one capital, small, alphabetic and numeric value.")
            return
        }
        
        if self.password! != self.confirmPassword {
            failure("Confirm password did not match")
            return
        }
        
        success(true)
    }

    func registerUser(success: @escaping (Bool, User?) -> Void, failure: @escaping (Error?) -> Void) {
        SVProgressHUD.show()
        let param: [String: String] = ["email": "shrenik@reqres.in", "password": "pistol"]
        
        networkManager.makeObjectRequest(forClass: User.self, requestMethod: .post, withApiUrl: API.registerUser, params: param, success: { (signupResponse) in

            SVProgressHUD.dismiss()
            print("signupResponse : \(signupResponse)")
            
            let userResponse = signupResponse.result.value!
            //check the response status
            if let status = signupResponse.response?.statusCode, status != resultOK {
                let errorInvalidUser = NSError(domain: "Error", code: status, userInfo: [NSLocalizedDescriptionKey: userResponse.errorString ?? "Invalid user info"])
                failure(errorInvalidUser)
                return
            }
            
            if userResponse.token != nil {
                // return users' list in success block
                success(true, userResponse)
            } else {
                failure(nil)
            }

        }) { (error) in
            failure(error)
            SVProgressHUD.dismiss()
        }
    }
}
