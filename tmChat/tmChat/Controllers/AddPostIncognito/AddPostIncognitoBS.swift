//
//  AddPostIncognitoBS.swift
//  tmchat
//
//  Created by Shirin on 3/17/23.
//

import UIKit

class AddPostIncognitoBS: UIViewController {
    
    var selected = PostPermissionType.contacts
    
    var all = BottomSheetBtn(title: "all".localized(),
                             iconName: "people")
    
    var contacts = BottomSheetBtn(title: "only_contacts".localized(),
                                  iconName: "profile-empty")
    
    var nobody = BottomSheetBtn(title: "nobody".localized(),
                                iconName: "nobody")

    var optionClickCallback: ( (PostPermissionType)->() )?
    
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
        mainView.title.text = "private_settings".localized()
        mainView.desc.text = "who_can_see_post".localized()

        setupContent()
        setupClicks()
    }
    
    func setupContent() {
        switch selected {
        case .all:
            all.addBorder(color: .accent)

        case .contacts:
            contacts.addBorder(color: .accent)
            
        case .nobody:
            nobody.addBorder(color: .accent)
        }

        mainView.btnStack.addArrangedSubviews([all,
                                               contacts,
                                               nobody])
    }
    
    func setupClicks(){
        all.clickCallback = { [weak self] in
            self?.all.addBorder(color: .accent)
            self?.contacts.addBorder(color: .clear)
            self?.nobody.addBorder(color: .clear)
            self?.optionClickCallback?(.all)
        }
        
        contacts.clickCallback = { [weak self] in
            self?.contacts.addBorder(color: .accent)
            self?.all.addBorder(color: .clear)
            self?.nobody.addBorder(color: .clear)
            self?.selected = .contacts
            self?.optionClickCallback?(.contacts)
        }

        nobody.clickCallback = { [weak self] in
            self?.nobody.addBorder(color: .accent)
            self?.contacts.addBorder(color: .clear)
            self?.all.addBorder(color: .clear)
            self?.selected = .nobody
            self?.optionClickCallback?(.nobody)
        }
    }
}
