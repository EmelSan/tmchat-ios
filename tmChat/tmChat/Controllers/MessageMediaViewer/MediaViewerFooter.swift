//
//  MediaViewerFooter.swift
//  tmchat
//
//  Created by Shirin on 4/13/23.
//

import UIKit

class MediaViewerFooter: UIStackView {
    
    var progressStack = UIStackView(axis: .horizontal,
                               alignment: .fill,
                               spacing: 10,
                               edgeInsets: .zero)

    var current = UILabel(font: .minitext_12,
                          color: .white,
                          alignment: .left,
                          numOfLines: 1,
                          text: "00:00")
    
    var progressBar: UISlider = {
        let s = UISlider()
        s.tintColor = .white
        s.setThumbImage(UIImage(named: "thumb")?.withRenderingMode(.alwaysTemplate),
                        for: .normal)
        s.isUserInteractionEnabled = false
        return s
    }()
    
    var total = UILabel(font: .minitext_12,
                        color: .white,
                        alignment: .left,
                        numOfLines: 1,
                        text: "11:11:11")
    
    var btnStack = UIStackView(axis: .horizontal,
                               alignment: .fill,
                               spacing: 10,
                               distribution: .equalCentering)
    
    var downloadBtn = IconBtn(image: UIImage(named: "download")?.withRenderingMode(.alwaysTemplate),
                              color: .white)

    var pauseBtn = IconBtn(image: UIImage(named: "play")?.withRenderingMode(.alwaysTemplate),
                           color: .white)

    var forwardBtn = IconBtn(image: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate), color: .white)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        addMargins(top: 10, left: 14, bottm: 10, right: 14)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        axis = .vertical
        spacing = 12
        
        addArrangedSubviews([progressStack,
                            btnStack])
        
        progressStack.addArrangedSubviews([current,
                                           progressBar,
                                           total])
        
        btnStack.addArrangedSubviews([downloadBtn,
                                      pauseBtn,
                                      forwardBtn])
    }
    
    func setup(for type: MsgType.RawValue){
        if type == MsgType.video.rawValue {
            setupForVideo()
        } else {
            setupForImg()
        }
    }
    
    func setupForImg(){
        progressStack.isHidden = true
        pauseBtn.isHidden = true
    }
    
    func setupForVideo(){
        progressStack.isHidden = false
        pauseBtn.isHidden = false
    }
    
    func setupPlayIcon(isPlaying: Bool?){
        let img = UIImage(named: isPlaying == true ? "play" : "pause")
        pauseBtn.setImage(img, for: .normal)
    }
}
