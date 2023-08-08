//
//  MessagingSelectionFooter.swift
//  tmchat
//
//  Created by Shirin on 3/23/23.
//

import UIKit
import EasyPeasy

class MessagingSelectionFooter: UIStackView {

    let deleteBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "trash-empty"), color: .blade)
        b.backgroundColor = .white
        b.layer.cornerRadius = 10
        b.easy.clear()
        b.easy.layout(Height(40))
        return b
    }()
    
    let bookmarkBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "bookmark"), color: .blade)
        b.backgroundColor = .white
        b.layer.cornerRadius = 10
        b.easy.clear()
        b.easy.layout(Height(40))
        return b
    }()

    let copyBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "copy-20"), color: .blade)
        b.backgroundColor = .white
        b.layer.cornerRadius = 10
        b.easy.clear()
        b.easy.layout(Height(40))
        return b
    }()

    let replyBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "reply-20"), color: .blade)
        b.backgroundColor = .white
        b.layer.cornerRadius = 10
        b.easy.clear()
        b.easy.layout(Height(40))
        return b
    }()

    let forwardBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "forward"), color: .blade)
        b.backgroundColor = .white
        b.layer.cornerRadius = 10
        b.easy.clear()
        b.easy.layout(Height(40))
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        distribution = .fillEqually
        spacing = 7
        
        addMargins(top: 10, left: 16, bottm: 10, right: 16)
        addArrangedSubviews([deleteBtn,
//                             bookmarkBtn,
                             copyBtn,
                             replyBtn,
                             forwardBtn])

    }
}
