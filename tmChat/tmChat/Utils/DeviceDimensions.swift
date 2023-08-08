//
//  DeviceDimensions.swift
//  tmchat
//
//  Created by Shirin on 3/21/23.
//

import UIKit

class DeviceDimensions {
    
    static let width = UIScreen.main.bounds.size.width
    
    static let safeAreaHeight = height - topInset - bottomInset
    
    static let height = UIScreen.main.bounds.size.height
    
    static let topInset = UIApplication.shared.windows
        .filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
    
    static let bottomInset = UIApplication.shared.windows
        .filter{$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
    
    static let postCellDimensions = CGSize(width: width,
                                           height: width/1.125)
    
    static let imgCellDimensions = CGSize(width: (width-54)/3,
                                          height: (width-54)/3)
    
    static let imgListCellDimensions = CGSize(width: (width-4)/3,
                                              height: (width-4)/3)

    static let textMsgLineWidth = width - 80 - 16 - 20
}
