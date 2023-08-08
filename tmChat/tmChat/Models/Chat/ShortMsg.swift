//
//  ShortMsg.swift
//  tmchat
//
//  Created by Shirin on 3/29/23.
//

import Foundation

struct ShortMsg: Codable, Hashable {
    var UUID: String?
    var senderUUID: String?
    var type: MsgType.RawValue
    var content: MsgType.RawValue
    var fileUrl: String?
    var senderName: String?
}
