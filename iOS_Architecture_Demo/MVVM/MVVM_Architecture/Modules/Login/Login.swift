//
//  Login.swift
//  MVC_Architecture
//
//  Created by Nirav Hathi on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation
import ObjectMapper

class Login: Mappable {
    var token: String?

    // MARK: - Object Mapper
    required init?(map: Map) {
        
    }
    
    //mapping the json keys with properties
    public func mapping(map: Map) {
        self.token  <- map["token"]
    }
}
