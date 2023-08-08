//
//  Enums.swift
//  tmchat
//
//  Created by Shirin on 3/17/23.
//

import Foundation

enum SocketOns: String {
    case connection = "connection"
    case userConnected = "userConnected"
    case roomRequest = "roomRequest"
    case userDisconnected = "userDisconnected"
    case newSentMsg = "messageCreated"
    case newMsg = "newMessage"
    case readStatus = "messageStatusRead"
    case deliveredStatus = "messageStatusDelivered"
    case msgDeleted = "messageStatusDeleted"
    case roomDeleted = "roomDeleted"

    case unreadCount = "unreadMessageCount"
    case delete = "messageDelete"
    case read = "messageRead"

}

enum SocketEmits: String {
    case new = "newMessage"
    case read = "messageRead"
    case deleteMsg = "messageDelete"
}


enum RoomType: String {
    case `private` = "private"
    case `public` = "`public`"
    case group = "group"
}

enum RoomStatus: String {
    case `private` = "private"
}

enum MsgType: String, CaseIterable {
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case file = "FILE"
    case music = "MUSIC"
    case voice = "AUDIO"
    
    static let uploadMsgTypes = [MsgType.image.rawValue,
                                 MsgType.video.rawValue,
                                 MsgType.file.rawValue,
                                 MsgType.music.rawValue,
                                 MsgType.voice.rawValue]
}

enum MsgStatus: String {
    case error = "error"
    case local = "local"
    case inServer = "in_server"
    case delivered = "delivered"
    case read = "read"
}

enum NoSmthType {
    case connection
    case content
}

enum PostPermissionType: String {
    case all = "ALL"
    case contacts = "CONTACTS"
    case nobody = "NOBODY"
}

enum Lang: String {
    case tk = "tk"
    case ru = "ru"
    case en = "en"
}


