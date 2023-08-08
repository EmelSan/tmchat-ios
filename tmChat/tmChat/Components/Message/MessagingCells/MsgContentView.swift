//
//  MsgContentView.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit
import EasyPeasy

class MsgContentView: UIView {
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 6)
    
    var repliedMsgView = RepliedMsgView()
    
    var dateStatusStack = UIStackView(axis: .horizontal,
                                      alignment: .fill,
                                      spacing: 2)
    
    var date = UILabel(font: .comments_10,
                       color: .lee,
                       alignment: .right,
                       numOfLines: 1)
    
    var status = MsgStatusView(frame: .zero)
    
    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        clipsToBounds = true
        setupBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBaseView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        date.easy.layout(Width(>=30))
        
        date.setContentHuggingPriority(.required, for: .horizontal)
        status.setContentCompressionResistancePriority(.required, for: .horizontal)
        dateStatusStack.addArrangedSubviews([status,
                                             date])
        
        dateStatusStack.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func colorWhite(){
        date.textColor = .white
        status.color(.white)
    }
    
    @objc func click(){
        clickCallback?()
    }
}
