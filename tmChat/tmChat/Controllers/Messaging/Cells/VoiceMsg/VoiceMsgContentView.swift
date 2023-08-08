//
//  VoiceMsgContentView.swift
//  tmchat
//
//  Created by Shirin on 4/11/23.
//

import UIKit
import EasyPeasy

class VoiceMsgContentView: MsgContentView {

    var voiceStack = UIStackView(axis: .horizontal,
                                alignment: .top,
                                spacing: 6)
    
    var statusWrapper = UIStackView(axis: .horizontal,
                                    alignment: .fill,
                                    spacing: 6)

    var icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: 36/2,
                           image: UIImage(named: "play-voice"),
                           backgroundColor: .accent)
    

    var progressBar: UISlider = {
        let s = UISlider()
        s.tintColor = .accent
        s.setThumbImage(UIImage(named: "thumb"), for: .normal)
        return s
    }()
    
    var duration = UILabel(font: .minitext_12,
                           color: .blade,
                           alignment: .left,
                           numOfLines: 1)
    
    let progress = CustomProgressView(colors: [.white], lineWidth: 3, bgColor: .accent)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFileStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentStack.addArrangedSubviews([voiceStack,
                                          statusWrapper])
        
        statusWrapper.addArrangedSubviews([UIView(),
                                           dateStatusStack])
    }
    
    func setupFileStack(){
        easy.layout(Width(DeviceDimensions.textMsgLineWidth * 0.8))
        
        icon.easy.layout(Size(36))
        icon.addSubview(progress)
        progress.easy.layout([
            Center(), Size(18)
        ])
        
        progressBar.easy.layout([
            Height(30)
        ])

        voiceStack.addArrangedSubviews([icon,
                                        progressBar])
        
        addSubview(duration)
        duration.easy.layout([
            Bottom().to(icon, .bottom), Leading().to(progressBar, .leading)
        ])
    }
}
