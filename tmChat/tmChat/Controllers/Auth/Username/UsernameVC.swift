//
//  UsernameVC.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit

enum NameVCType {
    case username
    case name
}

class UsernameVC: UIViewController {
    
    var vcType = NameVCType.name
    
    let viewModel = UsernameVM()
    
    var mainView: UsernameView {
        return view as! UsernameView
    }
    
    override func loadView() {
        super.loadView()
        view = UsernameView()
        view.backgroundColor = .bg
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        hideKeyboardWhenTappedAround()
        
        if vcType == .name {
            mainView.setupForName()
        }
        
        setupCallbacks()
        setupBindings()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.response.bind { [weak self] user in
            if user == nil { return }

            if user?.firstName == nil {
                self?.openName()
            } else {
                self?.openTabbar()
            }
        }
    }
    
    func setupCallbacks(){
        mainView.continueBtn.clickCallback = { [weak self] in
            self?.getName()
        }
    }
    
    func getName() {
        if vcType == .name {
            guard let name = mainView.name.getValue() else { return }
            viewModel.sendName(name)
        } else {
            guard let name = mainView.name.isValidUsername() else { return }
            viewModel.sendUserName(name)
        }
    }
    
    func openName(){
        viewModel.inProgress.value = false
        let vc = UsernameVC()
        vc.vcType = .name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openTabbar(){
        navigationController?.setViewControllers([TabbarController()], animated: true)
    }
}
