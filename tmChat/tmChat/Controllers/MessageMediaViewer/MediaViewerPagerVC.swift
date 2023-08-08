//
//  MediaViewerPagerVC.swift
//  tmchat
//
//  Created by Shirin on 4/14/23.
//

import UIKit
import EasyPeasy
import Photos
import Kingfisher

class MediaViewerPagerVC: UIPageViewController {

    weak var presenterVM: MessagingVM?
    
    var header = MediaViewerHeader()
    var footer = MediaViewerFooter()
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?

    var roomName = ""
    var data: [Message] = []
    var VCs: [UIViewController] = [UIViewController]()
    var currentInd : Int = 0

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(PanGestureRecognizer(direction: .vertical,
                                                       target: self,
                                                       action: #selector(panGesture(_:))))

        setupView()
        setupCallbacks()
        setupData()

        modalPresentationCapturesStatusBarAppearance = true
        setViewControllers([VCs[currentInd]], direction: .forward, animated: false, completion: nil)
    }
    
    func setupView(){
        view.backgroundColor = .black
        view.addSubview(header)
        header.backgroundColor = .black.withAlphaComponent(0.4)
        header.easy.layout([
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(), Trailing()
        ])
        
        view.addSubview(footer)
        footer.backgroundColor = .black.withAlphaComponent(0.4)
        footer.easy.layout([
            Bottom().to(view.safeAreaLayoutGuide, .bottom),
            Leading(), Trailing()
        ])
    }
    
    func setupData(){
        dataSource = self

        for i in 0..<data.count {
            let vc = viewControllerAtIndex(index: i)
            VCs.append(vc ?? UIViewController())
        }
    }
    
    func viewControllerAtIndex(index: Int) -> MediaViewerVC? {
        if data.count == 0 || index >= data.count || index < 0 { return nil }
        let msg = data[index]
        let vc = MediaViewerVC()
        vc.footer = footer
        vc.index = index
        vc.data = msg
        vc.onDidAppear = { [weak self] in
            self?.footer.progressBar.maximumValue = Float(msg.duration ?? 0)
            self?.footer.total.text = (msg.duration ?? 0).getHourMinSec()

            self?.header.count.text = "\(index+1)/\(self?.data.count ?? 0)"
            self?.header.senderName.text = msg.senderUUID == AccUserDefaults.id
                                            ? AccUserDefaults.username
                                            : self?.presenterVM?.room?.roomName ?? ""
            self?.footer.setup(for: msg.type)
        }
        
        vc.updateSliderValue = { [weak self] in
            let currentTime = Float(vc.currentTime ?? 0)
            self?.footer.progressBar.value = Float(currentTime)
            self?.footer.current.text = Int64(currentTime).getHourMinSec()
        }
        
        return vc
    }
    
    func setupCallbacks(){
        header.backBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        header.shareBtn.clickCallback = { [weak self] in
            guard let s = self else { return }
            let url = s.data[s.currentInd].fileUrl
            UIPasteboard.general.string = url
            PopUpLauncher.showSuccessMessage(text: "copied".localized())
        }

        footer.downloadBtn.clickCallback = { [weak self] in
            guard let s = self else { return }
            let msg = s.data[s.currentInd]
            if msg.type == MsgType.video.rawValue {
                s.saveVideo(message: msg)
            } else {
                s.saveImg(message: msg)
            }
        }

        footer.forwardBtn.clickCallback = { [weak self] in
            guard let s = self else { return }
            let vc = ContactListVC()
            vc.viewModel.params = PaginationParams(page: 1, id: AccUserDefaults.id)
            vc.type = .forward
            vc.mainView.sendBtn.clickCallback = { [weak self] in
                vc.dismiss(animated: true)
                self?.presenterVM?.forwardMsgs(toUsers: vc.selectedContacts,
                                               selectedMsgs: [s.data[s.currentInd]])
            }
            self?.present(vc, animated: true)
        }
    }
    
    func saveVideo(message: Message){
        let url = FileManager.default.getDocDir().appendingPathComponent(message.content)

        PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)}) { success, error in
            DispatchQueue.main.async {
                if success {
                    PopUpLauncher.showSuccessMessage(text: "saved".localized())

                } else {
                    PopUpLauncher.showErrorMessage(text: "could_not_save".localized())
                }
            }
        }
    }

    
    func saveImg(message: Message){
        guard let fileUrl = message.fileUrl else {
            PopUpLauncher.showErrorMessage(text: "could_not_save".localized())
            return
        }
        
        guard let url = URL(string: fileUrl) else { return }
        KingfisherManager.shared.retrieveImage(with: url) { receivedSize, totalSize in
            print(receivedSize, totalSize)
        } completionHandler: { result in
            switch result {
            case .success(let value):
                let img: UIImage = value.image
                UIImageWriteToSavedPhotosAlbum(img, self,  #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            case .failure(_):
                PopUpLauncher.showErrorMessage(text: "could_not_download".localized())
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            PopUpLauncher.showErrorMessage(text: "could_not_save".localized())
        } else {
            PopUpLauncher.showSuccessMessage(text: "saved".localized())
        }
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            originalPosition = self.view.center
            currentPositionTouched = sender.location(in: view)
        
        case .changed:
            view.frame.origin = CGPoint(x: 0, y: translation.y > 0 ? translation.y : 0 )
        
        case .ended, .cancelled:
            if view.frame.origin.y > 200 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame.origin = CGPoint( x: 0, y: self.view.frame.size.height )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: true)
                    }
                })
                
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition! })
            }
            
        case .failed, .possible:
            UIView.animate(withDuration: 0.2, animations: {
                self.view.center = self.originalPosition! })
            
        
        @unknown default:
            return
        }
    }
}

extension MediaViewerPagerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCs.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard VCs.count > previousIndex else { return nil }
        return VCs[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCs.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < VCs.count else { return nil }
        guard VCs.count > nextIndex else { return nil }

        return VCs[nextIndex]
    }
}
