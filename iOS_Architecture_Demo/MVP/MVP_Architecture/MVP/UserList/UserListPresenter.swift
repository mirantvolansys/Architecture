//
//  UserListPresenter.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright (c) 2019 Mirant Patel. All rights reserved.
//

import UIKit

protocol UserListPresentationProtocol {
    func callUserListRequest()
}

class UserListPresenter: UserListPresentationProtocol {
    weak var viewController: UserListProtocol?
    
    // MARK: Functions
    
    /**
     In this, Presenter call api of user listing
     */
    func callUserListRequest() {
        self.callUserListApi()
    }
    
    /**
     User can call api and responds to method for user listing array
     */
    func callUserListApi() {
        networkManager.getRequest(relPath: "users") { (json, statusCode) in
            if statusCode == 200 {
                let objUserList = UserListEntity(dictionary: json as! NSDictionary)
                
                self.getUserListResponse(userData: objUserList!, errorString: nil)
            } else {
                self.getUserListResponse(userData: nil, errorString: (json as! Dictionary)["error"])
            }
        }
    }
    
    /**
     User can get list of user by this delegate method which we get from api
     Parameters : -
        userData -> Dictionary of user list response parameters
        errorString -> error string if any error in user list reponse
     */
    func getUserListResponse(userData : UserListEntity?, errorString : String?) {
        self.viewController?.updateUserList(userData: userData, errorString: errorString)
    }
}
