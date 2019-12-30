//
//  Register.swift
//  MVC_Architecture
//
//  Created by Nirav Hathi on 30/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation

struct Register {
    var id: Int?
    var token: String?
    var status: Int?
    var error: String?
    
    init(id: Int?, token: String?, status: Int, error: String?) {
        self.token = token
        self.status = status
        self.error = error
        self.id = id
    }
}
