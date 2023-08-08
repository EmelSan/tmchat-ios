//
//  ImgCell.swift
//  tmchat
//
//  Created by Shirin on 3/12/23.
//

import UIKit
import EasyPeasy
import TLPhotoPicker

class ImgCell: UICollectionViewCell {
    
    static let id = "ImgCell"
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 6)
    
    var deleteBtn = IconBtn(image: UIImage(named: "delete-img"),
                            color: .blade)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(img)
        img.easy.layout(Edges())
        
        img.addSubview(deleteBtn)
        deleteBtn.easy.layout([
            Top(), Trailing(), Size(30)
        ])
    }
    
    func setupData(asset: TLPHAsset?){
        guard let asset = asset else { return }
        self.img.image = asset.fullResolutionImage
    }
    
    func setupData(img: UIImage?){
        self.img.image = img
    }
}
