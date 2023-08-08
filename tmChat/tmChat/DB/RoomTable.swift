//
//  RoomTable.swift
//  tmchat
//
//  Created by Shirin on 3/28/23.
//

import Foundation
import GRDB

class RoomTable {
    
    static var shared: RoomTable!
    
    var tableName: String = "room"

    private var dbPool: DatabasePool!
    
    init(_ dbPool: DatabasePool) {
        self.dbPool = dbPool
        RoomTable.shared = self
    }
    
    func getRooms() -> [RoomInfo] {
        do {
            return try dbPool.read { db in
                var rooms = try RoomInfo.request.fetchAll(db)
                rooms.removeAll(where: {$0.lastMessage == nil})
                return rooms
            }
            
        } catch {
            debugPrint("getRooms")
            debugPrint(error)
            return []
        }
    }
    
    func getRoom(id: Int64?) -> RoomInfo? {
        guard let id = id else { return nil }
        do {
            return try dbPool.read { db in
                return try RoomInfo.request.filter(key: id).fetchOne(db)
            }
            
        } catch {
            debugPrint("getRoom id")
            debugPrint(error)
            return nil
        }
    }
    
    func getRoom(uuid: String?) -> RoomInfo? {
        guard let uuid = uuid else { return nil }
        do {
            return try dbPool.read { db in
                return try RoomInfo.request.filter(Room.Columns.uuid == uuid || Room.Columns.id == uuid).fetchOne(db)
            }
            
        } catch {
            debugPrint("getRoom uuid")
            debugPrint(error)
            return nil
        }
    }
    
    func get(userId: String?) -> Room? {
        guard let userId = userId else { return nil  }
        
        do {
            return try dbPool.read { db in
                return try Room.filter(Room.Columns.userId == userId).fetchOne(db)
            }
            
        } catch {
            debugPrint("insert")
            debugPrint(error)
            return nil
        }
    }


    func insert(room: Room?) -> Room? {
        guard var room = room else { return nil  }
        
        do {
            return try dbPool.write { db in
                room.id = try Room.filter(Room.Columns.uuid == room.uuid).fetchOne(db)?.id
                try room.save(db)
                RxSubjects.insertRoom.onNext(RoomInfo(room: room, unreadCount: 0))
                return room
            }
            
        } catch {
            debugPrint("insert")
            debugPrint(error)
            return nil
        }
    }
    
    func deleteRoom(uuid: String?) -> Room? {
        guard let roomId = uuid else { return nil }
        
        do {
            let _ = try dbPool.write { db in
                print(try Room.filter(Room.Columns.id == roomId || Room.Columns.uuid == roomId).fetchAll(db))
                return try Room.filter(Room.Columns.id == roomId || Room.Columns.uuid == roomId).deleteAll(db)
            }
            
        } catch {
            debugPrint("deleteRoom")
            debugPrint(error)
        }
        
        return nil
    }
    

    func upsertRoom(room: Room?) -> Int64? {
        guard var room = room else { return nil }
        room.id = nil
        do {
            return try dbPool.write { db in
                
                let oldRoom = try Room.filter(Room.Columns.uuid == room.uuid).fetchOne(db)
                
                room.id = oldRoom?.id
                try room.save(db)
                
                guard let roomInfo = try RoomInfo.request.filter(Room.Columns.uuid == room.uuid).fetchOne(db) else {
                    return room.id
                }
                
                RxSubjects.insertRoom.onNext(roomInfo)
                return room.id
            }
        } catch {
            debugPrint("upsertRooms")
            debugPrint(error)
            return nil
        }
    }
    

    func upsertRooms(rooms: [Room]){
        do {
            try dbPool.write { db in
                
                try rooms.forEach { room in
                    var room = room
                    
                    let oldRoom = try Room.filter(Room.Columns.uuid == room.uuid).fetchOne(db)
                    
                    room.id = oldRoom?.id
                    if oldRoom?.draft != nil && room.draft == nil {
                        room.draft = oldRoom?.draft
                    }
                    try room.save(db)
                }
            }
            
            RxSubjects.updateRooms.onNext(())
            
        } catch {
            debugPrint("upsertRooms")
            debugPrint(error)
        }
    }
    
    func updateUUID(id: Int64, uuid: String){
        do {
            try dbPool.write { db in
                var room = try Room.filter(Room.Columns.id == id).fetchOne(db)
                room?.uuid = uuid
                room?.roomName = "customm "
                try room?.update(db, columns: [Room.Columns.uuid])
            }
            
        } catch {
            debugPrint("updateStatus")
            debugPrint(error)
        }
    }
    

    func updateStatus(data: UserConnection?){
        guard let data = data else { return }

        do {
            try dbPool.write { db in
                guard var room = try Room.filter(Room.Columns.userId == data.userId)
                                    .fetchOne(db) else { return }

                if data.lastActiveAt == nil {
                    room.isActive = true
                } else {
                    room.isActive = false
                    room.lastLoginAt = data.lastActiveAt
                }

                try room.update(db)
                
                guard let roomInfo = try RoomInfo.request.filter(key: room.id).fetchOne(db) else { return }
                RxSubjects.updateRoom.onNext(roomInfo)
            }
            
        } catch {
            debugPrint("updateStatus")
            debugPrint(error)
        }
    }
    
    func updateDraft(id: Int64?, draft: String?){
        guard let id = id else { return }
        
        do {
            try dbPool.write { db in
                guard var room = try Room.filter(key: id).fetchOne(db) else { return }

                room.draft = draft
                try room.update(db)
                
                guard let roomInfo = try RoomInfo.request.filter(key: room.id).fetchOne(db) else { return }
                RxSubjects.updateRoom.onNext(roomInfo)
            }
            
        } catch {
            debugPrint("updateStatus")
            debugPrint(error)
        }
    }
   
    func makeAllOfline(){
        do {
            try dbPool.write { db in
                let rooms = try Room.filter(Room.Columns.isActive == true).fetchAll(db)
                
                try rooms.forEach { room in
                    var room = room
                    room.isActive = false
                    try room.save(db)
                }
                
                RxSubjects.updateRooms.onNext(())
            }
            
        } catch {
            debugPrint("updateStatus")
            debugPrint(error)
        }
    }
    
    func deleteAll(){
        do {
            let _ = try dbPool.write { db in
                return try Room.deleteAll(db)
            }
        } catch {
            debugPrint("deleteAll")
            debugPrint(error)
        }
    }
}

