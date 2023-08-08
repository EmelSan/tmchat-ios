//
//  NoContentTbCell.swift
//  tmchat
//
//  Created by Shirin on 4/18/23.
//

import UIKit
import EasyPeasy

class NoContentTbCell: UITableViewCell {

    static let id = "NoContentTbCell"
    
    let title = UILabel(font: .sb_16_r,
                        color: .lee,
                        alignment: .center,
                        numOfLines: 0,
                        text: "no_posts".localized())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(title)
        title.easy.layout([
            Top(20), Trailing(20), Leading(20), Bottom(20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
