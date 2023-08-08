//
//  UnreadCount.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class UnreadCount: UIView {

    let count = UILabel(font: .metadata_12,
                        color: .lee,
                        alignment: .center,
                        numOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 6
        
        addSubview(count)
        count.setContentHuggingPriority(.required, for: .horizontal)
        count.easy.layout([
            Top(2), Leading(6), Trailing(6), Bottom(2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(count: Int?, isMuted: Bool) {
        guard let count = count else { return }
                
        self.isHidden = count <= 0
        self.count.text = count < 99 ? "\(count)" : "99+"
        
        if isMuted {
            backgroundColor = .onBg
            self.count.textColor = .lee
        } else {
            backgroundColor = .accent
            self.count.textColor = .white
        }
    }
}
