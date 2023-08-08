//
//  MessagingVM.swift
//  tmchat
//
//  Created by Shirin on 3/10/23.
//

import Foundation
import RxSwift

//    to send Msg: 1) create local room if not exists
//                 2) insert message to local
//                 3) send room request and get room
//                 -- need to change room uuid of local message????
//                 4) emit message

class MessagingVM {
    
    var room: Room?
    
    var disposeBag = DisposeBag()
    
    var messages: Binder<[Message]> = Binder([])
    var popVc: Binder<Bool> = Binder(false)
    
    var selectedMessages: [Message] = []

    func subscribe(){
        RxSubjects.msgUpsert.subscribe(onNext: { [weak self] msg in
            guard let s = self else { return }
            
            if msg.roomId != s.room?.id { return }
            let ind = s.messages.value.firstIndex(where: {$0.id == msg.id })

            if ind == nil {
                s.messages.value.insert(msg, at: 0)
                
                if msg.status == MsgStatus.delivered.rawValue
                    && msg.senderUUID != AccUserDefaults.id {
                    self?.readRoom()
                }
                
            } else {
                s.messages.value[ind!] = msg
            }
            
        }).disposed(by: disposeBag)
        
        RxSubjects.roomRead.subscribe(onNext: { [weak self] (date, id) in
            guard let s = self else { return }
            if id != s.room?.uuid { return }
            s.messages.value = MessageTable.shared.getRoomMsgs(room: s.room)
        }).disposed(by: disposeBag)
        
        RxSubjects.updateRooms.subscribe(onNext: { [weak self] in
            guard let s = self else { return }
            s.room = RoomTable.shared.getRoom(id: s.room?.id)?.room
            s.popVc.value = s.room == nil
        }).disposed(by: disposeBag)
        
        
        RxSubjects.updateRoom.subscribe(onNext: { [weak self] newRoom in
            guard let s = self else { return }
            if s.room?.id != newRoom.room.id { return }
            s.room = newRoom.room
        }).disposed(by: disposeBag)
    }
    
    func sendMsg(_ msg: Message){
        let msg = insertMsg(msg)
        
        createRoom { uuid in
            if uuid == nil { return }
            MessageTable.shared.updateRoomUUID(roomId: self.room?.id, roomUUID: uuid!)
            let emit = self.getEmitMsg(msg)
            SocketClient.shared.sendMsg(emitMsg: emit)
        }
    }
    
    func uploadMsg(file: UploadImage, type: MsgType.RawValue){
        var msg = Message.emptyMsg
        msg.type = type
        msg.content = file.filename ?? ""
        msg.localPath = file.localPath ?? ""
        msg.fileSize = Int64(file.data?.count ?? 0)
        msg.duration = file.duration ?? 0
        msg = insertMsg(msg)
        
        createRoom { [self] uuid in
            if uuid == nil { return }
            MessageTable.shared.updateRoomUUID(roomId: room?.id, roomUUID: uuid!)

            ChatRequests.shared.uploadMedia(file: file,
                                            type: type,
                                            roomId: room?.uuid ?? "",
                                            msgId: "\(msg.id ?? 0)" )
            { [weak self] resp in
                guard let _ = self else { return }
                if resp?.success != true {
                    MessageTable.shared.updateMsgToError(msgId: msg.id)
                }
            }
        }
    }
    
    func readRoom(){
        guard let fMsg = messages.value.first else { return }

        if fMsg.senderUUID == AccUserDefaults.id
            && fMsg.status != MsgStatus.delivered.rawValue { return }
        
        let data = ReadMsg(roomId: room?.uuid ?? "",
                            date: fMsg.date )
        
        SocketClient.shared.sendRead(data: data)
    }
    
    func createLocalRoom() {
        guard let room = RoomTable.shared.insert(room: room) else { return }
        self.room = room
    }

    func createRoom(completionHandler: @escaping (String?)->() ) {
        if (room?.uuid ?? "")?.isEmpty == false {
            completionHandler(room?.uuid)
            return
        }
        
        guard let id = room?.userId else {
            completionHandler(nil)
            return
        }
        
        ChatRequests.shared.createRoom(userId: id) { [weak self] resp in
            guard let s = self else { return }
            s.room?.uuid = resp?.data?.uuid
            RoomTable.shared.updateUUID(id: s.room?.id ?? 0,
                                        uuid: s.room?.uuid ?? "")

            completionHandler(resp?.data?.uuid)
        }
    }
    
    func insertMsg(_ msg: Message) -> Message {
        var msg = msg
        
        if room?.id == nil {
            createLocalRoom()
        }

        msg.roomId = room?.id ?? -1
        msg.roomUUID = room?.uuid
        
        guard let insertedMsg = MessageTable.shared.insert(msg: msg) else {
            return Message.emptyMsg
        }
                
        return insertedMsg
    }
    
    func getEmitMsg(_ msg: Message, roomUUID: String? = nil) -> EmitMsg {
        let roomUUID = roomUUID == nil ? room?.uuid : roomUUID
        let emitMsg = EmitMsg(localId: msg.id ?? 0,
                              roomId: roomUUID ?? "",
                              type: msg.type,
                              content: msg.content,
                              fileUrl: msg.fileUrl,
                              fileSize: msg.fileSize,
                              duration: msg.duration,
                              repliedTo: msg.repliedToMessage?.UUID)

        return emitMsg
    }
    
    func deleteMsgs(){
        if selectedMessages.isEmpty { return }
        var ids: [Int64] = []
        var uuids: [String] = []
        
        selectedMessages.forEach { msg in
            messages.value.removeAll(where: { $0.id == msg.id })
            ids.append(msg.id!)
            if msg.UUID != nil {
                uuids.append(msg.UUID!)
            }
        }
        
        MessageTable.shared.deleteMsgs(msgs: ids)
        SocketClient.shared.sendMsgDelete(uuids: uuids)
    }
    
    func copyMsgs(){
        let copyString = selectedMessages.map({$0.content}).joined(separator: "\n")
        UIPasteboard.general.string = copyString
        PopUpLauncher.showSuccessMessage(text: "copied".localized())
    }
    
    func forwardMsgs(toUsers: [User], selectedMsgs: [Message]){
        if selectedMsgs.isEmpty || toUsers.isEmpty { return }
        
        toUsers.forEach { [weak self] user in
            ChatRequests.shared.createRoom(userId: user.id ?? "") { [weak self] resp in
                
                if var room = resp?.data {
                    room.id = RoomTable.shared.upsertRoom(room: room)

                    selectedMsgs.forEach { msg in
                        if !(msg.status == MsgStatus.error.rawValue
                            && MsgType.uploadMsgTypes.contains(where: {$0 == msg.type})){
                            self?.forwardMsg(msg: msg, room: room)
                        }
                    }
                }
            }
        }
    }
    
    func forwardMsg(msg: Message?, room: Room?){
        guard var msg = msg else { return }
        guard let room = room else { return }
        msg.id = nil
        msg.UUID = nil
        msg.senderUUID = AccUserDefaults.id
        msg.date = Date().getTimeStamp()
        msg.roomUUID = room.uuid
        msg.roomId = room.id
        guard let msgToEmit = MessageTable.shared.insert(msg: msg) else { return }
        SocketClient.shared.sendMsg(emitMsg: getEmitMsg(msgToEmit, roomUUID: room.uuid))
    }
}

