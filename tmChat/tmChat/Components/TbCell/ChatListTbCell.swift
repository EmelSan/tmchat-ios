//
//  ChatListTbCell.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class ChatListTbCell: UITableViewCell {
    
    static let id = "ChatListTbCell"
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                            verticalEdges: 8))
    
    
    let profileImg = ProfileImg(size: 46)
    
    var textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 2)
    
    var firstLine = UIStackView(axis: .horizontal,
                                alignment: .center,
                                spacing: 4)
    
    var name = UILabel(font: .sb_16_m,
                       numOfLines: 1,
                       text: "name goes here")
    
    var msgStatus = MsgStatusView(frame: .zero)
    
    var date = UILabel(font: .minitext_12,
                       color:  .lee,
                       numOfLines: 1,
                       text: "12:00")
    
    
    var secondLine = UIStackView(axis: .horizontal,
                                 alignment: .top,
                                 spacing: 4)
    
    var media = UIImageView(contentMode: .scaleAspectFill,
                            cornerRadius: 2)
    
    var msg =  UILabel(font: .text_14_m,
                       color:  .lee,
                       numOfLines: 2,
                       text: "message goes here")
    
    var unreadCount = UnreadCount()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Edges()
        ])
    }
    
    func setupContentStack(){
        contentStack.addArrangedSubviews([profileImg,
                                          textStack])
        
        setupTextStack()
    }
    
    func setupTextStack(){
        date.setContentHuggingPriority(.required, for: .horizontal)
        msg.setContentCompressionResistancePriority(.required, for: .vertical)
        media.easy.layout(Size(16))
        
        textStack.addArrangedSubviews([firstLine,
                                       secondLine])
        
        firstLine.addArrangedSubviews([name,
                                       msgStatus,
                                       date])
        
        secondLine.addArrangedSubviews([msg,
                                        unreadCount])
    }
    
    func setupData(data: RoomInfo?){
        guard let data = data else { return }
        guard let msg = data.lastMessage else { return }
        
        profileImg.setupData(data: data.room)
        name.text = data.room.username
        unreadCount.setup(count: data.unreadCount, isMuted: false)

        date.text = TimeAgo.shared.getTimeOrDayOrDate(msg.date.getDate())
        msgStatus.isHidden = msg.senderUUID != AccUserDefaults.id
        msgStatus.setup(msg.status)
        self.msg.text = msg.content

        if msg.type == MsgType.video.rawValue || msg.type == MsgType.image.rawValue {
            secondLine.insertArrangedSubview(media, at: 0)

            if msg.localPath?.isEmpty == false {

                media.kf.setImage(with: URL(fileURLWithPath: msg.localPath ?? "")) { result in
                    switch result {
                    case .failure(_):
                        self.media.kf.setImage(with: URL(string: msg.fileUrl ?? ""))

                    case .success(_):
                        return
                    }
                }

            } else {
                media.kf.setImage(with: URL(string: msg.fileUrl ?? ""))
            }
        } else {
            media.removeFromSuperview()
        }
    }
}
