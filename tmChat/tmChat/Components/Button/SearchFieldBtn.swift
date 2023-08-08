//
//  SearchFieldBtn.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class SearchFieldBtn: UIView {
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 14, verticalEdges: 10))
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           image: UIImage(named: "search"),
                           backgroundColor: .clear)
    
    var title = UILabel(font: .text_14_m,
                        color: .lee,
                        alignment: .left,
                        numOfLines: 1,
                        text: "global_search".localized())
    
    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
              
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .onBg
        layer.cornerRadius = 10

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
