//
//  SelectLangBS.swift
//  tmchat
//
//  Created by Shirin on 4/29/23.
//

import UIKit
import Localize_Swift

class SelectLangBS: UIViewController {
        
    var tk = BottomSheetBtn(title: "tk".localized(),
                             iconName: "")
    
    var ru = BottomSheetBtn(title: "ru".localized(),
                            iconName: "ru")

    var en = BottomSheetBtn(title: "en".localized(),
                            iconName: "en")

    var langClickCallback: ( (String)->() )?
    
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
        mainView.title.text = "select_lang".localized()
        mainView.desc.text = ""

        setupContent()
        setupClicks()
    }
    
    func setupContent() {
        switch Lang(rawValue: AccUserDefaults.language) {
        case .tk:
            tk.addBorder(color: .accent)

        case .ru:
            ru.addBorder(color: .accent)
            
        case .en:
            en.addBorder(color: .accent)
            
        default:
            break
        }

        mainView.btnStack.addArrangedSubviews([tk, ru, en])
    }
    
    func setupClicks(){
        tk.clickCallback = { [weak self] in
            if AccUserDefaults.language == Lang.tk.rawValue { return }
            self?.tk.addBorder(color: .accent)
            self?.ru.addBorder(color: .clear)
            self?.en.addBorder(color: .clear)
            
            Localize.setCurrentLanguage("tk")
            AccUserDefaults.language = "tk"
            self?.langClickCallback?(Lang.tk.rawValue)
        }
        
        ru.clickCallback = { [weak self] in
            if AccUserDefaults.language == Lang.ru.rawValue { return }
            self?.tk.addBorder(color: .clear)
            self?.ru.addBorder(color: .accent)
            self?.en.addBorder(color: .clear)
            
            Localize.setCurrentLanguage("ru")
            AccUserDefaults.language = "ru"
            self?.langClickCallback?(Lang.ru.rawValue)
        }
        
        en.clickCallback = { [weak self] in
            if AccUserDefaults.language == Lang.en.rawValue { return }
            self?.tk.addBorder(color: .clear)
            self?.ru.addBorder(color: .clear)
            self?.en.addBorder(color: .accent)
            
            Localize.setCurrentLanguage("en")
            AccUserDefaults.language = "en"
            self?.langClickCallback?(Lang.ru.rawValue)
        }
    }
}

