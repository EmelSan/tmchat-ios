//
//  FileListView.swift
//  tmchat
//
//  Created by Shirin on 3/23/23.
//

import UIKit
import EasyPeasy

class FileListView: BaseView {
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
                                          
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(FileTbCell.self, forCellReuseIdentifier: FileTbCell.id)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(tableView)
        tableView.easy.layout([
            Top(12), Leading(), Trailing(), Bottom()
        ])
    }
}
