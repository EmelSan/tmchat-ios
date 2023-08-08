//
//  NotificationsView.swift
//  tmchat
//
//  Created by Shirin on 3/15/23.
//

import UIKit
import EasyPeasy

class NotificationsView: UIView {

    var topInsetBg = UIView()

    var header = Header(title: "notifications".localized())
    
    var tableView: UITableView = {
        let t = UITableView(rowHeight: UITableView.automaticDimension)
        t.register(ChatListTbCell.self, forCellReuseIdentifier: ChatListTbCell.id)
        t.separatorColor = .onBg
        t.separatorInset = UIEdgeInsets(horizontalEdges: 16)
        t.separatorStyle = .singleLine
        return t
    }()

    var clearBtn = TextBtn(title: "clear".localized())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(topInsetBg)
        topInsetBg.backgroundColor = .white
        topInsetBg.easy.layout([
            Top(), Leading(), Trailing(), Height(DeviceDimensions.topInset)
        ])
        
        addSubview(header)
        header.backgroundColor = .white
        header.easy.layout([
            Top().to(topInsetBg, .bottom), Leading(), Trailing(),
        ])
        
        addSubview(clearBtn)
        clearBtn.easy.layout([
            Bottom().to(safeAreaLayoutGuide, .bottom), Leading(), Trailing()
        ])
        
        addSubview(tableView)
        tableView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(clearBtn, .top)
        ])
    }
}
