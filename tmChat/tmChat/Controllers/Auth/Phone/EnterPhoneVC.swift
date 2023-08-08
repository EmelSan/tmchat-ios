//
//  EnterPhoneVC.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import Localize_Swift

class EnterPhoneVC: UIViewController {
    
    let viewModel = EnterPhoneVM()
    
    var mainView: EnterPhoneView {
        return view as! EnterPhoneView
    }
    
    override func loadView() {
        super.loadView()
        view = EnterPhoneView()
        view.backgroundColor = .bg
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        hideKeyboardWhenTappedAround()
        mainView.setupWithoutHeader()
        
        setupCallbacks()
        setupBindings()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.userId.bind { [weak self] userId in
            if userId == nil { return }
            AccUserDefaults.id = userId ?? ""
            self?.openOtp()
        }
    }
    
    func setupCallbacks(){
        mainView.continueBtn.clickCallback = { [weak self] in
            self?.getPhone()
        }
        
        mainView.inTurkmenBtn.clickCallback = { [weak self] in
            Localize.setCurrentLanguage("tk")
            self?.getPhone()
        }
        
        mainView.inEnglishBtn.clickCallback = { [weak self] in
            Localize.setCurrentLanguage("en")
            self?.getPhone()
        }
    }
    
    func getPhone() {
        guard let phone = mainView.phone.isValidPhoneNumber() else { return }
        
        viewModel.sendOtp(phone)
    }
    
    func openOtp(){
        let vc = OtpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
