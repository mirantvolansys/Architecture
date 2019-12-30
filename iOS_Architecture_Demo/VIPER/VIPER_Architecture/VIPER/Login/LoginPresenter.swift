//
//  LoginPresenter.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 29/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import UIKit

protocol LoginPresentationProtocol {
    func callLoginRequest(loginParams : Dictionary<String, String>)
    func getLoginResponse(loginData : LoginEntity?, errorString : String?)
}

class LoginPresenter: LoginPresentationProtocol {
    weak var viewController: LoginProtocol?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    
    // MARK: Delegate functions
   
    /**
     If validation is correct then presenter ask Interactor for api call
     Parameters : -
        loginParams -> Dictionary of login parameters
     */
    func callLoginRequest(loginParams : Dictionary<String, String>) {
        if self.validateLogin(param: loginParams) {
            self.viewController?.showLoadingIndicator()

            self.interactor?.callLoginApi(params : loginParams)
        }
    }
    
    /**
     If response is with success code which sent by interactor then push controller through rounter file
     Parameters : -
        loginData -> Dictionary of login response parameters
        errorString -> error string if any error in login reponse
     */
    func getLoginResponse(loginData : LoginEntity?, errorString : String? = nil) {
        self.viewController?.hideLoadingIndicator()

        if errorString != nil {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: errorString!)
            return
        } else {
            print(loginData!.token!)
            self.viewController?.displayAlertSuccess(strTitle: "Success", strMessage: "Logged-In successfully!", completion: { (value) in
                if(value == 1) {
                    self.router?.pushToUserList(data: loginData!, fromView: self.viewController as! LoginViewController)
                } else {
                    print("Cancel")
                }
            })
            
//            self.viewController?.displayAlert(strTitle: "Success", strMessage: "Logged-In successfully!")
        }
    }
    
    
    
    /**
     All validation check into this method
     Parameters : -
        param -> Dictionary of login parameters
     Response : -
        Bool -> If all validations are correct then return true else false
     */
    func validateLogin(param : Dictionary<String, Any>) -> Bool {
        
        let emailId : String = param["email"] as! String
        let password : String = param["password"] as! String
        
//        return true
        
        let options : PasswordOption = [.numericValue,.smallAlphabet,.capitalAlphabet] //.specialCharacter
        
        if (emailId.isBlank) {
            self.viewController?.displayAlert(strTitle: "Empty!", strMessage: "Please enter email id")
            return false
        } else if (password.isBlank) {
            self.viewController?.displayAlert(strTitle: "Empty!", strMessage: "Please enter password")
            return false
        } else if (!emailId.isValidEmail) {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Please enter valid email")
            return false
        } else if (!(password.isPasswordValid(forSelectedOptions: options, minLength: 6, maxLength: 15))) {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: "Please enter valid password")
            return false
        }
        
        return true
    }
}
