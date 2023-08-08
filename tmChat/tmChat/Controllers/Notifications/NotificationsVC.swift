//
//  NotificationsVC.swift
//  tmchat
//
//  Created by Shirin on 3/15/23.
//

import UIKit

class NotificationsVC: UIViewController {

    var viewModel = NotificationsVM()
    
    var mainView: NotificationsView {
        return view as! NotificationsView
    }

    override func loadView() {
        super.loadView()
        view = NotificationsView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self

        setupCallbacks()
    }

    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
//        mainView.clearBtn.clickCallback = { [weak self] in
//            print("clear")
//        }
    }
}

extension NotificationsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTbCell.id, for: indexPath) as! ChatListTbCell
        
        return cell
    }
}
