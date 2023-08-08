//
//  Message.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import GRDB

struct Message: Identifiable, Hashable {
    var id: Int64?
    var UUID: String?

    var roomId: Int64?
    var roomUUID: String?
    var senderUUID: String
    var type: MsgType.RawValue
    var status: MsgStatus.RawValue
    var content: String
    var date: String
    
    var fileUrl: String?
    var fileSize: Int64?
    var duration: Int64?
    var repliedToMessage: ShortMsg?
    var localPath: String?
    
    static let emptyMsg = Message(roomId: -1,
                                  senderUUID: AccUserDefaults.id,
                                  type: MsgType.text.rawValue,
                                  status: MsgStatus.local.rawValue,
                                  content: "",
                                  date: Date().getTimeStamp())
}

extension Message: Codable, FetchableRecord, MutablePersistableRecord {

    enum Columns {
        static let id = Column(CodingKeys.id)
        static let UUID = Column(CodingKeys.UUID)
        static let roomId = Column(CodingKeys.roomId)
        static let roomUUID = Column(CodingKeys.roomUUID)
        static let senderUUID = Column(CodingKeys.senderUUID)
        static let type = Column(CodingKeys.type)
        static let status = Column(CodingKeys.status)
        static let content = Column(CodingKeys.content)
        static let date = Column(CodingKeys.date)
        static let fileUrl = Column(CodingKeys.fileUrl)
        static let fileSize = Column(CodingKeys.fileSize)
        static let duration = Column(CodingKeys.duration)
        static let repliedToMessage = Column(CodingKeys.repliedToMessage)
        static let localPath = Column(CodingKeys.localPath)
    }
  
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension Message: TableRecord {
    static let room = belongsTo(Room.self)

}
