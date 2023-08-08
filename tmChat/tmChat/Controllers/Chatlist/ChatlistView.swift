//
//  ChatlistView.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class ChatlistView: BaseView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    var header = SearchHeader()
    
    var socketStatusWrapper = UIStackView(axis: .vertical,
                                          alignment: .center,
                                          spacing: 0,
                                          edgeInsets: UIEdgeInsets(horizontalEdges: 20, verticalEdges: 10) )
    
    var socketStatusView = UIStackView(axis: .horizontal,
                                       alignment: .center,
                                       spacing: 10)
    
    var socketLoading = UIActivityIndicatorView()
    
    var socketStatus = UILabel(font: .text_14_m,
                               color: .blade,
                               alignment: .center,
                               numOfLines: 1,
                               text: "updating".localized())
    
    var tableView: UITableView = {
        let t = UITableView(rowHeight: UITableView.automaticDimension)
        t.register(ChatListTbCell.self, forCellReuseIdentifier: ChatListTbCell.id)
        t.separatorColor = .onBg
        t.separatorInset = UIEdgeInsets(horizontalEdges: 16)
        t.separatorStyle = .singleLine
        return t
    }()
    
    let fabBtn = FabBtn(title: "new_chat".localized(), iconName: "pencil")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
        
        contentStack.addArrangedSubviews([header,
                                          socketStatusWrapper,
                                          tableView])
        
        addSubview(fabBtn)
        fabBtn.easy.layout([
            Trailing(14), Bottom(14).to(safeAreaLayoutGuide, .bottom)
        ])
        
        socketStatusWrapper.addArrangedSubview(socketStatusView)
        socketStatusView.addArrangedSubviews([socketLoading, socketStatus,])
        socketLoading.startAnimating()
        socketStatus.setContentHuggingPriority(.required, for: .horizontal)
    }
}
