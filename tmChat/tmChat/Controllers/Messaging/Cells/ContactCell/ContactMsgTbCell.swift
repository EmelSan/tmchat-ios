//
//  ContactMsgTbCell.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit

class ContactMsgTbCell: MsgTbCell {
    
    static let id = "ContactMsgTbCell"

    var content = FileMsgContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupData(message: Message) {
        content.setupForContactCell()
        msgView.addMsgContentView(isOwn: true, content: content)
        super.setupData(message: message)
    }
}
