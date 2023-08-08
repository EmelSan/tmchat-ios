//
//  FileTbCell.swift
//  tmchat
//
//  Created by Shirin on 3/23/23.
//

import UIKit
import EasyPeasy

class FileTbCell: UITableViewCell {

    static let id = "FileTbCell"
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 6,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                            verticalEdges: 10))
    
    var iconBg: UIView = {
        let v = UIView()
        v.easy.layout(Size(44))
        v.layer.cornerRadius = 22
        v.backgroundColor = .accent
        return v
    }()
    
    var icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: 0,
                           image: UIImage(named: "trash-empty"),
                           backgroundColor: .clear)
        
    var textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 2)

    var name = UILabel(font: .sb_16_r,
                       numOfLines: 1,
                       text: "name goes here")

    var desc = UILabel(font: .text_14_m,
                       color:  .lee,
                       numOfLines: 1,
                       text: "subtitle goes here")

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([iconBg,
                                          textStack])
        
        textStack.addArrangedSubviews([name,
                                       desc])
        
        iconBg.addSubview(icon)
        icon.easy.layout([
            Size(20), Center()
        ])
    }
}
