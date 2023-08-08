//
//  RoomInfo.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import Foundation
import GRDB

struct RoomInfo: Codable, Equatable, FetchableRecord {
    var room: Room
    var lastMessage: Message?
    var unreadCount: Int
}

extension RoomInfo {
    static let latestMessageRequest = Message
            .annotated(with: max(Column("date")))
            .group(Column("roomId"))

    static let latestMessageCTE = CommonTableExpression(
            named: "lastMessage",
            request: latestMessageRequest)

    static let latestMessage = Room.association(
            to: latestMessageCTE,
            on: { chat, latestMessage in
                chat[Column("id")] == latestMessage[Column("roomId")]
            })
            .order(Column("date").desc)
    
    static let unreadMsg = Room.messages.filter(sql: "message.status == ? AND message.senderUUID <> ?", arguments: [MsgStatus.delivered.rawValue, AccUserDefaults.id])
    
    static let request = Room
            .with(latestMessageCTE)
            .including(optional: latestMessage)
            .annotated(with: unreadMsg.count.forKey("unreadCount"))
            .asRequest(of: RoomInfo.self)
}
