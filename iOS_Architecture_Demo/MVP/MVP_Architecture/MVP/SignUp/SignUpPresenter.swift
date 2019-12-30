//
//  SignUpPresenter.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//


import UIKit

protocol SignUpPresentationProtocol {
    func callSignupRequest(signupParams: Dictionary<String, String>)
}

class SignUpPresenter: SignUpPresentationProtocol {
    weak var viewController: SignUpProtocol?
    
    // MARK: Functions
    
    /**
     If validation is correct then presenter call api
     Parameters : -
        signupParams -> Dictionary of sign up parameters
     */
    func callSignupRequest(signupParams: Dictionary<String, String>) {
        if self.validateLogin(param: signupParams) {
            self.callSignupApi(params : signupParams)
        }
    }
    
    /**
     User can call api and return responds via method
     Parameters : -
     params -> Dictionary with passing parameters in api
     */
    func callSignupApi(params : Dictionary<String, String>) {
        let loginParam = [
            "email":"eve.holt@reqres.in",
            "password": "pistol"
        ]
        
        networkManager.postRequest(relPath: "register", param: loginParam) { (json, statusCode) in
            if statusCode == 200 {
                let objSignUp = SignUpEntity(dictionary: json as! NSDictionary)
                print(objSignUp?.dictionaryRepresentation() ?? "")
                
                self.getSignupResponse(signupData: objSignUp!, errorString: nil)
            } else {
                self.getSignupResponse(signupData: nil, errorString: (json as! Dictionary)["error"])
            }
        }
    }
    
    /**
     If response is with success code that push the controller 
     Parameters : -
        signupData -> Dictionary of sign up response parameters
        errorString -> error string if any error in sign up reponse
     */
    func getSignupResponse(signupData : SignUpEntity?, errorString : String?) {
        if errorString != nil {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: errorString!)
            return
        } else {
            print(signupData?.dictionaryRepresentation() ?? "")
            self.pushToUserList(data: signupData!, fromView: self.viewController as! SignUpViewController)
            self.viewController?.displayAlert(strTitle: "Success", strMessage: "Sign-Up successfully!")
        }
    }
    
    /**
     Push controller to UserListViewController
     Parameters : -
     data -> Object of SignUpEntity so you can fetch all sign up response details from this
     fromView -> controller from which we have to navigate
     */
    func pushToUserList(data : SignUpEntity, fromView: UIViewController) {
        let vc : UserListViewController = getViewController(StoryBoard: .Main, Identifier: .UserListViewController) as! UserListViewController
        vc.signUpData = data
        fromView.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     All validation check into this method
     Parameters : -
        param -> Dictionary of sign up parameters
     Response : -
        Bool -> If all validations are correct then return true else false
     */
    func validateLogin(param : Dictionary<String, Any>) -> Bool {
        
        let emailId : String = param["email"] as! String
        let password : String = param["password"] as! String
        let confirmPassword : String = param["confirmPassword"] as! String
        let firstName : String = param["firstname"] as! String
        let lastName : String = param["lastname"] as! String
        let phone : String = param["phone"] as! String
        
        let options : PasswordOption = [.numericValue,.smallAlphabet,.capitalAlphabet] //.specialCharacter
        
        if (firstName.isBlank) {
            self.viewController?.displayAlert(strTitle: "Empty!", strMessage: "Please enter first name")
            return false
        } else if (!firstName.isAlphabetic) {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Please enter proper first name")
            return false
        } else if (lastName.isBlank) {
            self.viewController?.displayAlert(strTitle: "Empty!", strMessage: "Please enter last name")
            return false
        } else if (!lastName.isAlphabetic) {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Please enter proper last name")
            return false
        } else if (emailId.isBlank) {
            self.viewController?.displayAlert(strTitle: "Empty!", strMessage: "Please enter email id")
            return false
        } else if (!emailId.isValidEmail) {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Please enter valid email")
            return false
        } else if (password.isBlank) {
            self.viewController?.displayAlert(strTitle: "Empty!", strMessage: "Please enter password")
            return false
        } else if (!(password.isPasswordValid(forSelectedOptions: options, minLength: 6, maxLength: 15))) {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Please enter valid password. It should not contain special character")
            return false
        } else if (phone.isBlank) {
            self.viewController?.displayAlert(strTitle: "Empty!", strMessage: "Please enter phone number")
            return false
        } else if (!phone.isValidPhoneNumber) {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Please enter valid phone number")
            return false
        } else if password != confirmPassword {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Confirm password did not match")
            return false
        }
        return true
    }
}
