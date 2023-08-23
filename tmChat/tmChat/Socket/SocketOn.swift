//
//  SocketOn.swift
//  tmchat
//
//  Created by Shirin on 4/1/23.
//

import Foundation

class SocketOn {
    
    static let shared = SocketOn()
    
    func setupOn(_ text: String){
        guard let event = getDict(text: text)?["event"] as? String else { return }
        setupEvents(event: SocketOns(rawValue: event), text: text)
    }
    
    private func setupEvents(event: SocketOns?, text: String){
        guard let event = event else { return }
        
        guard let data = text.data(using: .utf8) else { return }
        let decoder = JSONDecoder()

        NotificationCenter.default.post(name: .socketClientDidReceiveEvent, object: data)

        switch event {
        case .connection:
            do {
                let data = try decoder.decode(SocketEvent<[Message]>.self, from: data)
                MessageTable.shared.upsertMsgs(msgs: data.data)
            } catch {
                debugPrint(error)
            }

        case .userConnected:
            let data = try? decoder.decode(SocketEvent<UserConnection>.self, from: data)
            RoomTable.shared.updateStatus(data: data?.data)
            
        case .userDisconnected:
            let data = try? decoder.decode(SocketEvent<UserConnection>.self, from: data)
            RoomTable.shared.updateStatus(data: data?.data)

        case .newSentMsg, .newMsg:
            do {
                let data = try decoder.decode(SocketEvent<Message>.self, from: data)
                MessageTable.shared.upsertMsg(msg: data.data)
            } catch {
                debugPrint(error)
            }

        case .roomRequest:
            guard let data = try? decoder.decode(SocketEvent<Room>.self, from: data) else { return }
            let _ = RoomTable.shared.upsertRoom(room: data.data)

        case .roomDeleted:
            guard let data = try? decoder.decode(SocketEvent<[String: String]>.self, from: data) else { return }
            let uuid = data.data["roomId"]
            let _ = RoomTable.shared.deleteRoom(uuid: uuid)
//            print(RoomTable.shared.deleteRoom(uuid: uuid))
            RxSubjects.updateRooms.onNext(())
            
        case .readStatus:
            guard let data = try? decoder.decode(SocketEvent<ReadMsg>.self, from: data) else { return }
            if data.data.lastReadAt != nil {
                MessageTable.shared.readRoomMsg(date: data.data.lastReadAt ?? Date().getTimeStamp(),
                                                roomId: data.data.roomId,
                                                readMy: true)
            }
            
        case .deliveredStatus:
            guard let data = try? decoder.decode(SocketEvent<DeliveredMsg>.self, from: data) else { return }
            MessageTable.shared.updateMsgToDelivered(msgId: data.data.messageId)

        case .msgDeleted:
            print("msgDeleted ")
            
        case .unreadCount:
            print("unreadCount")

        case .read:
            print("read")

        case .delete:
            print("delete")
        case .sendSdp:
            print("send_sdp")
        }
    }
    
    private func getDict(text: String) -> [String: Any]? {
        let data = text.data(using: .utf8)!

        guard let dict = try? JSONSerialization.jsonObject(with: data, options : .allowFragments)
                                                as? [String: Any]  else {
            print("Couldnot decode on json")
            print(text)
            return nil
        }

        return dict
    }
}
