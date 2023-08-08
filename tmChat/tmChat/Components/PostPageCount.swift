//
//  PostPageCount.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class PostPageCount: UIView {

    var count = 1 {
        didSet {
            isHidden = count <= 1
            current = 0
        }
    }
    
    var current = 0 {
        didSet {
            text.text = "\(current+1) / \(count)"
        }
    }
    
    var text = UILabel(font: .comments_10,
                       color: .white,
                       alignment: .center,
                       numOfLines: 0, text: "1/1")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        text.setContentHuggingPriority(.required, for: .horizontal)
        easy.layout(Height(20))
        backgroundColor = .blade.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        
        addSubview(text)
        text.easy.layout([
            Top(4), Leading(8), Trailing(8), Bottom(4)
        ])
    }
}
