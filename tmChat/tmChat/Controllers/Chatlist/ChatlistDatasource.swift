//
//  ChatlistDatasource.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit

class ChatlistDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: ChatlistDatasourceDelegate?
    
    var viewModel: ChatlistVM?
    
    var isMuted = true // to deleteeee
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.data.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTbCell.id, for: indexPath) as! ChatListTbCell
        cell.setupData(data: viewModel?.data.value[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.openMessaging(data: viewModel?.data.value[indexPath.row].room)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = viewModel?.data.value[indexPath.row]
        var actions: [UIContextualAction] = []

        if data?.unreadCount != 0 {
            let read = createAction(title: "read".localized(), iconName: "read-swipe", color: .accent, bgColor: .readColor) { [weak self] in
                self?.readClick(room: data?.room)
            }
            actions.append(read)
        }
              
        if data?.room.isNotificationEnabled == false {
            let mute = createAction(title: "mute".localized(), iconName: "speaker-off", color: .lee, bgColor: .muteColor) { [weak self] in
                self?.muteClick(room: data?.room)
            }
            actions.append(mute)

        } else {
            let unmuteAction = createAction(title: "unmute".localized(), iconName: "speaker-on", color: .lee, bgColor: .muteColor) { [weak self] in
                self?.unmuteClick(room: data?.room)
            }
            actions.append(unmuteAction)
        }

        let delete = createAction(title: "delete".localized(), iconName: "trash", color: .alert, bgColor: .deleteColor) { [weak self] in
            self?.deleteClick(room: data?.room)
        }
        
        actions.append(delete)

        let config = UISwipeActionsConfiguration(actions: actions.reversed())
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func readClick(room: Room?) {
        delegate?.readRoom(data: room)
    }
    
    func muteClick(room: Room?) {
        delegate?.muteFriend(data: room)
    }
    
    func unmuteClick(room: Room?) {
        delegate?.unmuteFriend(data: room)
    }

    func deleteClick(room: Room?) {
        delegate?.deleteRoom(data: room)
    }

    func createAction(title: String, iconName: String, color: UIColor, bgColor: UIColor, clickAction: (()->())? = nil ) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            clickAction?()
            completionHandler(true)
        }

        action.backgroundColor = bgColor
        action.image = UIImage(named: iconName)?.addTextToImage(title.localized(), color: color)
        return action
    }
}
