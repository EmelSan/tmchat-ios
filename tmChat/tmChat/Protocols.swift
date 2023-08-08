//
//  Protocols.swift
//  tmchat
//
//  Created by Shirin on 3/12/23.
//

import Foundation

protocol ChatlistDatasourceDelegate: AnyObject {
    func openMessaging(data: Room?)
    func openProfile(data: Room?)
    func readRoom(data: Room?)
    func deleteRoom(data: Room?)
    func muteFriend(data: Room?)
    func unmuteFriend(data: Room?)
}

protocol MsgCellDelegate: AnyObject {
    func swipe(data: Message)
    func longClick(data: Message)
    func replyClick(data: ShortMsg?)
    func selectionClick(isChecked: Bool, data: Message)
    func openMedia(data: Message)
    func openFile(data: Message)
}

protocol AttachmentDelegate: AnyObject {
    func takeImg()
    func openMediaPicker()
    func openFilePicker()
}

extension AttachmentDelegate {
    func openContactList() { }
    func openLocationPicker() { }
}

protocol MessagingActionsDelegate: AnyObject {
    func openChatProfile()
    func openSearch()
    func call()
    func clearRoom()
    func deleteRoom()
}

protocol ImageListDelegate: AnyObject {
    func imageClicked(_ atIndex: Int)
    func deleteClicked(_ atIndex: Int)
}

protocol ProfileMoreDelegate: AnyObject {
    func openEdit()
    func complain()
    func copyUsername()
}
