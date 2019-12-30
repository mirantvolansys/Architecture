//
//  SignUpInteractor.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//


import UIKit

protocol SignUpInteractorProtocol {
    func callSignupApi(params : Dictionary<String, String>)
}

class SignUpInteractor: SignUpInteractorProtocol {
    var presenter: SignUpPresentationProtocol?
    
    // MARK: functions
    /**
     User can call api and return responds to presenter via delegate method
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
                
                self.presenter?.getSignupResponse(signupData: objSignUp!, errorString: nil)
            } else {
                self.presenter?.getSignupResponse(signupData: nil, errorString: (json as! Dictionary)["error"])
            }
        }
    }
}
