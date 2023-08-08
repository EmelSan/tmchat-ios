//
//  MediaViewerHeader.swift
//  tmchat
//
//  Created by Shirin on 4/13/23.
//

import UIKit

class MediaViewerHeader: UIStackView {

    var backBtn = IconBtn(image: UIImage(named: "close")?.withRenderingMode(.alwaysTemplate),
                          color: .white)
    
    var headerTitleStack = UIStackView(axis: .vertical,
                                       alignment: .fill,
                                       spacing: 4)
    
    var count = UILabel(font: .text_14_m,
                        color: .white,
                        alignment: .center,
                        numOfLines: 1,
                        text: "1/1")
    
    var senderName = UILabel(font: .minitext_12,
                             color: .white,
                             alignment: .center,
                             numOfLines: 1,
                             text: "username")

    var shareBtn = IconBtn(image: UIImage(named: "share")?.withRenderingMode(.alwaysTemplate),
                          color: .white)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        addMargins(top: 10, left: 10, bottm: 10, right: 10)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        alignment = .fill
        axis = .horizontal
        
        addArrangedSubviews([backBtn,
                            headerTitleStack,
                            shareBtn])
        
        headerTitleStack.addArrangedSubviews([count,
                                             senderName])
    }
}
