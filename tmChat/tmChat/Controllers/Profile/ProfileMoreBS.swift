//
//  ProfileMoreBS.swift
//  tmchat
//
//  Created by Shirin on 4/17/23.
//

import UIKit

class ProfileMoreBS: UIViewController {

    weak var delegete: ProfileMoreDelegate?

    var editBtn = BottomSheetBtn(title: "open_edit".localized(),
                                 iconName: "info")
    
    var complainBtn = BottomSheetBtn(title: "complain".localized(),
                                     iconName: "info")
    
    var copyBtn = BottomSheetBtn(title: "copy_username".localized(),
                                 iconName: "save")

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

        setupClicks()
    }
    
    func setupOtherOptions(){
        mainView.btnStack.addArrangedSubviews([copyBtn,
                                               complainBtn])
    }
    
    func setupOwnOptions(){
        mainView.btnStack.addArrangedSubviews([editBtn,
                                               copyBtn])
    }
    
    func setupClicks(){
        copyBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.copyUsername()
            }
        }

        editBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.openEdit()
            }
        }

        complainBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.complain()
            }
        }
    }
}
