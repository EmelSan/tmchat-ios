//
//  SocketEvent.swift
//  tmchat
//
//  Created by Shirin on 3/30/23.
//

import Foundation

struct SocketEvent<T: Codable>: Codable {
    var event: String
    var data: T
}
