//
//  UserListRouter.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright © 2019 Mirant Patel. All rights reserved.
//

import Foundation
import UIKit

protocol UserListRouterProtocol {
    func pushToUserDetail(data : UserListEntity, fromView: UIViewController)
}

class UserListRouter:UserListRouterProtocol{
    
    /**
     For push controller to Any other controller
     Parameters : -
        data -> Object of UserListEntity so you can fetch all user response details from this
        fromView -> controller from which we have to navigate
     */
    func pushToUserDetail(data : UserListEntity, fromView: UIViewController) {
            //Navigate if necessory
    }
    
}
