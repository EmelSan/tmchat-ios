//
//  ProfileTbHeader.swift
//  tmchat
//
//  Created by Shirin on 3/15/23.
//

import UIKit
import EasyPeasy

class ProfileTbHeader: UITableViewHeaderFooterView {

    static let id = "ProfileTbHeader"
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 0)
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0,
                                   edgeInsets: UIEdgeInsets(edges: 16))
    
    var name = UILabel(font: .sb_16_m,
                       color: .blade,
                       alignment: .left,
                       numOfLines: 0,
                       text: "name ")
    
    var username = UILabel(font: .text_14_r,
                           color: .accent,
                           alignment: .left,
                           numOfLines: 0, text: "username")
    
    var lastActiveDate = UILabel(font: .text_14_r,
                                 color: .lee,
                                 alignment: .left,
                                 numOfLines: 0,
                                 text: "last active date")
    
    var btnStack = UIStackView(axis: .horizontal,
                               alignment: .fill,
                               spacing: 10)
    
    
    var moreBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "h-more-20")?.withRenderingMode(.alwaysTemplate), color: .blade)
        b.backgroundColor = .onBg
        b.layer.cornerRadius = 10
        b.easy.layout(Size(44))
        return b
    }()
    
    var qrBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "qr")?.withRenderingMode(.alwaysTemplate), color: .blade)
        b.backgroundColor = .onBg
        b.layer.cornerRadius = 10
        b.easy.layout(Size(44))
        return b
    }()
    
    var contactsBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "contacts")?.withRenderingMode(.alwaysTemplate), color: .blade)
        b.backgroundColor = .onBg
        b.layer.cornerRadius = 10
        b.easy.layout(Size(44))
        return b
    }()

    var notificationBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "bell-empty")?.withRenderingMode(.alwaysTemplate), color: .blade)
        b.backgroundColor = .onBg
        b.layer.cornerRadius = 10
        b.easy.layout(Size(44))
        return b
    }()

    var fabBtn: FabBtn = {
        let b = FabBtn(title: "new_post".localized(), iconName: "add-circle")
        b.bg.layoutMargins.top = 12
        b.bg.layoutMargins.bottom = 12
        b.layer.cornerRadius = 22
        return b
    }()
    
    var infoStack = UIStackView(axis: .horizontal,
                                alignment: .top,
                                spacing: 20,
                                edgeInsets: UIEdgeInsets(verticalEdges: 16))
    
    var infoIcon = UIImageView(contentMode: .scaleAspectFill,
                               cornerRadius: 0,
                               image: UIImage(named: "info"),
                               backgroundColor: .clear)
    
    var info = UILabel(font: .text_14_r,
                       color: .blade,
                       alignment: .left,
                       numOfLines: 0,
                       text: "info text ")
    
    var countStack = UIStackView(axis: .horizontal,
                                 alignment: .fill,
                                 spacing: 20, edgeInsets: UIEdgeInsets(verticalEdges: 6))
    
    var count = UILabel(font: .text_14_m,
                        color: .accent,
                        alignment: .left,
                        numOfLines: 0,
                        text: "post count: 10")
    
    var searchBtn = IconBtn(image: UIImage(named: "search")?
                                    .withRenderingMode(.alwaysTemplate),
                            color: .accent)
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
        setupContentStack()
        setupRows()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupOther(){
        contactsBtn.removeFromSuperview()
//        btnStack.insertArrangedSubview(notificationBtn, at: 1)
        fabBtn.title.text = "send_msg".localized()
        fabBtn.icon.image = UIImage(named: "pencil")
    }
    
    func setupView(){
        contentView.addSubview(img)
        img.easy.layout([
            Top(), Leading(), Trailing(), Height(DeviceDimensions.width+DeviceDimensions.topInset)
        ])

        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Top().to(img, .bottom), Leading(), Trailing(), Bottom()
        ])
    }
    
    func setupContentStack(){
        contentStack.addArrangedSubviews([name,
                                          username,
                                          lastActiveDate,
                                          btnStack,
                                          seperator(),
                                          infoStack,
                                          seperator(),
                                          countStack ])
        
        contentStack.setCustomSpacing(2, after: name)
        contentStack.setCustomSpacing(2, after: username)
        contentStack.setCustomSpacing(16, after: lastActiveDate)
        contentStack.setCustomSpacing(20, after: btnStack)
    }
    
    func setupRows(){
        btnStack.addArrangedSubviews([moreBtn,
                                      contactsBtn,
                                      fabBtn])
        infoStack.addArrangedSubviews([infoIcon, info])
        countStack.addArrangedSubviews([count, searchBtn])
        
        infoIcon.easy.layout(Size(20))
    }
    
    func seperator() -> UIView {
        let v = UIView()
        v.backgroundColor = .onBg
        v.easy.layout(Height(1))
        return v
    }
    
    func setupData(data: User?, count: Int){
        guard let data = data else { return }
        img.kf.setImage(with: ApiPath.url(data.avatar ?? ""))
        img.backgroundColor = UIColor(hexString: data.colorCode ?? "#A5A5A5")
        name.text = [data.firstName ?? "", data.lastName ?? ""].joined(separator: " ").trimmingCharacters(in: .whitespaces)
        username.text = data.username
        self.count.text = ["post_count".localized(), "\(count)"].joined(separator: ": ")
        lastActiveDate.text = data.isActive == true
                                    ? "online".lowercased()
                                    : TimeAgo.shared.getAgo(data.lastLoginAt?.getDate())
        
        if data.description == nil {
            infoStack.removeFromSuperview()
        }
    }
}
