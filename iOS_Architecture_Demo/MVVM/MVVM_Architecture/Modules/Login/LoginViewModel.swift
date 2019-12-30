//
//  LoginViewModel.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation

class LoginViewModel {
    var emailAddress: String?
    var password: String?
    
    /// Validate User provided inputs and send-back true/false result
    ///
    /// - Parameters:
    ///   - success: status of validation (true/false)
    ///   - failure: error while validating the inputs
    func validateUserInput(success:@escaping (Bool) -> Void, failure:@escaping (String) -> Void) {
        let passwordOptions: PasswordOption = [.smallAlphabet, .capitalAlphabet, .specialCharacter, .numericValue]
        
        if self.emailAddress!.isBlank || !self.emailAddress!.isValidEmail {
            failure("Please enter valid Email")
            return
        }
        
        if self.password!.isBlank || !(self.password!.isPasswordValid(forSelectedOptions: passwordOptions, minLength: 5, maxLength: 16)) {
            failure("Please enter valid password. It should contain minimum one capital, small, alphabetic and numeric value.")
            return
        }
        
        success(true)
    }

    /// Validate login credentials over server
    ///
    /// - Parameters:
    ///   - email: Email
    ///   - password: Password of current user
    ///   - success: Login object which contains session 'token' value
    ///   - failure: Error in case of login fails
    func loginUser(withEmailAddress email: String, password: String, success: @escaping(Login) -> Void, failure: @escaping (Error) -> Void ) {
        let param: [String: Any] = [
            "email": "eve.holt@reqres.in",
            "password": "cityslicka"
        ]
        
        networkManager.makeObjectRequest(forClass: Login.self, requestMethod: .post, withApiUrl: API.login, params: param, success: { (objResponse) in
            print(objResponse)
            
            let userResponse = objResponse.result.value!
            //check the response status
            if objResponse.response?.statusCode == resultOK {
                success(userResponse)
            }
        }) { (error) in
            failure(error)
        }
    }
}
