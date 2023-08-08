//
//  TextBtn.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit

class TextBtn: BaseBtn {
    
    init(title: String){
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.accent, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
