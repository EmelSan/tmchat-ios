//
//  UserDataStack.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit

class UserDataStack: UIStackView {
    
    var bg = UIView()
    
    let backBtn = IconBtn(image: UIImage(named: "back"), color: .blade)

    let profileImg = ProfileImg(size: 40)
    
    let textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 2)
    
    let name = UILabel(font: .text_14_m,
                       numOfLines: 1,
                       text: "name goes here")
    
    let desc = UILabel(font: .text_14_r,
                       color:  .lee,
                       numOfLines: 1,
                       text: "subtitle goes here")
    
    let audioBtn = IconBtn(image: UIImage(named: "audio"), color: .blade)

    let trailingBtn = IconBtn(image: UIImage(named: "more")?.withRenderingMode(.alwaysTemplate), color: .accent)

    var clickCallback: ( ()->() )?
    var doubleClickCallback: ( ()->() )?
    
    init(withBackBtn: Bool = false) {
        super.init(frame: .zero)

        let clickGesture = UITapGestureRecognizer(target: self, action: #selector(click))
        clickGesture.delaysTouchesBegan = true

        let doubleClickGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleClick))
        doubleClickGesture.numberOfTapsRequired = 2
        doubleClickGesture.delaysTouchesBegan = true

        clickGesture.require(toFail: doubleClickGesture)
        addGestureRecognizer(clickGesture)
        addGestureRecognizer(doubleClickGesture)

        setupView()
        
        
        if withBackBtn {
            insertArrangedSubview(backBtn, at: 0)
        }
        
        bg = addBackground(color: .clear, cornerRadius: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        axis = .horizontal
        alignment = .center
        spacing = 10
        addMargins(top: 10, left: 10, right: 10)
        
        addArrangedSubviews([profileImg,
                             textStack,
                             trailingBtn])
        
        textStack.addArrangedSubviews([name,
                                       desc])
    }
    
    func addAudio(){
        trailingBtn.removeFromSuperview()
        addArrangedSubviews([audioBtn,
                             trailingBtn])
    }
    
    func setupData(_ data: Room?){
        guard let data = data else { return }
        profileImg.setupData(data: data)
        name.text = data.roomName ?? ""
        if data.isActive == true {
            desc.text = "online".localized()
            desc.textColor = .accent
        } else {
            desc.text = TimeAgo.shared.getAgo(data.lastLoginAt?.getDate())
            desc.textColor = .lee
        }
    }
    
    
    func setupData(_ user: User?){
        guard let user = user else { return }
        profileImg.setupData(data: user)
        name.text = user.username ?? ""
        desc.text = [user.firstName ?? "", user.lastName ?? ""].joined(separator: " ").trimmingCharacters(in: .whitespaces)
        desc.textColor = .lee
    }
    
    @objc func click(){
        clickCallback?()
    }

    @objc
    private func onDoubleClick() {
        doubleClickCallback?()
    }
}
