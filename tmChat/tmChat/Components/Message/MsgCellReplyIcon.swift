//
//  MsgCellReplyIcon.swift
//  tmchat
//
//  Created by Shirin on 3/20/23.
//

import UIKit
import EasyPeasy

class MsgCellReplyIcon: UIStackView {

    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           image: UIImage(named: "reply"),
                           backgroundColor: .clear)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addMargins(left: 12, right: 20)
        
        icon.easy.layout(Size(24))
        addArrangedSubview(icon)
    }
}
