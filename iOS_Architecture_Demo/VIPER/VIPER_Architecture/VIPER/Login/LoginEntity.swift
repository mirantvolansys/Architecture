//
//  LoginEntity.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 29/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import Foundation

public class LoginEntity {
	public var token : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let LoginEntity_list = LoginEntity.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of LoginEntity Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [LoginEntity] {
        var models:[LoginEntity] = []
        for item in array
        {
            models.append(LoginEntity(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let loginEntity = LoginEntity(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: LoginEntity Instance.
*/
	required public init?(dictionary: NSDictionary) {

		token = dictionary["token"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.token, forKey: "token")

		return dictionary
	}

}
