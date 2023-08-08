//
//  ChatProfileViewHeader.swift
//  tmchat
//
//  Created by Shirin on 3/13/23.
//

import UIKit
import MXParallaxHeader
import EasyPeasy

class ChatProfileViewHeader: UIView {
    
    var height: CGFloat = 0
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 2,
                                   edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    
    
    var profileWrapper  = UIStackView(axis: .vertical,
                                      alignment: .center,
                                      spacing: 2)

    var profileImg = ProfileImg(size: 100)
    
    var name = UILabel(font: .sb_16_m,
                       color: .blade,
                       alignment: .center,
                       numOfLines: 0,
                       text: "name")
    
    var nickname = UILabel(font: .text_14_m,
                           color: .accent,
                           alignment: .center,
                           numOfLines: 0)
    
    
    var lastActive = UILabel(font: .text_14_m,
                             color: .lee,
                             alignment: .center,
                             numOfLines: 0,
                             text: "online")
    
    var btnWrapper = UIStackView(axis: .vertical,
                                 alignment: .center,
                                 spacing: 2)

    var btnStack = UIStackView(axis: .horizontal,
                               alignment: .fill,
                               spacing: 10)
    
    var profileBtn = ProfileIconTextBtn(title: "profile".localized(),
                                        iconName: "profile-empty")
    
    var deleteBtn = ProfileIconTextBtn(title: "delete".localized(),
                                       iconName: "trash-empty")
    
//    var callBtn = ProfileIconTextBtn(title: "call".localized(),
//                                        iconName: "audio")
//
//    var searchBtn = ProfileIconTextBtn(title: "search".localized(),
//                                        iconName: "search-profile")
//
//    var moreBtn = ProfileIconTextBtn(title: "more".localized(),
//                                     iconName: "h-more")

    var notifications = ViewWithSwitch(title: "notifications".localized())
    
//    var posts = ViewWithSwitch(title: "see_my_posts".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if height == 0 {
            height = frame.size.height
            easy.layout([Height(height), Width(DeviceDimensions.width)])
        }
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Top(20), Leading(), Trailing(), Bottom()
        ])
    }
    
    func setupContentStack(){
        contentStack.addArrangedSubviews([profileWrapper,
                                          name,
                                          nickname,
                                          lastActive,
                                          btnWrapper,
                                          seperator(isVertical: false),
                                          notifications,
                                          seperator(isVertical: false),
                                          UIView()
                                         ])
        
        contentStack.setCustomSpacing(10, after: profileWrapper)
        contentStack.setCustomSpacing(30, after: lastActive)
        contentStack.setCustomSpacing(30, after: btnWrapper)
        
        profileWrapper.addArrangedSubview(profileImg)
        btnWrapper.addArrangedSubview(btnStack)
        setupBtnStack()
    }
    
    func setupBtnStack(){
        btnStack.addArrangedSubviews([profileBtn,
                                      seperator(isVertical: true),
                                      deleteBtn,
                                     ])
    }
    
    func setupData(room: Room?){
        guard let room = room else { return }
        profileImg.setupData(data: room)
        name.text = room.roomName
        nickname.text = room.username
        lastActive.text = (room.isActive ?? false) ? "online".localized() : TimeAgo.shared.getAgo(room.lastLoginAt?.getDate())
        lastActive.textColor = (room.isActive ?? false) ? .accent : .lee
        notifications.switchBtn.isOn = room.isNotificationEnabled == true
    }
    func seperator(isVertical: Bool) -> UIView {
        let v = UIView()
        v.backgroundColor = .onBg
        if isVertical {
            v.easy.layout(Width(1))
        } else {
            v.easy.layout(Height(1))
        }
        
        return v
    }
}
