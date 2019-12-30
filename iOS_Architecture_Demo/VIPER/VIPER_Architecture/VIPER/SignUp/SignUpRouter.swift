//
//  SignUpRouter.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 30/07/19.
//  Copyright © 2019 Mirant Patel. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpRouterProtocol {
    func pushToUserList(data : SignUpEntity, fromView: UIViewController)
}

class SignUpRouter: SignUpRouterProtocol{
    
    /**
     Push controller to UserListViewController
     Parameters : -
        data -> Object of SignUpEntity so you can fetch all sign up response details from this
        fromView -> controller from which we have to navigate
     */
    func pushToUserList(data : SignUpEntity, fromView: UIViewController) {
        let vc : UserListViewController = getViewController(StoryBoard: .Main, Identifier: .UserListViewController) as! UserListViewController
        vc.signUpData = data
        fromView.navigationController?.pushViewController(vc, animated: true)
    }
}
