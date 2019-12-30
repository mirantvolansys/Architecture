//
//  UserListEntity.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import Foundation

public class UserListEntity {
	public var page : Int?
	public var per_page : Int?
	public var total : Int?
	public var total_pages : Int?
	public var data : Array<UserListData>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let UserListEntity_list = UserListEntitye.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of UserListEntity Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserListEntity]
    {
        var models:[UserListEntity] = []
        for item in array
        {
            models.append(UserListEntity(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let userListEntity = UserListEntity(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: UserListEntity Instance.
*/
	required public init?(dictionary: NSDictionary) {

		page = dictionary["page"] as? Int
		per_page = dictionary["per_page"] as? Int
		total = dictionary["total"] as? Int
		total_pages = dictionary["total_pages"] as? Int
        if (dictionary["data"] != nil) { data = UserListData.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.page, forKey: "page")
		dictionary.setValue(self.per_page, forKey: "per_page")
		dictionary.setValue(self.total, forKey: "total")
		dictionary.setValue(self.total_pages, forKey: "total_pages")

		return dictionary
	}

}
