//
//  LoginInteractor.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 29/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import UIKit

protocol LoginInteractorProtocol {
    func callLoginApi(params : Dictionary<String, String>)
}

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresentationProtocol?
    
    // MARK: functions
    /**
     User can call api and return responds to presenter via delegate method
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
                
                self.presenter?.getLoginResponse(loginData: objLogin!, errorString: nil)
            } else {
                self.presenter?.getLoginResponse(loginData: nil, errorString: (json as! Dictionary)["error"])
            }
        }
    }
}

