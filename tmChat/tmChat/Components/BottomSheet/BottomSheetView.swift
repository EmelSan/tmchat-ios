//
//  BottomSheetView.swift
//  tmchat
//
//  Created by Shirin on 3/17/23.
//

import UIKit
import EasyPeasy

class BottomSheetView: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 20,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                            verticalEdges: 14))
    
    var title = UILabel(font: .sb_16_m,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 0)
    
    var desc = UILabel(font: .text_14_r,
                       color: .bladeContrast,
                       alignment: .left,
                       numOfLines: 0)
    
    var btnStack = UIStackView(axis: .vertical,
                               alignment: .fill,
                               spacing: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        desc.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([title,
                                          desc,
                                          btnStack])
        
        contentStack.setCustomSpacing(6, after: title)
    }
}

