//
//  ChatProfileVC.swift
//  tmchat
//
//  Created by Shirin on 3/13/23.
//

import UIKit
import Parchment
import EasyPeasy
import MXParallaxHeader

class ChatProfileVC: MXScrollViewController {
    
    let header = ChatProfileHeaderVC()

    let pageVC = ChatProfilePageVC()

    var sheetTransitioningDelegate = SheetTransitioningDelegate()

    var viewModel: MessagingVM!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerViewController = header
        childViewController = pageVC
        
        headerViewController?.parallaxHeader?.minimumHeight = 460
        headerViewController?.parallaxHeader?.delegate = header

        setupCallbacks()
        header.setupData(room: viewModel.room)
    }
    

    func setupCallbacks(){
        header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        header.mainView.profileBtn.clickCallback = { [weak self] in
            let vc = ProfileVC(type: .user(id: self?.viewModel.room?.userId ?? ""))
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        header.mainView.deleteBtn.clickCallback = { [weak self] in
            self?.openDeleteConfirmationBS()
        }
    }
    
    func openDeleteConfirmationBS(){
        let vc = DeleteConfirmationBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.deleteBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.popToChatlsit()
        }
        present(vc, animated: true)
    }
    
    func popToChatlsit(){
        let ind = (self.navigationController?.viewControllers.count ?? 0) - 3
        if ind < 0 { return }
        
        guard let vc = self.navigationController?.viewControllers[ind] as? ChatlistVC else { return }
        guard let room = viewModel.room else { return }
        vc.viewModel.deleteRoom(room: room)
        self.navigationController?.popToViewController(vc, animated: true)
    }
}


class ChatProfileHeaderVC: UIViewController, MXParallaxHeaderDelegate {
    
    var heightSet = false
    var isSnapped = false {
        willSet {
            if newValue != self.isSnapped {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
    }
    
    var minHeight: CGFloat = 0
    var initialInset: CGFloat = 0
    var initialHeight: CGFloat = 0

    var topBg = UIView()
    
    var backBtn = IconBtn(image: UIImage(named: "back"), color: .blade)
    
    var header = UserDataStack()

    var mainView: ChatProfileViewHeader = ChatProfileViewHeader()
    
    var didLayoutCallback: ( ()->() )?
    
    var a = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        heightSet = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if initialHeight == 0 {
            minHeight = header.frame.size.height
            header.easy.layout(Height(header.frame.size.height))

            initialHeight = mainView.frame.size.height
            mainView.easy.layout(Height(initialHeight + 100))
            didLayoutCallback?()
        }
    }
    
    func setupData(room: Room?){
        header.trailingBtn.isHidden = true
        header.setupData(room)
        mainView.setupData(room: room)
    }
    
    func setupView(){
        view.addSubview(mainView)
        mainView.isHidden = false
        mainView.easy.layout([
            Top(DeviceDimensions.topInset), Leading(), Trailing()
        ])
        
        view.addSubview(header)
        header.isHidden = true
        header.easy.layout([
            Top(DeviceDimensions.topInset), Leading(40), Trailing()
        ])
        
        view.addSubview(topBg)
        topBg.backgroundColor = .bg
        topBg.easy.layout([
            Leading(), Trailing(), Top(), Height(DeviceDimensions.topInset)
        ])
        
        view.addSubview(backBtn)
        backBtn.easy.layout([
            Top(DeviceDimensions.topInset + 10), Leading(10)
        ])
    }

    func setHeight(toSnap: Bool){
        if toSnap {
            parallaxHeader?.height = minHeight+DeviceDimensions.topInset+20
            parallaxHeader?.minimumHeight = minHeight+DeviceDimensions.topInset+20
        } else {
            parallaxHeader?.height = initialHeight
            parallaxHeader?.minimumHeight = minHeight+DeviceDimensions.topInset+20
        }
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if !heightSet {
            heightSet = true
            setHeight(toSnap: isSnapped)
            return
        }

        if initialInset >= 0 {
            initialInset = parallaxHeader.progress
            return
        }
        
        let progress = parallaxHeader.progress
        let offset = initialHeight-(initialHeight*progress)

        if (progress > 0.1 && progress < 1) && isSnapped {
            setHeight(toSnap: false)
            isSnapped = false
            return
        }
        
        if progress > 1 {
            isSnapped = false
            header.isHidden = true
            mainView.isHidden = false

        } else {

            if offset > 20 {
                if !isSnapped {
                    isSnapped = true
                    header.isHidden = false
                    mainView.isHidden = true
                    setHeight(toSnap: isSnapped)
                }
            }
        }
    }
}
