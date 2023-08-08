//
//  ReplyMsgBottomView.swift
//  tmchat
//
//  Created by Shirin on 3/17/23.
//

import UIKit
import EasyPeasy

class ReplyMsgBottomView: UIStackView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 10)
    
    var icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: 0,
                           image: UIImage(named: "reply"),
                           backgroundColor: .clear)
    var line: UIView = {
        let v = UIView()
        v.backgroundColor = .accent
        v.easy.layout([
            Height(24), Width(1)
        ])
        return v
    }()
    
    var textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 4)
    
    var name = UILabel(font: .metadata_12,
                       color: .accent,
                       alignment: .left,
                       numOfLines: 1,
                       text: "name goes here")
    
    var msg = UILabel(font: .minitext_12,
                      color: .blade,
                      alignment: .left,
                      numOfLines: 1,
                      text: "msg goes here")
    
    var deleteBtn = IconBtn(image: UIImage(named: "close-border"),
                            color: .lee)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupContentStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        axis = .vertical
        spacing = 0
        addArrangedSubviews([seperator(), contentStack, seperator()])
    }
    
    func setupContentStack(){
        icon.easy.layout(Size(20))
        contentStack.addMargins(top: 8, left: 12, bottm: 8, right: 2)
        
        contentStack.addArrangedSubviews([icon,
                                          line,
                                          textStack,
                                          deleteBtn])
        
        textStack.addArrangedSubviews([name,
                                       msg])
    }
    
    func seperator() -> UIView {
        let v = UIView()
        v.backgroundColor = .onBg
        v.easy.layout(Height(1))
        return v
    }
    
    func setupData(_ msg: ShortMsg?){
        guard let msg = msg else { return }
        print("MSG ", msg)
        self.name.text = msg.senderName
        self.msg.text = msg.content
    }
}
