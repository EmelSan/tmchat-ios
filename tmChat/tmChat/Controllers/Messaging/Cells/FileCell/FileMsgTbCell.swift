//
//  FileMsgTbCell.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit
import EasyPeasy

class FileMsgTbCell: MsgTbCell {

    static let id = "FileMsgTbCell"

    var content = FileMsgContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        content.fileStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupData(message: Message) {
        content.desc.text = ByteCountFormatter.string(fromByteCount: message.fileSize ?? 0, countStyle: .file)
        content.title.text = message.content
        
        msgView.addMsgContentView(isOwn: message.senderUUID == AccUserDefaults.id,
                                  content: content)
        
        content.progress.tag = Int(message.id ?? 1)
        super.setupData(message: message)
    }
    
    @objc func click(){
        if message.localPath == nil {
            content.progress.isAnimating = true
            DownloadService.shared.downloadFile(id: message.id ?? 0,
                                                filename: message.content,
                                                url: message.fileUrl ?? "")
        } else {
            delegate?.openFile(data: message)
        }
    }
}
