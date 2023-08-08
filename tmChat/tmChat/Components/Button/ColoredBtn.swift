//
//  PrimaryBtn.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class ColoredBtn: BaseBtn {
    
    init(title: String,
         titleColor: UIColor = .white,
         bgColor: UIColor = .accent){
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        easy.layout(Height(48))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
