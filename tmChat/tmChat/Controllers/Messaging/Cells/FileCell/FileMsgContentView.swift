//
//  FileMsgContentView.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit
import EasyPeasy

class FileMsgContentView: MsgContentView {
    
    var fileStack = UIStackView(axis: .horizontal,
                                alignment: .fill,
                                spacing: 6)
    
    var statusWrapper = UIStackView(axis: .horizontal,
                                    alignment: .fill,
                                    spacing: 6)

    var icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: 36/2,
                           image: UIImage(named: "file-cell-img"),
                           backgroundColor: .accent)
    
    var textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 2)
    
    var title = UILabel(font: .sb_16_r,
                       color: .blade,
                       alignment: .left,
                       numOfLines: 1)
    
    var desc = UILabel(font: .minitext_12,
                       color: .blade,
                       alignment: .left,
                       numOfLines: 1)
    
    var progress = CustomProgressView(colors: [.white], lineWidth: 3, bgColor: .accent)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupFileStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentStack.addArrangedSubviews([fileStack,
                                          statusWrapper])
        
        statusWrapper.addArrangedSubviews([UIView(),
                                           dateStatusStack])
    }
    
    func setupFileStack(){
        easy.layout(Width(DeviceDimensions.textMsgLineWidth))
        
        icon.easy.layout(Size(36))
        icon.addSubview(progress)
        progress.easy.layout([
            Center(), Size(18)
        ])

        fileStack.addArrangedSubviews([icon,
                                      textStack])
        
        textStack.addArrangedSubviews([title,
                                       desc])
                
        desc.setContentCompressionResistancePriority(.required, for: .horizontal)
        title.setContentCompressionResistancePriority(.required, for: .horizontal)
        textStack.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func setupForContactCell(){
        icon.image = nil
        icon.backgroundColor = .lee
        
        desc.textColor = .accent
    }
}
