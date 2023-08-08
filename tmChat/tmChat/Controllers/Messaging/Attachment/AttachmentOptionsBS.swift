//
//  AttachmentOptionsBS.swift
//  tmchat
//
//  Created by Shirin on 3/16/23.
//

import UIKit

class AttachmentOptionsBS: UIViewController {

    weak var delegate: AttachmentDelegate?
    
    var cameraBtn = BottomSheetBtn(title: "take_img".localized(),
                                     iconName: "camera")
    
    var mediaBtn = BottomSheetBtn(title: "media".localized(),
                                  iconName: "image")
    
    var fileBtn = BottomSheetBtn(title: "file".localized(),
                                 iconName: "file")
    
    var contactBtn = BottomSheetBtn(title: "contact".localized(),
                                    iconName: "profile-empty")

    var locationBtn = BottomSheetBtn(title: "location".localized(),
                                    iconName: "location")

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
        setupContent()
        setupClicks()
    }
    
    func setupContent(){
        mainView.title.text = "messaging_actions".localized()
        mainView.desc.text = "drag_down_to_dismis".localized()

        mainView.btnStack.addArrangedSubviews([cameraBtn,
                                               mediaBtn,
                                               fileBtn,
//                                               contactBtn,
//                                               locationBtn
                                              ])
    }
    
    func setupClicks(){
        cameraBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.takeImg()
            }
        }
        
        mediaBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.openMediaPicker()
            }
        }

        fileBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.openFilePicker()
            }
        }

        contactBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.openContactList()
            }
        }

        locationBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.openLocationPicker()
            }
        }
    }
}
