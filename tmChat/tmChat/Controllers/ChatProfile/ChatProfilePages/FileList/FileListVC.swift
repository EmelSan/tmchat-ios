//
//  FileListVC.swift
//  tmchat
//
//  Created by Shirin on 3/23/23.
//

import UIKit

class FileListVC: UIViewController {

    var mainView: FileListView {
        return view as! FileListView
    }

    override func loadView() {
        super.loadView()
        view = FileListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}


extension FileListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileTbCell.id, for: indexPath) as! FileTbCell
        
        return cell
    }
}
