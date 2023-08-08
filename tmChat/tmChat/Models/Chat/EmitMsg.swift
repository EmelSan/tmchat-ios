//
//  EmitMsg.swift
//  tmchat
//
//  Created by Shirin on 3/29/23.
//

import Foundation

struct EmitMsg: Codable {
    var localId: Int64
    var roomId: String
    var type: MsgType.RawValue
    var content: String
    var fileUrl: String?
    var fileSize: Int64?
    var duration: Int64?
    var repliedTo: String?
}
