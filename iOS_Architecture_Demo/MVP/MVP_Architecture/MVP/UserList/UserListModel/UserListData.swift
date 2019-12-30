//
//  UserListData.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import Foundation


public class UserListData {
	public var id : Int?
	public var email : String?
	public var first_name : String?
	public var last_name : String?
	public var avatar : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = UserListData.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of UserListData Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserListData]
    {
        var models:[UserListData] = []
        for item in array
        {
            models.append(UserListData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let userListData = UserListData(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: UserListData Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		email = dictionary["email"] as? String
		first_name = dictionary["first_name"] as? String
		last_name = dictionary["last_name"] as? String
		avatar = dictionary["avatar"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.first_name, forKey: "first_name")
		dictionary.setValue(self.last_name, forKey: "last_name")
		dictionary.setValue(self.avatar, forKey: "avatar")

		return dictionary
	}

}
