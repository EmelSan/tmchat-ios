//
//  MessageTable.swift
//  tmchat
//
//  Created by Shirin on 3/24/23.
//

import Foundation
import GRDB

class MessageTable {
    
    static var shared: MessageTable!
    
    var tableName: String = "message"

    var dbPool: DatabasePool!
    
    init(_ dbPool: DatabasePool) {
        self.dbPool = dbPool
        MessageTable.shared = self
    }
    
    func getRoomMsgs(room: Room?) -> [Message] {
        guard let room = room else { return [] }
        
        do {
            return try dbPool.read { db in
                return try room.messages.fetchAll(db)
            }
        } catch {
            debugPrint("getRoomMsgs")
            debugPrint(error)
        }
        
        return []
    }
    
    func getMediMsgs(room: Room?) -> [Message] {
        guard let room = room else { return [] }
        
        do {
            return try dbPool.read { db in
                return try room.messages.fetchAll(db)
            }
        } catch {
            debugPrint("getRoomMsgs")
            debugPrint(error)
        }
        
        return []
    }
    

    func getMsg(id: Int64?) -> Message {
        guard let id = id else { return Message.emptyMsg }
        
        do {
            return try dbPool.read { db in
                return try Message.fetchOne(db, key: id)  ?? Message.emptyMsg
            }
        } catch {
            debugPrint("getMsg")
            debugPrint(error)
            return Message.emptyMsg
        }
    }
    
    func insert(msg: Message?) -> Message? {
        guard var msg = msg else { return nil }
        do {
            let msg = try dbPool.write { db in
                try msg.save(db)
                RxSubjects.msgUpsert.onNext(msg)
                return msg
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                self.updateMsgToError(msgId: msg.id)
            }
            
            return msg
        } catch {
            debugPrint("insert msg")
            debugPrint(error)
            return nil
        }
    }
    
    func deleteMsgs(msgs: [Int64]){
        do {
            try dbPool.write { db in
                msgs.forEach({ id in
                    let _ = try? Message.filter(Message.Columns.id == id).deleteAll(db)
                })
            }
        } catch {
            debugPrint("insert msg")
            debugPrint(error)
        }
    }


    func upsertMsg(msg: Message?){
        guard var msg = msg else { return }
        msg.id = msg.id == 0 ? nil : msg.id
        do {
            try dbPool.write { db in
                let oldMsg = try Message.filter(Message.Columns.id == msg.id || Message.Columns.UUID == msg.UUID).fetchOne(db)
                
                msg.roomId = oldMsg?.roomId == nil
                            ?  try? Room.filter(Room.Columns.uuid == msg.roomUUID).fetchOne(db)?.id
                            : oldMsg?.roomId
                
                msg.localPath = (msg.localPath ?? "").isEmpty
                                ? oldMsg?.localPath
                                : msg.localPath

                msg.id = oldMsg?.id
                try msg.save(db)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    RxSubjects.msgUpsert.onNext(msg)
                }
            }
        } catch {
            debugPrint("upsertMsg")
            debugPrint(error)
        }
    }

    func upsertMsgs(msgs: [Message]){
        do {
            try dbPool.write { db in
                
                try msgs.forEach { msg1 in
                    var msg = msg1
                    msg.id = msg.id == 0 ? nil : msg.id
                    
                    let oldMsg = try Message.filter(Message.Columns.id == msg.id || Message.Columns.UUID == msg.UUID).fetchOne(db)
                    
                    msg.roomId = oldMsg?.roomId == nil
                                ?  try? Room.filter(Room.Columns.uuid == msg.roomUUID).fetchOne(db)?.id
                                : oldMsg?.roomId
                
                    msg.id = oldMsg?.id
                    try msg.save(db)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                    RxSubjects.updateRooms.onNext(())
                }
            }
        } catch {
            debugPrint("upsertMsgs")
            debugPrint(error)
        }
    }

    
    func updateRoomUUID(roomId: Int64?, roomUUID: String){
        do {
            try dbPool.write { db in
                let oldMsgs = try Message.filter(Message.Columns.roomId == roomId).fetchAll(db)
                try oldMsgs.forEach { msg in
                    var msg = msg
                    msg.roomUUID = roomUUID
                    try msg.update(db)
                }
            }
        } catch {
            debugPrint("updateRoomUUID")
            debugPrint(error)
        }
    }

    func updateToError(){
        do {
            try dbPool.write { db in
                let messages = try Message.fetchAll(db)
                
                try messages.forEach { msg in
                    var msg = msg
                    if msg.status == MsgStatus.local.rawValue {
                        msg.status = MsgStatus.error.rawValue
                        try msg.save(db)
                    }
                }
            }
            
        } catch {
            debugPrint("updateToError")
            debugPrint(error)
        }
    }
    
    func updateLocalPath(id: Int64?, localPath: String){
        guard let id = id else { return }
        do {
            try dbPool.write { db in
                guard var message = try Message.filter(Message.Columns.id == id).fetchOne(db) else { return }
                message.localPath = localPath
                try message.update(db)
                RxSubjects.msgUpsert.onNext(message)
            }
        } catch {
            debugPrint("updateLocalPath")
            debugPrint(error)
        }
    }

    func updateMsgToError(msgId: Int64?) {
        guard let id = msgId else { return }
        do {
            try dbPool.write { db in
                guard var msg = try Message.filter(key: id).fetchOne(db) else { return }
                if msg.status == MsgStatus.local.rawValue {
                    msg.status = MsgStatus.error.rawValue
                    try msg.save(db)
                    RxSubjects.msgUpsert.onNext(msg)
                }
            }
        } catch {
            debugPrint("updateRoomUUID")
            debugPrint(error)
        }
    }

    
    func updateMsgToDelivered(msgId: String?) {
        guard let id = msgId else { return }
        do {
            try dbPool.write { db in
                guard var msg = try Message.filter(Message.Columns.UUID == id).fetchOne(db) else { return }
                if msg.status == MsgStatus.inServer.rawValue {
                    msg.status = MsgStatus.delivered.rawValue
                    try msg.save(db)
                    RxSubjects.msgUpsert.onNext(msg)
                }
            }
        } catch {
            debugPrint("updateRoomUUID")
            debugPrint(error)
        }
    }

    func readRoomMsg(date: String, roomId: String?, readMy: Bool = false, status: MsgStatus = .read) {
        guard let id = roomId else { return }
        do {
            try dbPool.write { db in
                let unreadMsgs = try Message.filter(Message.Columns.roomUUID == id)
                                            .filter(Message.Columns.date <= date)
                                            .filter(Message.Columns.status <= MsgStatus.delivered.rawValue)
                                            .filter(readMy ?
                                                    Message.Columns.senderUUID == AccUserDefaults.id
                                                    : Message.Columns.senderUUID != AccUserDefaults.id  )
                                            .fetchAll(db)

                try unreadMsgs.forEach { msg in
                    var msg = msg
                    msg.status = status.rawValue
                    try msg.save(db)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                RxSubjects.roomRead.onNext((date: date,
                                            roomId: id))
            }
        } catch {
            debugPrint("readRoomMsg")
            debugPrint(error)
        }
    }    
}
