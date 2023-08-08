//
//  ViewWithSwitch.swift
//  tmchat
//
//  Created by Shirin on 3/13/23.
//

import UIKit

class ViewWithSwitch: UIStackView {

    var title = UILabel(font: .text_14_m,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 0)
    
    var switchBtn = SwitchBtn()
    
    init(title: String){
        super.init(frame: .zero)
        setupView()
        
        self.title.text = title
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setupView(){
        spacing = 4
        addMargins(top: 10, left: 16, bottm: 10, right: 16)
        
        
        addArrangedSubviews([title,
                             UIView(),
                             switchBtn])
    }
}
