//
//  FabBtn.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class FabBtn: UIView {

    var bg = UIStackView(axis: .horizontal,
                         alignment: .fill,
                         spacing: 8,
                         edgeInsets: UIEdgeInsets(horizontalEdges: 14,
                                                  verticalEdges: 16))
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    var title = UILabel(font: .text_14_m,
                        color: .white,
                        alignment: .center,
                        numOfLines: 1,
                        text: "1212")
    
    var clickCallback: ( ()->() )?
    
    init(title: String, iconName: String) {
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))

        icon.image = UIImage(named: iconName)
        self.title.text = title
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .accent
        layer.cornerRadius = 24
        
        addSubview(bg)
        bg.easy.layout([
            Top(>=0), Bottom(>=0), Center().with(.required),
            Leading(>=0).with(.high), Trailing(>=0).with(.high),
        ])
        
        icon.easy.layout(Size(20))
        title.setContentHuggingPriority(.required, for: .horizontal)
        
        bg.addArrangedSubviews([icon,
                                title])
    }
    
    @objc func click(){
        clickCallback?()
    }
}
