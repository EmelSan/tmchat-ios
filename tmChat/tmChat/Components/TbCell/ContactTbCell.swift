//
//  ContactTbCell.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import UIKit
import EasyPeasy

class ContactTbCell: UITableViewCell {

    static let id = "ContactTbCell"
    
    let contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10)
    
    let dataStack = UIStackView(axis: .horizontal,
                                alignment: .fill,
                                spacing: 10,
                                edgeInsets: UIEdgeInsets(horizontalEdges: 16))
    
    let profileImg = ProfileImg(size: 34)
    
    let textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 2)
    
    let name = UILabel(font: .text_14_m,
                       numOfLines: 1,
                       text: "name goes here")
    
    let desc = UILabel(font: .text_14_r,
                       color:  .lee,
                       numOfLines: 1,
                       text: "subtitle goes here")
    
    let checkbox = CheckBtn(title: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        checkbox.isUserInteractionEnabled = false
        profileImg.clipsToBounds = true
        
        setupView()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())
    }
    
    func setupContent(){
        contentStack.addArrangedSubviews([seperator(),
                                          dataStack,
                                          UIView()])
        
        dataStack.addArrangedSubviews([profileImg,
                                       textStack,
                                       UIView(),
                                       checkbox])

        textStack.addArrangedSubviews([name, desc])
    }
    
    func seperator()-> UIView {
        let v = UIView()
        v.easy.layout(Height(1))
        v.backgroundColor = .onBg
        return v
    }
    
    func setupData(data: User?){
        guard let data = data else { return }
        profileImg.setupData(data: data)
        name.text = data.username
        desc.text = data.phone ?? ""
    }
}
