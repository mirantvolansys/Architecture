//
//  UserListViewModel.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation

class UserListViewModel {
    var aryUsers = [User]()
    
    func getUsersList(forPage pageNumber: Int, success: @escaping([User]?) -> Void, failure: @escaping (Error) -> Void ) {
        
        let param: [String: Any] = ["page": pageNumber]
        
        networkManager.makeObjectRequest(forClass: UserResponse.self, requestMethod: .get, withApiUrl: API.usersList, params: param, success: { (userResponseObj) in
            print(userResponseObj)
            let userResponse = userResponseObj.result.value!
            //check the response status
            if userResponseObj.response?.statusCode == resultOK {
                if let usersList = userResponse.users {
                    // return users' list in success block
                    self.aryUsers.append(contentsOf: usersList.compactMap({ $0 }))
                    
                    success(self.aryUsers)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
}
