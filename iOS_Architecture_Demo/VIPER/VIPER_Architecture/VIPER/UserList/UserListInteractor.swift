//
//  UserListInteractor.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//


import UIKit

protocol UserListInteractorProtocol {
    func callUserListApi()
}

protocol UserListDataStore {
    //var name: String { get set }
}

class UserListInteractor: UserListInteractorProtocol, UserListDataStore {
    var presenter: UserListPresentationProtocol?
    
    // MARK: functions
    /**
     User can call api and return responds to presenter via delegate method for user listing array
     */
    func callUserListApi() {
        networkManager.getRequest(relPath: "users") { (json, statusCode) in
            if statusCode == 200 {
                let objUserList = UserListEntity(dictionary: json as! NSDictionary)
                
                self.presenter?.getUserListResponse(userData: objUserList!, errorString: nil)
            } else {
                self.presenter?.getUserListResponse(userData: nil, errorString: (json as! Dictionary)["error"])
            }
        }
    }
}
