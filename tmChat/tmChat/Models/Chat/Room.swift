//
//  ChatListData.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import Foundation
import GRDB

struct Room: Codable, Equatable {
    var id: Int64?
    var uuid: String?
    var type: RoomType.RawValue?
    var isNotificationEnabled: Bool?
    var isChatRequest: Bool?
    
    var roomName: String?
    var userId: String?
    var username: String?
    var avatar: String?
    var colorCode: String?
    var lastLoginAt: String?
    var isActive: Bool?
    var draft: String?

//    var message: Message?
//    var unreadMessages: [Message]?
//    var unreadCount: Int?

    var roomId: String?
    
    init(user: User) {
        type = RoomType.private.rawValue
        roomName = user.username
        userId = user.id
        username = user.username
        avatar = user.avatar
        colorCode = user.colorCode
        lastLoginAt = user.lastLoginAt
        isActive = user.isActive
    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try? values.decode(Int64.self, forKey: .id)
//        uuid = try? values.decode(String.self, forKey: .uuid)
//        type = try? values.decode(String.self, forKey: .type)
//        notification = try? values.decode(Int.self, forKey: .notification)
//        isChatRequest = try? values.decode(Bool.self, forKey: .isChatRequest)
//        roomName = try? values.decode(String.self, forKey: .roomName)
//        userId = try? values.decode(String.self, forKey: .userId)
//        username = try? values.decode(String.self, forKey: .username)
//        avatar = try? values.decode(String.self, forKey: .avatar)
//        colorCode = try? values.decode(String.self, forKey: .colorCode)
//        lastLoginAt = try? values.decode(String.self, forKey: .lastLoginAt)
//        isActive = try? values.decode(Bool.self, forKey: .isActive)
//        unreadCount = try? values.decode(Int.self, forKey: .unreadCount)
//        draft = try? values.decode(String.self, forKey: .draft)
//    }

    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["uuid"] = uuid
        container["type"] = type
        container["isNotificationEnabled"] = isNotificationEnabled
        container["isChatRequest"] = isChatRequest
        container["roomName"] = roomName
        container["userId"] = userId
        container["username"] = username
        container["avatar"] = avatar
        container["colorCode"] = colorCode
        container["lastLoginAt"] = lastLoginAt
        container["isActive"] = isActive
        container["draft"] = draft
    }
}

extension Room: FetchableRecord { }

extension Room: MutablePersistableRecord {
    enum Columns: String, ColumnExpression {
        case id
        case uuid
        case type
        case isNotificationEnabled
        case isChatRequest
        case roomName
        case userId
        case username
        case avatar
        case colorCode
        case lastLoginAt
        case isActive
        case draft
    }
  
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension Room: TableRecord, EncodableRecord  {
    static let messages = hasMany(Message.self)
    

    var messages: QueryInterfaceRequest<Message> {
        return request(for: Room.messages).order(Message.Columns.date.asc).reversed()
    }
}
