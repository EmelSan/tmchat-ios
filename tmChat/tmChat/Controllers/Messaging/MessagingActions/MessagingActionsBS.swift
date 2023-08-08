//
//  MessagingActionsBS.swift
//  tmchat
//
//  Created by Shirin on 3/16/23.
//

import UIKit

class MessagingActionsBS: UIViewController {

    weak var delegete: MessagingActionsDelegate?

    var chatInfoBtn = BottomSheetBtn(title: "chat_info".localized(),
                                     iconName: "info")
    
    var searchBtn = BottomSheetBtn(title: "search_in_chat".localized(),
                                   iconName: "search-profile")
    
    var callBtn = BottomSheetBtn(title: "call".localized(),
                                iconName: "audio")
    
    var clearRoomBtn = BottomSheetBtn(title: "clear_chat".localized(),
                                      iconName: "broom")

    var deleteBtn = BottomSheetBtn(title: "delete".localized(),
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
        mainView.title.text = "messaging_actions".localized()
        mainView.desc.text = "drag_down_to_dismis".localized()
        setupClicks()
    }
    
    func setupFullOptions(){
        mainView.btnStack.addArrangedSubviews([chatInfoBtn,
//                                               searchBtn,
                                               callBtn,
                                               clearRoomBtn,
                                               deleteBtn])
    }
    
    func setupShortenOptions(){
        mainView.btnStack.addArrangedSubviews([clearRoomBtn,
                                               deleteBtn])
    }
    
    func setupClicks(){
        chatInfoBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.openChatProfile()
            }
        }
        
        searchBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.openSearch()
            }
        }
        
        callBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.call()
            }
        }

        clearRoomBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.clearRoom()
            }
        }

        deleteBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegete?.deleteRoom()
            }
        }

    }
}
