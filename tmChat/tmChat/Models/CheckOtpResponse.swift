//
//  CheckOtpResponse.swift
//  tmchat
//
//  Created by Shirin on 3/22/23.
//

import Foundation

struct CheckOtpResponse: Codable {
    var user: User?
    var token: String
}
