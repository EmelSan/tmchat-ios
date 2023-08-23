//
//  User.swift
//  tmchat
//
//  Created by Shirin on 3/22/23.
//

import Foundation

struct User: Codable {
    var id: String?
    var username: String?
    var phone: String?
    var firstName: String?
    var lastName: String?
    var description: String?
    var avatar: String?
    var colorCode: String?
    var lastLoginAt: String?
    var isActive: Bool?
    var roomUUID: String?
    var postCount: String?

    var fullName: String {
        [firstName ?? "", lastName ?? ""].joined(separator: " ").trimmingCharacters(in: .whitespaces)
    }

    var formattedUsername: String {
        guard let username else { return "" }
        guard String(username.dropFirst()) != "@" else { return username }

        return "@".appending(username)
    }
}

struct UserWrapper: Codable {
    var user: User
}
