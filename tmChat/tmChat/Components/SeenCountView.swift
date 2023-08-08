//
//  SeenCountView.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class SeenCountView: UIStackView {

    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           image: UIImage(named: "eye"),
                           backgroundColor: .clear)
    
    var title = UILabel(font: .minitext_12,
                        color: .lee,
                        alignment: .left,
                        numOfLines: 1,
                        text: "1212")
    
    var count: Int = 0 {
        didSet {
            title.text = "\(count)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        icon.easy.layout(Size(16))
        title.setContentHuggingPriority(.required, for: .horizontal)
        
        axis = .horizontal
        spacing = 4
        
        addArrangedSubviews([icon, title])
    }
}
