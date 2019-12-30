//
//  User.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import UIKit
import ObjectMapper

class UserResponse: Mappable {
    var page: Int?
    var perPage: Int?
    var total: Int?
    var totalPages: Int?
    var users: [User]?
    
    // MARK: - Object Mapper
    required init?(map: Map) {
        
    }
    
    // mapping the json keys with properties
    public func mapping(map: Map) {
        page  <- map["page"]
        perPage   <- map["per_page"]
        total <- map["total"]
        totalPages <- map["total_pages"]
        users <- map["data"]
    }

}

class User: Mappable {
    var id: Int?
    var errorString: String?
    var emailAddress: String?
    var firstName: String?
    var lastName: String?
    var avatar: String?
    var token: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        emailAddress <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        avatar <- map["avatar"]
        token <- map["token"]
        errorString <- map["error"]
    }
}
