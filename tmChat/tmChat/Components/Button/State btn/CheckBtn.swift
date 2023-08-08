//
//  CheckBtn.swift
//  tmchat
//
//  Created by Shirin on 3/12/23.
//

import UIKit
import EasyPeasy

class CheckBtn: UIView {
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 10, verticalEdges: 6))
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    var title = UILabel(font: .text_14_m,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 1)
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                setupCheckedState()
            } else {
                setupEmptyState()
            }
        }
    }
    
    var clickCallback: ( ()->() )?
    
    init(title: String, isChecked: Bool = true) {
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
              
        setupView()
        self.isChecked = isChecked
        self.title.text = title
        
        if isChecked {
            setupCheckedState()
        } else {
            setupEmptyState()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .bg
        layer.cornerRadius = 10

        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        icon.easy.layout(Size(20))
        
        contentStack.addArrangedSubviews([icon,
                                          title])
    }
    
    func setupCheckedState(){
        title.textColor = .accent
        icon.image = UIImage(named: "checked")
    }
    
    func setupEmptyState(){
        title.textColor = .blade
        icon.image = UIImage(named: "not-checked")
    }
    
    @objc func click(){
        isChecked = !isChecked
        clickCallback?()
    }
}
