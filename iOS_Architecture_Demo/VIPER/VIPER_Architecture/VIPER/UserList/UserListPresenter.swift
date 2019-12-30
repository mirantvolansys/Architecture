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
    func getUserListResponse(userData : UserListEntity?, errorString : String?)
}

class UserListPresenter: UserListPresentationProtocol {
    weak var viewController: UserListProtocol?
    var interactor: UserListInteractorProtocol?
    var router: UserListRouterProtocol?
    
    // MARK: Delegate functions
    
    /**
     In this, Presenter ask Interactor for api call of user listing
     */
    func callUserListRequest() {
        self.interactor?.callUserListApi()
    }
    
    /**
     User can get list of user by this delegate method which we get from api and sent by interactor
     Parameters : -
        userData -> Dictionary of user list response parameters
        errorString -> error string if any error in user list reponse
     */
    func getUserListResponse(userData : UserListEntity?, errorString : String?) {
        self.viewController?.updateUserList(userData: userData, errorString: errorString)
    }
}
