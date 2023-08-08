//
//  Header.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit

class Header: UIStackView {

    var backBtn = IconBtn(image: UIImage(named: "back")?.withRenderingMode(.alwaysTemplate),
                          color: .blade)
    
    var title = UILabel(font: .text_14_m,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 1)
    
    var trailingBtn = IconBtn(image: nil,
                              color: .blade)
    
    var btn = TextBtn(title: "settings".localized())
    
    init(title: String, isPresented: Bool = false, backIsFirst: Bool = true) {
        super.init(frame: .zero)
        setupStack()
        
        self.title.text = title
        if isPresented { backBtn.setImage(UIImage(named: "close"), for: .normal) }
        
        if backIsFirst {
            insertArrangedSubview(backBtn, at: 0)
        } else {
            layoutMargins.left = 16
            addArrangedSubview(backBtn)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStack(){
        axis = .horizontal
        alignment = .center
        
        addMargins(top: 10, left: 10, bottm: 10, right: 10)
        addArrangedSubview(title)
        
    }
    
    func addTrailingBtn(iconName: String){
        trailingBtn.setImage(UIImage(named: iconName), for: .normal)
        addArrangedSubview(trailingBtn)
    }
    
    
    func addTrailingBtn(img: UIImage?){
        trailingBtn.setImage(img, for: .normal)
        addArrangedSubview(trailingBtn)
    }
    
    func setupWithColor(_ color: UIColor){
        backBtn.imageView?.tintColor = color
        title.textColor = color
        btn.setTitleColor(color, for: .normal)
    }
    
    func setupNormally(){
        removeSubviews()
        title.text = ""
        addArrangedSubviews([backBtn, title])
    }
    
    func setupForOwnProfile(){
        title.text = ""
        btn.setTitleColor(.white, for: .normal)
        backBtn.imageView?.tintColor = .white
        backBtn.setImage(UIImage(named: "right")?.withRenderingMode(.alwaysTemplate),
                         for: .normal)
        addArrangedSubview(backBtn)
        insertArrangedSubview(btn, at: 0)
        insertArrangedSubview(UIView(), at: 0)
    }
}
