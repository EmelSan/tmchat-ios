//
//  TextMsgContentView.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit
import EasyPeasy

class TextMsgContentView: MsgContentView {

    var msgStack = UIView()
    
    var msgText: UITextView = {
        let t = UITextView()
        t.backgroundColor = .clear
        t.font = .sb_16_r
        t.isScrollEnabled = false
        t.isEditable = false
        t.textContainer.lineFragmentPadding = 0
        t.textContainerInset = .zero
        t.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        t.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentStack.addArrangedSubviews([repliedMsgView,
                                          msgStack])
    }

    func calculateWidth(text: String){
        msgText.text = text
        setupWithNormalDate()
//
//        let numberOfLines = text.height(withConstrainedWidth: DeviceDimensions.textMsgLineWidth, font: .sb_16_r!)/19
//
//        let width = text.width(withConstrainedHeight: 19, font: .sb_16_r!)
//
//        let difference = (numberOfLines * DeviceDimensions.textMsgLineWidth) - width
//
//        if difference >= 100 {
//            setupwithCompactedDate(numOfLines: numberOfLines)
//        } else {
//            setupWithNormalDate()
//        }
    }
    
    func setupwithCompactedDate(numOfLines: CGFloat){
        msgStack.addSubview(msgText)
        msgText.easy.layout([
            Top(), Leading(), Trailing(), Bottom()
        ])
        
        msgStack.addSubview(dateStatusStack)
        dateStatusStack.easy.layout([
            Trailing(), Bottom()
        ])

        if numOfLines == 1 {
            msgText.easy.layout([
                Trailing(10).to(dateStatusStack, .leading)
            ])
        }
    }
    
    func setupWithNormalDate(){
        msgStack.addSubview(msgText)
        msgText.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        msgStack.addSubview(dateStatusStack)
        dateStatusStack.easy.layout([
            Top(6).to(msgText, .bottom), Trailing(), Bottom(), Leading(>=0),
        ])
    }
}
