//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 30, 2019

import Foundation

class UserData: NSObject, NSCoding {

    var avatar: String!
    var email: String!
    var firstName: String!
    var id: Int!
    var lastName: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        avatar = dictionary["avatar"] as? String
        email = dictionary["email"] as? String
        firstName = dictionary["first_name"] as? String
        id = dictionary["id"] as? Int
        lastName = dictionary["last_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if avatar != nil {
            dictionary["avatar"] = avatar
        }
        if email != nil {
            dictionary["email"] = email
        }
        if firstName != nil {
            dictionary["first_name"] = firstName
        }
        if id != nil {
            dictionary["id"] = id
        }
        if lastName != nil {
            dictionary["last_name"] = lastName
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if avatar != nil {
            aCoder.encode(avatar, forKey: "avatar")
        }
        if email != nil {
            aCoder.encode(email, forKey: "email")
        }
        if firstName != nil {
            aCoder.encode(firstName, forKey: "first_name")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if lastName != nil {
            aCoder.encode(lastName, forKey: "last_name")
        }
    }
}
