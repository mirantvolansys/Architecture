//
//  Constants.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 31/07/19.
//  Copyright © 2019 Mirant Patel. All rights reserved.
//

import Foundation

//MARK:- Storyboards
enum Storyboards : String {
    case Main
}

//MARK: - Controller Identifier
enum ControllerIdentifier : String {
    case LoginViewController
    case SignUpViewController
    case UserListViewController
}

let KEYDOMAIN  = "com.volansys"

enum ProjectEnvironment {
    case staging, production
    
    var baseUrl: String {
        switch self {
        case .staging:
            return "https://reqres.in/api/"
        case .production:
            //return "https://reqres.in/api/"
            return "https://api.imgur.com/"
        }
    }
}

let environment = ProjectEnvironment.staging
struct API {
    static let login = environment.baseUrl + "login"
    static let usersList = environment.baseUrl + "users"
    static let registerUser = environment.baseUrl + "register"
}
