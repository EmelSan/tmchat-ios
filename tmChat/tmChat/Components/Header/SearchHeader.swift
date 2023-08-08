//
//  SearchHeader.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class SearchHeader: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                            verticalEdges: 10))
    
    var search = SearchFieldBtn()
    
    var trailingBtn = IconBtn(image: UIImage(named: "bell"),
                              color: .lee)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
    }
    
    func setupContentStack(){
        trailingBtn.isHidden = true
        contentStack.addArrangedSubviews([search,
                                          trailingBtn])
    }
}
