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
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 14,
                                   edgeInsets: UIEdgeInsets(edges: 16))

    var topStack = UIStackView(axis: .horizontal)

    var nameActiveDateStack = UIStackView(axis: .vertical)
    
    var fullName = UILabel(font: .sb_16_m,
                           color: .blade,
                           alignment: .left,
                           numOfLines: 0,
                           text: "username")
    
    var lastActiveDate = UILabel(font: .text_12_r,
                                 color: .lee,
                                 alignment: .left,
                                 numOfLines: 0,
                                 text: "last active date")

    var editBtn: IconBtn = {
        let button = IconBtn(image: UIImage(named: "edit-settings"), color: .blade)
        button.backgroundColor = .bg
        button.layer.borderColor = UIColor.onBg1.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }()
    
    var btnStack = UIStackView(axis: .horizontal,
                               alignment: .fill,
                               spacing: 10)
    
    var moreBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "h-more-20")?.withRenderingMode(.alwaysTemplate), color: .accent)
        b.backgroundColor = .bg
        b.layer.cornerRadius = 10
        b.layer.borderColor = UIColor.onBg1.cgColor
        b.layer.borderWidth = 1
        b.easy.layout(Size(40))
        return b
    }()
    
    var qrBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "qr")?.withRenderingMode(.alwaysTemplate), color: .blade)
        b.backgroundColor = .onBg
        b.layer.cornerRadius = 10
        b.easy.layout(Size(44))
        return b
    }()

    var notificationBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "bell-empty")?.withRenderingMode(.alwaysTemplate), color: .accent)
        b.backgroundColor = .bg
        b.layer.cornerRadius = 10
        b.layer.borderColor = UIColor.onBg1.cgColor
        b.layer.borderWidth = 1
        b.easy.layout(Size(40))
        return b
    }()

    var callBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "call")?.withRenderingMode(.alwaysTemplate), color: .accent)
        b.backgroundColor = .bg
        b.layer.cornerRadius = 10
        b.layer.borderColor = UIColor.onBg1.cgColor
        b.layer.borderWidth = 1
        b.easy.layout(Size(40))
        return b
    }()

    var fabBtn: FabBtn = {
        let b = FabBtn(title: "create_new_post".localized(), iconName: "add-circle-clear")
        b.bg.layoutMargins.top = 10
        b.bg.layoutMargins.bottom = 10
        b.layer.cornerRadius = 10
        return b
    }()

    var infoView = ProfileInfoView()
    
    var countStack = UIStackView(axis: .horizontal,
                                 alignment: .fill,
                                 spacing: 20, edgeInsets: UIEdgeInsets(verticalEdges: 6))
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
        setupContentStack()
        setupRows()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupOther() {
        editBtn.isHidden = true
        fabBtn.title.text = "send_msg".localized()
        fabBtn.icon.image = UIImage(named: "Chat")
        callBtn.isHidden = false
        moreBtn.isHidden = false
    }
    
    func setupView() {
        contentView.addSubview(contentStack)
        contentStack.layer.cornerRadius = 10
        contentStack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentStack.easy.layout([
            Edges()
        ])
        contentStack.backgroundColor = .bg
    }
    
    func setupContentStack() {
        let separator = seperator()

        contentStack.addArrangedSubviews([topStack,
                                          btnStack,
                                          separator,
                                          infoView])
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins.top = 20
    }
    
    func setupRows() {
        topStack.addArrangedSubviews([nameActiveDateStack, editBtn])
        nameActiveDateStack.addArrangedSubviews([fullName, lastActiveDate])
        btnStack.addArrangedSubviews([fabBtn, notificationBtn, callBtn, moreBtn])

        notificationBtn.isHidden = true
        callBtn.isHidden = true
        moreBtn.isHidden = true
        infoView.isHidden = true
    }
    
    func seperator() -> UIView {
        let v = UIView()
        v.backgroundColor = .onBg
        v.easy.layout(Height(1))
        return v
    }
    
    func setupData(data: User?) {
        guard let data = data else { return }

        fullName.text = [data.firstName ?? "", data.lastName ?? ""].joined(separator: " ").trimmingCharacters(in: .whitespaces)
        lastActiveDate.text = data.isActive == true
                                    ? "online".lowercased()
                                    : TimeAgo.shared.getAgo(data.lastLoginAt?.getDate())
        lastActiveDate.isHidden = (lastActiveDate.text?.isEmpty ?? true)


        let info = data.description ?? ""
        infoView.info = info
        infoView.isHidden = info.isEmpty
    }
}
