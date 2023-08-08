//
//  ProfileIconTextBtn.swift
//  tmchat
//
//  Created by Shirin on 3/13/23.
//

import UIKit
import EasyPeasy

class ProfileIconTextBtn: UIStackView {
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    var title = UILabel(font: .metadata_12,
                        color: .accent,
                        alignment: .center,
                        numOfLines: 1,
                        text: "1212")
    
    var clickCallback: ( ()->() )?
    
    init(title: String, iconName: String, color: UIColor = .accent) {
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))

        self.icon.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        self.title.text = title
        
        icon.tintColor = color
        self.title.textColor = color
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        alignment = .center
        axis = .vertical
        spacing = 4
        easy.layout(Width(>=56))
        
        icon.easy.layout(Size(28))
        title.setContentHuggingPriority(.required, for: .horizontal)
        
        addArrangedSubviews([icon,
                             title])
    }
    
    @objc func click(){
        clickCallback?()
    }
}
