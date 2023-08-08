//
//  IconTextBtn.swift
//  tmchat
//
//  Created by Shirin on 3/12/23.
//

import UIKit
import EasyPeasy

class IconTextBtn: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 14,
                                                            verticalEdges: 8))
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    var title = UILabel(font: .text_14_m,
                        color: .bapAccent,
                        alignment: .left,
                        numOfLines: 1)
        
    var clickCallback: ( ()->() )?
    
    init(title: String?, image: UIImage?, isPrimary: Bool = false) {
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
              
        setupView()

        if title == nil {
            self.title.removeFromSuperview()
        } else {
            self.title.text = title
        }
        
        if image == nil {
            self.icon.removeFromSuperview()
        } else {
            self.icon.image = image
        }
        
        if isPrimary {
            self.title.textColor = .white
            self.backgroundColor = .accent
        } else {
            self.title.textColor = .blade
            self.backgroundColor = .bg
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor

        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        icon.easy.layout(Size(16))
        
        contentStack.addArrangedSubviews([icon,
                                          title])
    }
    
    @objc func click(){
        clickCallback?()
    }
}
