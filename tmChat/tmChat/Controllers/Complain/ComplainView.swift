//
//  ComplainView.swift
//  tmchat
//
//  Created by Shirin on 4/18/23.
//

import UIKit
import EasyPeasy

class ComplainView: BaseView {

    var header = Header(title: "complain".localized())
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 16,
                                   edgeInsets: UIEdgeInsets(edges: 16))
    
    var textView = TextView(title: "",
                            placeholder: "enter_your_complain".localized())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.addTrailingBtn(img: UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate))
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        addSubview(contentStack)
        contentStack.easy.layout([
            Leading(), Trailing(), Top().to(header, .bottom), Bottom()
        ])
        
        contentStack.addArrangedSubviews([textView,
                                          UIView()])
    }
}
