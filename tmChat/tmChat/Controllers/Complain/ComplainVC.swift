//
//  ComplainVC.swift
//  tmchat
//
//  Created by Shirin on 4/18/23.
//

import UIKit

class ComplainVC: UIViewController {

    var viewModel = ComplainVM()
    
    var mainView: ComplainView {
        return view as! ComplainView
    }

    override func loadView() {
        super.loadView()
        view = ComplainView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        setupBindings()
    }
       
    func setupBindings(){
        viewModel.success.bind { [weak self] success in
            if success == false { return }
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            guard let text = self?.mainView.textView.getValue() else { return }
            self?.viewModel.sendReport(text: text)
        }
        
        mainView.textView.editing = { [weak self] val in
            self?.mainView.header.trailingBtn.imageView?.tintColor = val.isEmpty ? .blade : .accent
        }
    }
}
