//
//  ContactListView.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import UIKit
import EasyPeasy

class ContactListView: BaseView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    
    var header = Header(title: "new_chat".localized())

    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    var footer = UIView()
    
    var footerStack = UIStackView(axis: .horizontal,
                                  alignment: .fill,
                                  spacing: 10,
                                  edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                           verticalEdges: 10))
    
    let sendBtn = ColoredBtn(title: "send".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(ContactTbCell.self, forCellReuseIdentifier: ContactTbCell.id)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        let _ = header.addBackground(color: .white,
                                     cornerRadius: .zero)
        
        addSubview(contentStack)
        contentStack.easy.layout([Edges()])
        
        contentStack.addArrangedSubviews([header,
                                          tableView])
    }
    
    func setupFooter(){
        footer.backgroundColor = .white
        
        footer.addSubview(footerStack)
        footerStack.easy.layout(Edges())
        
        sendBtn.easy.layout([
            Width(("send".localized().width(withConstrainedHeight: 40, font: .text_14_m!))+40)
            ])
        
        footerStack.addArrangedSubviews([UIView(),
                                         sendBtn])
    }
    
    func setupForSelection(){
        header.backBtn.setImage(UIImage(named: "close"), for: .normal)
        contentStack.addArrangedSubview(footer)
        setupFooter()
    }
}
