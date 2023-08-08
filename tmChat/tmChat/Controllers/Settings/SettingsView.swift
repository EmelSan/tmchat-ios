//
//  SettingsView.swift
//  tmchat
//
//  Created by Shirin on 4/17/23.
//

import UIKit
import EasyPeasy

class SettingsView: BaseView {

    var contetnStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    
    var header = Header(title: "settings".localized())
    
    var tableView = UITableView(style: .grouped,
                                rowHeight: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(SettingsTbCell.self, forCellReuseIdentifier: SettingsTbCell.id)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contetnStack)
        contetnStack.easy.layout([
            Top(),
            Bottom().to(safeAreaLayoutGuide, .bottom),
            Leading(), Trailing()
        ])
        
        contetnStack.addArrangedSubviews([header,
                                          tableView])
    }
}
