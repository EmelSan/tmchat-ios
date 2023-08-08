//
//  SearchVC.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import UIKit

class SearchVC: UIViewController {

    var viewModel = SearchVM()
    
    var mainView: SearchView {
        return view as! SearchView
    }

    override func loadView() {
        super.loadView()
        view = SearchView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setupBindings()
        setupCallbacks()
    }
    
    func setupBindings(){
        viewModel.data.bind { [weak self] _ in
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
        mainView.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.clearBtn.clickCallback = { [weak self] in
            self?.mainView.searchField.text = ""
        }
        
        mainView.editingCallback = { [weak self] search in
            self?.viewModel.getUsers(searchKey: search ?? "")
        }
        
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.viewModel.getUsers(searchKey: self?.mainView.searchField.text ?? "")
        }
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTbCell.id, for: indexPath) as! ContactTbCell
        cell.setupData(data: viewModel.data.value[indexPath.row])
        cell.checkbox.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MessagingVC()
        vc.viewModel.room = Room(user: viewModel.data.value[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
