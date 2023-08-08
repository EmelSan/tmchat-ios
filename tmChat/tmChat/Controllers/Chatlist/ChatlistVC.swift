//
//  ChatlistVC.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import Differ

class ChatlistVC: UIViewController {

    var viewModel = ChatlistVM()
    var datasource = ChatlistDatasource()
    
    var sheetTransitioningDelegate = SheetTransitioningDelegate()
    
    var oldRooms: [RoomInfo] = []
    
    var mainView: ChatlistView {
        return view as! ChatlistView
    }

    override func loadView() {
        super.loadView()
        view = ChatlistView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.subscribe()
        oldRooms = viewModel.data.value

        datasource.delegate = self
        datasource.viewModel = viewModel
        mainView.tableView.delegate = datasource
        mainView.tableView.dataSource = datasource
        
        setupCallbacks()
        setupBindings()
    }

    func setupCallbacks(){
        SocketClient.shared.socketStatusChanged = { [weak self] isConnected in
            self?.mainView.socketStatusWrapper.isHidden = isConnected
        }
        
        mainView.header.search.clickCallback = { [weak self] in
            let vc = SearchVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            let vc = NotificationsVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.fabBtn.clickCallback = { [weak self] in
            let vc = ContactListVC()
            vc.type = .newChat
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupBindings(){
        viewModel.data.bind { [weak self] rooms in
            self?.mainView.tableView.animateRowChanges(oldData: self?.oldRooms ?? [],
                                                       newData: rooms,
                                                       deletionAnimation: .none,
                                                       insertionAnimation: .none)
            self?.oldRooms = rooms
            self?.mainView.noContent(rooms.isEmpty)
            self?.mainView.bringSubviewToFront(self!.mainView.fabBtn)
        }
    }
}


extension ChatlistVC: ChatlistDatasourceDelegate {
    func openMessaging(data: Room?) {
        let vc = MessagingVC()
        vc.viewModel.room = data
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func readRoom(data: Room?) {
        guard let room = data else { return }
        viewModel.readRoom(room: room)
    }
    
    func deleteRoom(data: Room?) {
        guard let room = data else { return }
        let vc = DeleteConfirmationBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.deleteBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.viewModel.deleteRoom(room: room)
        }
        present(vc, animated: true)
    }
    
    func openProfile(data: Room?) { }
    
    func muteFriend(data: Room?) {
        guard let room = data else { return }
        viewModel.toggleNotification(room: room)
    }
    
    func unmuteFriend(data: Room?) {
        guard let room = data else { return }
        viewModel.toggleNotification(room: room)
    }
}

