//
//  ContactListVC.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import UIKit

enum ContactListType {
    case newChat
    case list
    case forward
}

class ContactListVC: UIViewController {
    
    var viewModel = ContactListVM()
    
    var cellCount = 0
    
    var type = ContactListType.list
    var selectedContacts: [User] = []
    
    var mainView: ContactListView {
        return view as! ContactListView
    }

    override func loadView() {
        super.loadView()
        view = ContactListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self

        setupBindings()
        setupCallbacks()
        viewModel.getContacts(forPage: 1)
        
        if type == .forward {
            mainView.setupForSelection()
        }
    }
    
    func setupBindings(){
        viewModel.data.bind { [weak self] users in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noContent.bind { [weak self] toShow in
            self?.mainView.noContent(toShow)
        }

        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
    }

    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            self?.dismiss(animated: true)
        }
        
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.viewModel.getContacts(forPage: 1)
        }
    }
}

extension ContactListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount = viewModel.data.value.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTbCell.id, for: indexPath) as! ContactTbCell
        let user = viewModel.data.value[indexPath.row]
        cell.setupData(data: user)
        
        if type != .forward {
            cell.checkbox.isHidden = true
        } else {
            cell.checkbox.isHidden = false
            cell.checkbox.isChecked = selectedContacts.contains(where: {$0.id == user.id })
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.data.value[indexPath.row]
        switch type {
        case .newChat:
            let vc = MessagingVC()
            let room = RoomTable.shared.get(userId: user.id)
            vc.viewModel.room = room ?? Room(user: user)
            navigationController?.pushViewController(vc, animated: true)

        case .list:
            let vc = ProfileVC(type: .user(id: user.id ?? ""))
            navigationController?.pushViewController(vc, animated: true)

        case.forward:
            if selectedContacts.contains(where: {$0.id == user.id }) {
                selectedContacts.removeAll(where: {$0.id == user.id })
            } else {
                selectedContacts.append(user)
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != cellCount - 1 { return }
        viewModel.getContacts(forPage: viewModel.params.page + 1)
    }
}
