//
//  DeleteConfirmationBS.swift
//  tmchat
//
//  Created by Shirin on 3/16/23.
//

import UIKit

class DeleteConfirmationBS: UIViewController {

    var cancelBtn = BottomSheetBtn(title: "delete_no".localized(),
                                   iconName: "save")
    
    var deleteBtn = BottomSheetBtn(title: "delete_yes".localized(),
                                   iconName: "trash-empty",
                                   color: .alert)

    var mainView: BottomSheetView {
        return view as! BottomSheetView
    }

    override func loadView() {
        super.loadView()
        view = BottomSheetView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.title.text = "delete_room_title".localized()
        mainView.desc.text = "delete_room_desc".localized()

        setupContents()
    }
    
    func setupContents() {
        deleteBtn.addBorder(color: .alert)
        cancelBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true)
        }

        mainView.btnStack.addArrangedSubviews([cancelBtn,
                                               deleteBtn])
    }
}
