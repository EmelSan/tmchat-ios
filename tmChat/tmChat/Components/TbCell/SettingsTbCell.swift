//
//  SettingsTbCell.swift
//  tmchat
//
//  Created by Shirin on 4/17/23.
//

import UIKit
import EasyPeasy

class SettingsTbCell: UITableViewCell {

    static let id = "SettingsTbCell"
    
    let contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                            verticalEdges: 12),
                                   backgroundColor: .white,
                                   cornerRadius: 10)
    
    var title = UILabel(font: .text_14_r,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 0)
    
    var subTitle = UILabel(font: .minitext_12,
                           color: .lee,
                           alignment: .right,
                           numOfLines: 0)
    

    var icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: .zero,
                           image: nil,
                           backgroundColor: .clear)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .bg
        selectionStyle = .none
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Top(8), Bottom(),
            Leading(16), Trailing(16)
        ])
        
        icon.easy.layout(Size(20))
        
        contentStack.addArrangedSubviews([title,
                                          UIView(),
                                          subTitle,
                                          icon])
    }
    
    func setupData(_ data: SettingModel){
        title.text = data.title.localized()
        
        if data.iconName != nil {
            icon.image = UIImage(named: data.iconName!)
        } else {
            icon.isHidden = true
        }
        
        switch data.type {
        case .language:
            subTitle.text = AccUserDefaults.language.localized()
            
        case .memory:
            subTitle.text = CacheManager.sizeOfAllCache()
            
        default:
            subTitle.text = data.subtitle?.localized()
        }
    }
}
