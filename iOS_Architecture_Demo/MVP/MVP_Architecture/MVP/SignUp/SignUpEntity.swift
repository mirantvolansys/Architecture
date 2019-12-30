//
//  SignUpEntity.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 29/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import Foundation

public class SignUpEntity {
	public var id : Int?
	public var token : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let SignUpEntity_list = SignUpEntity.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of SignUpEntity Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [SignUpEntity]
    {
        var models:[SignUpEntity] = []
        for item in array
        {
            models.append(SignUpEntity(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let signUpEntity = SignUpEntity(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: SignUpEntity Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		token = dictionary["token"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.token, forKey: "token")

		return dictionary
	}

}
