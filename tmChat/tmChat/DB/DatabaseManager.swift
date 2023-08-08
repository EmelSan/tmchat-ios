//
//  DatabaseManager.swift
//  tmchat
//
//  Created by Shirin on 3/24/23.
//

import GRDB

var dbPool: DatabasePool!

class DatabaseManager {

    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.eraseDatabaseOnSchemaChange = true

        migrator.registerMigration("createRoom") { db in
            try db.create(table: "room") { t in
                t.autoIncrementedPrimaryKey("id").primaryKey().unique(onConflict: .replace)
                t.column("uuid", .text)
                t.column("type", .text)
                t.column("isNotificationEnabled", .boolean)
                t.column("isChatRequest", .boolean)

                t.column("roomName", .text)
                t.column("userId", .text)
                t.column("username", .text)
                t.column("avatar", .text)
                t.column("colorCode", .text)
                t.column("lastLoginAt", .text)
                t.column("isActive", .boolean)
                t.column("draft", .text)
//                t.column("lastMsgId", .numeric)
            }
        }

        migrator.registerMigration("createMessage") { db in
            try db.create(table: "message") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("UUID", .text)
                t.column("roomId", .numeric).notNull().indexed().references("room", onDelete: .cascade)
                t.column("roomUUID", .text)
                t.column("senderUUID", .text)
                t.column("type", .text)
                t.column("status", .text)
                t.column("content", .text)
                t.column("date", .date)
                t.column("fileUrl", .text)
                t.column("fileSize", .numeric)
                t.column("duration", .numeric)
                t.column("repliedToMessage", .text)
                t.column("localPath", .text)
            }
        }


        return migrator
    }

    static func setup(for application: UIApplication) {
        do {
            let databaseURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("tm-chat.db")
            
            dbPool = try DatabasePool(path: databaseURL.path)
            try migrator.migrate(dbPool)
            
            let _ = MessageTable(dbPool)
            let _ = RoomTable(dbPool)
            
        } catch {
            debugPrint(error)
        }
    }
    
    static func drop(){
        RoomTable.shared.deleteAll()
    }
}
