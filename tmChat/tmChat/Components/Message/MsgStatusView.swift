//
//  MsgStatusView.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class MsgStatusView: UILabel {

    var color = UIColor.lee
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .lee
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ status: MsgStatus.RawValue){
        if status.isEmpty { return }
        color(status != MsgStatus.error.rawValue ? color : .alert)
        font = status != MsgStatus.delivered.rawValue ? .minitext_12 : .metadata_12
        text = status.localized()
    }
    
    func color(_ color: UIColor){
        textColor = color
    }
}
