//
//  Response.swift
//  tmchat
//
//  Created by Shirin on 3/8/23.
//

import Foundation

struct Response<T: Codable>: Codable {
    var success: Bool
    var code: Int
    var message: String?
    var data: T?
}

struct BaseResponse: Codable {
    var message: String?
}

struct Empty: Codable { }
