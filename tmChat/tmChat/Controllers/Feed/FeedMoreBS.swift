//
//  FeedMoreBS.swift
//  tmchat
//
//  Created by Shirin on 4/18/23.
//

import UIKit

class FeedMoreBS: UIViewController {
    
    var complainBtn = BottomSheetBtn(title: "complain".localized(),
                                     iconName: "info")
    
    var deleteBtn = BottomSheetBtn(title: "delete_post".localized(),
                                   iconName: "trash-empty")
    
    var saveImgBtn = BottomSheetBtn(title: "save_post_img".localized(),
                                   iconName: "save")
    
    var mainView: BottomSheetView {
        return view as! BottomSheetView
    }
    
    override func loadView() {
        super.loadView()
        view = BottomSheetView()
        view.backgroundColor = .bg
    }
}
