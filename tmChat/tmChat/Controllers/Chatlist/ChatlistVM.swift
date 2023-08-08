//
//  ChatlistVM.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import Foundation
import RxSwift

class ChatlistVM {
    
    var data: Binder<[RoomInfo]> = Binder(RoomTable.shared.getRooms())
    
    var disposeBag = DisposeBag()
    
    func subscribe(){
        RxSubjects.updateRooms.subscribe(onNext: { [weak self] in
            self?.data.value = RoomTable.shared.getRooms()
        }).disposed(by: disposeBag)
        
        RxSubjects.insertRoom.subscribe(onNext: { [weak self] newRoom in
            self?.data.value.removeAll(where: {$0.room.id == newRoom.room.id})
            self?.data.value.insert(newRoom, at: 0)
        }).disposed(by: disposeBag)

        RxSubjects.updateRoom.subscribe(onNext: { [weak self] newRoom in
            guard let ind = self?.data.value.firstIndex(where: {$0.room.id == newRoom.room.id}) else { return }
            self?.data.value[ind] = newRoom
        }).disposed(by: disposeBag)

        RxSubjects.msgUpsert.subscribe(onNext: { [weak self] msg in
            var _ = self?.data.value.removeAll(where: { $0.room.id == msg.roomId})
            guard let roomInfo = RoomTable.shared.getRoom(uuid: msg.roomUUID ?? "\(msg.roomId ?? 0)") else { return }
            self?.data.value.insert(roomInfo, at: 0)
        }).disposed(by: disposeBag)
        
        RxSubjects.roomRead.subscribe(onNext: { [weak self] _, roomId in
            guard let roomInfo = RoomTable.shared.getRoom(uuid: roomId) else { return }
            guard let ind = self?.data.value.firstIndex(where: {$0.room.uuid == roomId}) else { return }
            self?.data.value[ind] = roomInfo
        }).disposed(by: disposeBag)
    }
    
    func readRoom(room: Room){
        let data = ReadMsg(roomId: room.uuid ?? "",
                            date: Date().getTimeStamp() )
        
        SocketClient.shared.sendRead(data: data)
    }

    func deleteRoom(room: Room){
        data.value.removeAll(where: {$0.room.id == room.id})
        let removed = RoomTable.shared.deleteRoom(uuid: "\(room.id ?? 0)")
        guard let uuid = room.uuid else { return }
        ChatRequests.shared.deleteRoom(roomId: uuid) { resp in
            guard let _ = resp?.success else {
                PopUpLauncher.showErrorMessage(text: "could_not_delete".localized())
                let _ = RoomTable.shared.insert(room: removed)
                return
            }
        }
    }
    
    func toggleNotification(room: Room){
//        data.value.removeAll(where: {$0.room.id == room.id})
//        let removed = RoomTable.shared.deleteRoom(uuid: "\(room.id ?? 0)")
//        guard let uuid = room.uuid else { return }
        guard let uuid = room.uuid else { return }
        ChatRequests.shared.toggleNotification(roomId: uuid) { [weak self] resp in
            if resp?.success == true {
                guard let ind = self?.data.value.firstIndex(where: {$0.room.uuid == uuid}) else { return }
                self?.data.value[ind].room.isNotificationEnabled = !(self?.data.value[ind].room.isNotificationEnabled ?? false)
            }
        }
    }
}
