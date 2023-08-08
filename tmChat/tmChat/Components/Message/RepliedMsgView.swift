//
//  RepliedMsgView.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit
import EasyPeasy

class RepliedMsgView: UIView {
    
    let ownBg = UIColor(red: 0.89, green: 0.953, blue: 1, alpha: 1)
    let otherBg = UIColor.bg
    
    var bg: UIView = {
        let v = UIView()
        v.backgroundColor = .accent
        v.layer.cornerRadius = 6
        return v
    }()

    var contentBg = UIView()
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 10,
                                                            verticalEdges: 6))
    
    var sender = UILabel(font: .metadata_12,
                         color: .accent,
                         alignment: .left,
                         numOfLines: 1,
                         text: "sender nameee")
    
    var msg = UILabel(font: .minitext_12,
                      color: .blade,
                      alignment: .left,
                      numOfLines: 1,
                      text: "message")
 
    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        
        setupView()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(bg)
        bg.easy.layout(Edges())
        
        addSubview(contentStack)
        contentStack.easy.layout([
            Leading(2), Trailing(), Top(), Bottom()
        ])
        
    }
    
    func setupSubviews(){
        sender.setContentCompressionResistancePriority(.required, for: .horizontal)
        msg.setContentCompressionResistancePriority(.required, for: .horizontal)

        contentBg = contentStack.addBackground(color: ownBg,
                                               cornerRadius: 6)
        
        contentStack.addArrangedSubviews([sender,
                                          msg])
    }
    
    func setupData(msg: ShortMsg){
        self.sender.text = msg.senderName
        self.msg.text = msg.content
    }
    
    @objc func click(){
        clickCallback?()
    }
}
