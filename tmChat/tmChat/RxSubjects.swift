//
//  RxSubjects.swift
//  tmchat
//
//  Created by Shirin on 3/23/23.
//

import Foundation
import RxSwift

class RxSubjects {
    
    static let openSelection: PublishSubject<Bool> = PublishSubject<Bool>.init()
    
    
    static let msgUpsert: PublishSubject<Message> = PublishSubject<Message>.init()
    static let roomRead: PublishSubject<(date: String, roomId: String)> = PublishSubject<(date: String, roomId: String)>.init()
    
    static let insertRoom: PublishSubject<(RoomInfo)> = PublishSubject<RoomInfo>.init()
    static let updateRoom: PublishSubject<(RoomInfo)> = PublishSubject<RoomInfo>.init()
    static let updateRooms: PublishSubject<Void> = PublishSubject<Void>.init()

}
