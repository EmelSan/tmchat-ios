//
//  SocektOnModels.swift
//  tmchat
//
//  Created by Shirin on 4/1/23.
//

import Foundation

struct UserConnection: Codable {
    var userId: String
    var lastActiveAt: String?
}

struct ReadMsg: Codable {
    var roomId: String
    var date: String?
    var lastReadAt: String?
}

struct DeliveredMsg: Codable {
    var roomId: String
    var messageId: String
}
