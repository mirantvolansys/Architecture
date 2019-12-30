//
//  User.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 30, 2019

import Foundation

class User: NSObject, NSCoding {

    var data: [UserData]!
    var page: Int!
    var perPage: Int!
    var total: Int!
    var totalPages: Int!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        page = dictionary["page"] as? Int
        perPage = dictionary["per_page"] as? Int
        total = dictionary["total"] as? Int
        totalPages = dictionary["total_pages"] as? Int
        data = [UserData]()
        if let dataArray = dictionary["data"] as? [[String: Any]] {
            for dic in dataArray {
                let value = UserData(fromDictionary: dic)
                data.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if page != nil {
            dictionary["page"] = page
        }
        if perPage != nil {
            dictionary["per_page"] = perPage
        }
        if total != nil {
            dictionary["total"] = total
        }
        if totalPages != nil {
            dictionary["total_pages"] = totalPages
        }
        if data != nil {
            var dictionaryElements = [[String: Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        data = aDecoder.decodeObject(forKey: "data") as? [UserData]
        page = aDecoder.decodeObject(forKey: "page") as? Int
        perPage = aDecoder.decodeObject(forKey: "per_page") as? Int
        total = aDecoder.decodeObject(forKey: "total") as? Int
        totalPages = aDecoder.decodeObject(forKey: "total_pages") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if data != nil {
            aCoder.encode(data, forKey: "data")
        }
        if page != nil {
            aCoder.encode(page, forKey: "page")
        }
        if perPage != nil {
            aCoder.encode(perPage, forKey: "per_page")
        }
        if total != nil {
            aCoder.encode(total, forKey: "total")
        }
        if totalPages != nil {
            aCoder.encode(totalPages, forKey: "total_pages")
        }
    }
}
