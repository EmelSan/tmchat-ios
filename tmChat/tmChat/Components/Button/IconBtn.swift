//
//  IconBtn.swift
//  Guncha
//
//  Created by Shirin on 2/10/23.
//

import UIKit
import EasyPeasy

class IconBtn: BaseBtn {

    init(image: UIImage?, color: UIColor){
        super.init(frame: .zero)
        
        setImage(image, for: .normal)
        imageView?.tintColor = color
        
        easy.layout(Size(40))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
