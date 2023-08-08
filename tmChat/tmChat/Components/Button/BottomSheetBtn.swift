//
//  BottomSheetBtn.swift
//  tmchat
//
//  Created by Shirin on 3/16/23.
//

import UIKit
import EasyPeasy

class BottomSheetBtn: UIStackView {

    var bg = UIView()
    
    var title = UILabel(font: .text_14_m,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 0)
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    var clickCallback: ( ()->() )?
    
    init(title: String, iconName: String, color: UIColor = .blade){
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        
        setupView()
        self.title.textColor = color
        self.icon.tintColor = color
        
        self.title.text = title
        self.icon.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addMargins(edges: 16)
        
        bg = addBackground(color: .white,
                           cornerRadius: 6,
                           borderWidth: 1,
                           borderColor: .clear)
        icon.easy.layout(Size(20))
        
        addArrangedSubviews([title,
                             icon])
        
    }
    
    func addBorder(color: UIColor){
        bg.layer.borderColor = color.cgColor
    }
    
    @objc func click(){
        clickCallback?()
    }
}
