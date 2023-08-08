//
//  MediaMsgTbCell.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit

class MediaMsgTbCell: MsgTbCell {
    
    static let id = "MediaMsgTbCell"

    var content = MediaMsgContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupData(message: Message) {
        setupImg(msg: message)
        content.playIcon.isHidden = message.type != MsgType.video.rawValue
        content.size.text = ByteCountFormatter.string(fromByteCount: message.fileSize ?? 0,
                                                      countStyle: .file)

        
        msgView.addMsgContentView(isOwn: AccUserDefaults.id == message.senderUUID,
                                  content: content,
                                  withPadding: false)
        super.setupData(message: message)
    }
    
    func setupImg(msg: Message){
        if message.localPath?.isEmpty == false {
            content.img.kf.setImage(with: URL(fileURLWithPath: message.localPath ?? "")) { result in
                switch result {
                case .failure(_):
                    self.content.img.kf.setImage(with: URL(string: self.message.fileUrl ?? ""))
                case .success(_):
                    return
                }
            }
        } else {
            content.img.kf.setImage(with: URL(string: message.fileUrl ?? ""))
        }
    }
}
