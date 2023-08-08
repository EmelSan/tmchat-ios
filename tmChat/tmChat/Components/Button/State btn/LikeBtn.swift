//
//  LikeBtn.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class LikeBtn: UIView {
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 10, verticalEdges: 6))
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    var title = UILabel(font: .text_14_m,
                        color: .bapAccent,
                        alignment: .left,
                        numOfLines: 1)
    
    var data: LikeData? {
        didSet {
            setupData()
        }
    }
    
    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
              
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .bg
        layer.cornerRadius = 16
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1

        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        
        contentStack.addArrangedSubviews([icon,
                                          title])
        
        icon.easy.layout(Size(20))
        title.easy.layout(Height(20))
    }
    
    func setupLikedState(){
        contentStack.insertArrangedSubview(icon, at: 0)
        layer.borderColor = UIColor.alert.cgColor
        title.textColor = .alert
        icon.image = UIImage(named: "heart-red")
        title.text = data?.count ?? "0"
    }
    
    func setupNormalState(){
        layer.borderColor = UIColor.clear.cgColor
        title.textColor = .bapAccent
        if data?.count == "0" {
            contentStack.insertArrangedSubview(icon, at: 1)
            icon.image = UIImage(named: "heart-gray")
            title.text = "like".localized()
        } else {
            icon.removeFromSuperview()
            icon.image = nil
            title.text = "likes".localized() + ": \(data?.count ?? "0")"
        }
    }
    
    func setupData(){
        guard let data = data else { return }
        
        if data.isLiked {
            setupLikedState()
        } else {
            setupNormalState()
        }
    }
    
    @objc func click(){
        let count = Int(data?.count ?? "0") ?? 0
        data = LikeData(isLiked: data?.isLiked == true ? false : true,
                        count: data?.isLiked == true ? String(count-1): String(count+1))
        clickCallback?()
    }
}
