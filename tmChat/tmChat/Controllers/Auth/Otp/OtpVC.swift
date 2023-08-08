//
//  OtpVC.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit

class OtpVC: UIViewController {

    let viewModel = OtpVM()
    
    var mainView: OtpView {
        return view as! OtpView
    }
    
    override func loadView() {
        super.loadView()
        view = OtpView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        mainView.startTimer()
        setupCallbacks()
        setupBindings()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
            if toShow {
                self?.mainView.stopTimer()
            } else {
                self?.mainView.resumeTimer()
            }
        }
        
        viewModel.response.bind { [weak self] resp in
            guard let resp = resp else { return }
            if resp.user == nil {
                self?.openUsername()
            } else {
                self?.openTabbar()
            }
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.resendBtn.clickCallback = { [weak self] in
            self?.viewModel.resendOtp()
        }
        
        mainView.otpField.didReceiveCode = { [weak self] code in
            self?.viewModel.checkOtp(code)
        }
    }
        
    func openUsername(){
        viewModel.inProgress.value = false
        let vc = UsernameVC()
        vc.vcType = .username
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openTabbar(){
        navigationController?.setViewControllers([TabbarController()], animated: true)
    }
}
