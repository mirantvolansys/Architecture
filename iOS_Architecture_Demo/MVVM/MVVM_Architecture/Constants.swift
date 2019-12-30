//
//  Constants.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation

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
