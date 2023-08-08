//
//  SwitchBtn.swift
//  tmchat
//
//  Created by Shirin on 3/13/23.
//

import UIKit
import EasyPeasy

class SwitchBtn: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 14,
                                                            verticalEdges: 8))
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    var title = UILabel(font: .metadata_12,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 1)
    
    var isOn: Bool = false {
        didSet {
            if isOn {
                setupOnState()
            } else {
                setupOffState()
            }
        }
    }
    
    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
             
        isOn = true
        setupView()
        setupOnState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderColor = UIColor.onBg.cgColor
        layer.borderWidth = 2
        
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        icon.easy.layout(Size(16))
        contentStack.addArrangedSubviews([icon, title])
    }
    
    func setupOnState(){
        backgroundColor = .onBg
        title.removeFromSuperview()
        contentStack.addArrangedSubview(title)
        
        title.textColor = .accent
        title.text = "on"
        icon.image = UIImage(named: "checked")
    }
    
    func setupOffState(){
        backgroundColor = .clear
        icon.removeFromSuperview()
        contentStack.addArrangedSubview(icon)
        
        title.textColor = .bladeContrast
        title.text = "off"
        icon.image = UIImage(named: "subtract")
    }
    
    @objc func click(){
        isOn = !isOn
        clickCallback?()
    }
}
