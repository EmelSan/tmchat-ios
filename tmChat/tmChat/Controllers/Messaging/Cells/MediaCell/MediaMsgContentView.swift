//
//  MediaMsgContentView.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit
import EasyPeasy

class MediaMsgContentView: MsgContentView {
    
    var sizeStack = UIStackView(axis: .horizontal,
                                alignment: .trailing,
                                spacing: 6, distribution: .fillEqually)
    
    var duration = UILabel(font: .minitext_12,
                           color: .white,
                           alignment: .left,
                           numOfLines: 1,
                           text: "01:00")

    var size = UILabel(font: .minitext_12,
                       color: .white,
                       alignment: .right,
                       numOfLines: 1,
                       text: "1212 kb")

    var playIcon = UIImageView(contentMode: .scaleAspectFill,
                               cornerRadius: 0,
                               image: UIImage(named: "cell-play"),
                               backgroundColor: .clear)
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 14)
    
    var dateBg = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        status.color = .white
        colorWhite()

        contentStack.addSubview(img)
        img.easy.layout([
            Edges(), Width(DeviceDimensions.width/1.7), Height(DeviceDimensions.width/1.5)
        ])
        
        contentStack.addSubview(sizeStack)
        sizeStack.easy.layout([
            Top(14), Leading(14), Trailing(14)
        ])
        
        contentStack.addSubview(dateStatusStack)
        dateStatusStack.addMargins(top: 4, left: 5, bottm: 4, right: 5)
        dateStatusStack.easy.layout([
            Bottom(14), Trailing(14)
        ])
        
        dateBg = dateStatusStack.addBackground(color: .black.withAlphaComponent(0.6),
                                               cornerRadius: 10)
    }
}
