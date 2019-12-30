//
//  UserDefaultsManager.swift
//  BasicUtilities
//
//  Created by Shrenik on 17/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation

let defaultManager = UserDefaultsManager.shared

class UserDefaultsManager {
    
    var userDefault = UserDefaults.standard
    
    //shared
    static let shared = {
        return UserDefaultsManager()
    }()
    
    func set(_ value: Any?, forKey defaultName: String){
        userDefault.set(value, forKey: defaultName)
    }
    
    func setBool(_ value: Bool, forKey defaultName: String){
        userDefault.set(value, forKey: defaultName)
    }
    
    func value(forKey key: String) -> Any? {
        return userDefault.value(forKey: key)
    }
    
    func setValue(_ value: Any?, forKey key: String){
        userDefault.setValue(value, forKey: key)
    }
    
    func removeObject(forKey defaultName: String) {
        userDefault.removeObject(forKey: defaultName)
    }
    
    func bool(forKey defaultName: String) -> Bool {
        return userDefault.bool(forKey:defaultName)
    }
    
    func sync() {
        userDefault.synchronize()
    }
}
