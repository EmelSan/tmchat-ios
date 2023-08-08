//
//  MessagingDataSour.swift
//  tmchat
//
//  Created by Shirin on 3/10/23.
//

import UIKit

class MessagingDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var cellDelegate: MsgCellDelegate?
    
    weak var viewModel: MessagingVM?

    var isSelectionOpened = false

    var toAnimateSelection = false {
        didSet {
            if toAnimateSelection == false { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                self.toAnimateSelection = false
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.messages.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let msg = viewModel?.messages.value[indexPath.row] else { return UITableViewCell() }
        
        let index = indexPath.row
        var prev: Message?
        var next: Message?
        
        let count = viewModel?.messages.value.count ?? 0
        
        if index - 1 >= 0 {
            prev = self.viewModel?.messages.value[index - 1]
        }
        
        if index + 1 < count {
            next = self.viewModel?.messages.value[index + 1]
        }

        switch MsgType(rawValue: msg.type) ?? .text {
        case .text:
            var cell = tableView.dequeueReusableCell(withIdentifier: TextMsgTbCell.id, for: indexPath) as! TextMsgTbCell
            cell = setupCell(cell: cell, msg: msg, prevMsg: prev, nextMsg: next) as! TextMsgTbCell
            return cell

        case .image, .video:
            var cell = tableView.dequeueReusableCell(withIdentifier: MediaMsgTbCell.id, for: indexPath) as! MediaMsgTbCell
            cell = setupCell(cell: cell, msg: msg, prevMsg: prev, nextMsg: next) as! MediaMsgTbCell
            return cell

        case .file, .music:
            var cell = tableView.dequeueReusableCell(withIdentifier: FileMsgTbCell.id, for: indexPath) as! FileMsgTbCell
            cell = setupCell(cell: cell, msg: msg, prevMsg: prev, nextMsg: next) as! FileMsgTbCell
            return cell

        case .voice:
            var cell = tableView.dequeueReusableCell(withIdentifier: VoiceMsgTbCell.id, for: indexPath) as! VoiceMsgTbCell
            cell = setupCell(cell: cell, msg: msg, prevMsg: prev, nextMsg: next) as! VoiceMsgTbCell
            return cell
        }
    }
    
    func setupCell(cell: MsgTbCell,
                   msg: Message,
                   prevMsg: Message?,
                   nextMsg: Message?) -> MsgTbCell {
        var msg = msg
        
        if msg.repliedToMessage != nil {
            let senderName = msg.repliedToMessage?.senderUUID == AccUserDefaults.id ? AccUserDefaults.name : viewModel?.room?.roomName
            msg.repliedToMessage?.senderName = senderName
        }
        
        cell.message = msg
        cell.prevMessage = prevMsg
        cell.nextMessage = nextMsg
        cell.delegate = cellDelegate
        cell.setupData(message: msg)
        
        if isSelectionOpened {
            cell.openSelection(toAnimate: toAnimateSelection)
            cell.msgView.checkbox.isChecked = viewModel?.selectedMessages.contains(msg) == true
        }
        
        return cell
    }
}
