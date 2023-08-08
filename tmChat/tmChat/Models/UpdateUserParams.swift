//
//  UpdateUserParams.swift
//  tmchat
//
//  Created by Shirin on 3/22/23.
//

import Foundation

struct UpdateUserParams: Codable {
    var username: String? 
    var firstName: String?
    var lastName: String?
    var description: String?
}
