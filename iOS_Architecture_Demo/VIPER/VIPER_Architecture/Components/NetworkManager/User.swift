//
//  MapperManager.swift
//  NetworkManager
//
//  Created by Yogesh Makwana on 16/07/19.
//  Copyright © 2019 Volansys Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class Address: Mappable {
    
    dynamic var id = 0
    dynamic var email = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var avatar = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        avatar <- map["avatar"]
    }
}

class User: Mappable {
    
    dynamic var id = 0
    dynamic var email = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var avatar = ""
    dynamic var address: Address?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        avatar <- map["avatar"]
        address = Address(JSON: map.JSON)
    }
}
