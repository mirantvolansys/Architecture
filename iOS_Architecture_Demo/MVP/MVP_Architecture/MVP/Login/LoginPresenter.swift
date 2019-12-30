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
}

class LoginPresenter: LoginPresentationProtocol {
    weak var viewController: LoginProtocol?
    
    // MARK: Functions
   
    /**
     If validation is correct then presenter call for api
     Parameters : -
        loginParams -> Dictionary of login parameters
     */
    func callLoginRequest(loginParams : Dictionary<String, String>) {
        if self.validateLogin(param: loginParams) {
            self.callLoginApi(params : loginParams)
        }
    }
    
    /**
     User can call api responds to method
     Parameters : -
     params -> Dictionary with passing parameters in api
     */
    func callLoginApi(params : Dictionary<String, String>) {
        
        let loginParam = [
            "email":"eve.holt@reqres.in",
            "password": "cityslicka"
        ]
        
        networkManager.postRequest(relPath: "login", param: loginParam) { (json, statusCode) in
            if statusCode == 200 {
                let objLogin = LoginEntity(dictionary: json as! NSDictionary)
                print(objLogin?.dictionaryRepresentation() ?? "")
                
                self.getLoginResponse(loginData: objLogin!, errorString: nil)
            } else {
                self.getLoginResponse(loginData: nil, errorString: (json as! Dictionary)["error"])
            }
        }
    }
    
    /**
     If response is with success code then push to the next controller
     Parameters : -
        loginData -> Dictionary of login response parameters
        errorString -> error string if any error in login reponse
     */
    func getLoginResponse(loginData : LoginEntity?, errorString : String? = nil) {
        if errorString != nil {
            self.viewController?.displayAlert(strTitle: "Error", strMessage: errorString!)
            return
        } else {
            print(loginData!.token!)
            self.pushToUserList(data: loginData!, fromView: self.viewController as! LoginViewController)
            self.viewController?.displayAlert(strTitle: "Success", strMessage: "Logged-In successfully!")
        }
    }
    
    /**
     Push controller to UserListViewController
     Parameters : -
     data -> Object of LoginEntity so you can fetch all login response details from this
     fromView -> controller from which we have to navigate
     */
    func pushToUserList(data : LoginEntity, fromView: UIViewController) {
        let vc : UserListViewController = getViewController(StoryBoard: .Main, Identifier: .UserListViewController) as! UserListViewController
        vc.loginData = data
        fromView.navigationController?.pushViewController(vc, animated: true)
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
