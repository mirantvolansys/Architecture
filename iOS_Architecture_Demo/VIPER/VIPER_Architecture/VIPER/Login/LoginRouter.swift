//
//  LoginRouter.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 29/07/19.
//  Copyright © 2019 Mirant Patel. All rights reserved.
//

import Foundation
import UIKit

protocol LoginRouterProtocol {
    func pushToUserList(data : LoginEntity, fromView: UIViewController)
}

class LoginRouter:LoginRouterProtocol{

    /**
     Push controller to UserListViewController
     Parameters : -
        data -> Object of LoginEntity so you can fetch all login response details from this
        fromView -> controller from which we have to navigate
     */
    func pushToUserList(data : LoginEntity, fromView: UIViewController) {
        let vc : UserListViewController = getViewController(StoryBoard: .Main, Identifier: .UserListViewController) as! UserListViewController
        vc.loginData = data
        fromView.navigationController?.pushViewController(vc, animated: true)
    }
}
