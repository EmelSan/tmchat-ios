//
//  MsgSelectionBtn.swift
//  tmchat
//
//  Created by Shirin on 3/20/23.
//

import UIKit
import EasyPeasy

class MsgSelectionBtn: UIImageView {
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 10,
                           backgroundColor: .onBg)
    
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
              
        isUserInteractionEnabled = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        easy.layout(Size(24))
        
        addSubview(icon)
        icon.easy.layout([
            Size(20), Center()
        ])
    }
    
    func setupCheckedState(){
        icon.image = UIImage(named: "checked")
    }
    
    func setupEmptyState(){
        icon.image = nil
    }
    
    @objc func click(){
        isChecked = !isChecked
        clickCallback?()
    }
}
