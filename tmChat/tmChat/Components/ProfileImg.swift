//
//  ProfileImg.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class ProfileImg: UIView {
    
    var img = UIImageView(contentMode: .scaleAspectFill, cornerRadius: .zero)
    
    var suppView = UIImageView()
    
    var initials = UILabel(font: .sb_16_m,
                           color: .white,
                           alignment: .center,
                           numOfLines: 1)
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        addSubview(img)
        img.clipsToBounds = true
        img.backgroundColor = .lee
        img.easy.layout([Edges(), Size(size)])
        img.layer.cornerRadius = size/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: Room?){
        guard let data = data else { return }
        suppView.removeFromSuperview()
        if data.isActive == true { online() }
        if data.isNotificationEnabled == true { mute() }
        
        if data.avatar == nil {
            addSubview(initials)
            initials.text = Helpers.getInitials(name: data.username ?? "")
            initials.easy.layout(Edges())
            img.image = nil
        } else {
            img.kf.setImage(with: ApiPath.url(data.avatar ?? ""))
            initials.removeFromSuperview()
        }

        img.backgroundColor = UIColor(hexString: data.colorCode ?? "#A5A5A5")
    }
    
    func setupData(data: User?){
        guard let data = data else { return }
        suppView.removeFromSuperview()
        img.backgroundColor = UIColor(hexString: data.colorCode ?? "#A5A5A5")

        if data.avatar == nil {
            addSubview(initials)
            initials.text = Helpers.getInitials(name: data.username ?? "")
            initials.easy.layout(Edges())
        } else {
            img.kf.setImage(with: ApiPath.url(data.avatar ?? ""))
            initials.removeFromSuperview()
        }
    }

    
    func mute(){
        addSubview(suppView)
        suppView.image = UIImage(named: "mute")
        suppView.easy.layout([
            Size(16), Trailing(-2), Bottom(-2)
        ])
    }
    
    
    func online(){
        addSubview(suppView)
        suppView.image = UIImage(named: "online")
        suppView.easy.layout([
            Size(16), Trailing(-4), Bottom(-4)
        ])
    }
}
