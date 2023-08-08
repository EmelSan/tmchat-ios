//
//  TextMsgTbCell.swift
//  tmchat
//
//  Created by Shirin on 3/20/23.
//

import UIKit

class TextMsgTbCell: MsgTbCell {

    static let id = "TextMsgTbCell"

    var content = TextMsgContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setupData(message: Message) {
        content.msgText.text = message.content
        content.msgText.setContentCompressionResistancePriority(.required, for: .horizontal)
        content.msgStack.subviews.forEach({$0.removeFromSuperview()})
        content.status.setup(message.status)
        content.setupWithNormalDate()
        
        if message.repliedToMessage == nil {
            content.repliedMsgView.removeFromSuperview()
        } else {
            content.contentStack.insertArrangedSubview(content.repliedMsgView, at: 0)
            content.repliedMsgView.setupData(msg: message.repliedToMessage!)
        }
        
        msgView.addMsgContentView(isOwn: message.senderUUID == AccUserDefaults.id,
                                  content: content)
        
        super.setupData(message: message)
    }
}
