//
//  MsgContentView.swift
//  tmchat
//
//  Created by Shirin on 3/20/23.
//

import UIKit
import EasyPeasy

class MsgView: UIStackView {

    var checkbox = MsgSelectionBtn(frame: .zero)
    
    var msgWrapper = CustomCornerView()
    
    var spacer = UIView()
    
    var msgContent: MsgContentView?
    
    var replyIcon = MsgCellReplyIcon()
    
    var selectionOverlay = BaseBtn()
    
    var isOwn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alignment = .center
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addMargins(left: 8, right: 8)
        
        addArrangedSubviews([checkbox,
                             msgWrapper,
                             replyIcon])
        
        addSubview(selectionOverlay)
        selectionOverlay.isHidden = true
        selectionOverlay.easy.layout(Edges())
        
        spacer.easy.layout(Width(>=80))
        spacer.backgroundColor = .blue

        setCustomSpacing(8, after: checkbox)
        setCustomSpacing(8, after: msgWrapper)
    }
    
    func addMsgContentView(isOwn: Bool, content: MsgContentView, withPadding: Bool = true, withBgColor: Bool = true){
        self.isOwn = isOwn
        msgContent = content
        msgContent?.status.isHidden = !isOwn
        msgWrapper.addSubview(content)
        
        if withPadding {
            content.easy.layout([
                Top(8), Leading(10), Trailing(10), Bottom(8)
            ])
        } else {
            content.easy.layout([
                Edges()
            ])
        }
        
        if isOwn {
            insertArrangedSubview(spacer, at: 1)
            msgWrapper.backgroundColor = .ownMsgBg
            
        } else {
            insertArrangedSubview(spacer, at: 2)
            msgWrapper.backgroundColor = .otherMsgBg
        }
        
        if !withBgColor {
            msgWrapper.backgroundColor = .clear
        }
    }
}
