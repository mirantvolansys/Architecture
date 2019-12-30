//
//  Login.swift
//  MVC_Architecture
//
//  Created by Nirav Hathi on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation

struct Login {
    var token: String?
    var status: Int?
    var error: String?
    
    init(token: String?, status: Int, error: String?) {
        self.token = token
        self.status = status
        self.error = error
    }
}
