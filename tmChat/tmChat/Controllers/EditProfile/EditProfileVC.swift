//
//  EditProfileVC.swift
//  tmchat
//
//  Created by Shirin on 3/18/23.
//

import UIKit
import TLPhotoPicker
import CropViewController

class EditProfileVC: UIViewController {

    var viewModel = EditProfileVM()
    
    var profileImg: UIImage?
    var uploadImg: UploadImage?
    
    var mainView: EditProfileView {
        return view as! EditProfileView
    }

    override func loadView() {
        super.loadView()
        view = EditProfileView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addNotification()
        setupCallbacks()
        setupBindings()
        
        viewModel.getUser()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.user.bind { [weak self] user in
            if user == nil && self?.viewModel.inProgress.value == false {
                self?.mainView.showNoConnection()
            } else {
                self?.mainView.hideNoConnection()
                self?.setupData(user: user)
            }
        }
        
        viewModel.success.bind { [weak self] succes in
            if succes {
                let count = self?.navigationController?.viewControllers.count ?? 0
                if count - 2 >= 0 {
                    let vc = self?.navigationController?.viewControllers[count-2] as? ProfileVC
                    vc?.viewModel.getUser()
                }
                
                ProfileVC.toUpdate = true
                FeedVC.toUpdate = true
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            guard let data = self?.getData() else { return }
            self?.viewModel.updateProfile(data: data, img: self?.uploadImg)
        }
        
        mainView.camerBtn.clickCallback = { [weak self] in
            self?.presentPicker()
        }
    }
    
    func setupData(user: User?){
        guard let user = user else { return }
        mainView.name.setValue(user.firstName)
        mainView.surname.setValue(user.lastName)
        mainView.nickname.setValue(user.username)
        mainView.about.setValue(user.description)
        if (user.avatar ?? "").isEmpty == false {
            mainView.img.kf.setImage(with: ApiPath.url(user.avatar!))
        }
    }
    
    func getData() -> UpdateUserParams? {
        guard let username = mainView.nickname.getValue() else { return nil }
        if profileImg != nil {
            uploadImg = UploadImage(uploadName: "file",
                                    filename: "some_name.jpeg",
                                    data: profileImg?.jpegData(compressionQuality: 0.75))
        }

        let usernameToSend = username == AccUserDefaults.username || username == (viewModel.user.value?.username ?? "")
                                    ? nil : username

        return UpdateUserParams(username: usernameToSend,
                                firstName: mainView.name.getValue(withChecking: false),
                                lastName: mainView.surname.getValue(withChecking: false),
                                description: mainView.about.getValue(withChecking: false))
    }
    
    func presentPicker(){
        let vc = TLPhotosPickerViewController()
        vc.configure.allowedVideo = false
        vc.configure.singleSelectedMode = true
        vc.configure.allowedVideoRecording = false
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func presentCropper(){
        let vc = CropViewController(croppingStyle: .default,
                                    image: profileImg ?? UIImage())
        vc.aspectRatioPickerButtonHidden = true
        vc.aspectRatioLockEnabled = true
        vc.aspectRatioPreset = .presetSquare
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension EditProfileVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        profileImg = withTLPHAssets.first?.fullResolutionImage
    }
    
    func dismissComplete() {
        presentCropper()
    }
}

extension EditProfileVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        profileImg = image
        mainView.img.image = profileImg
    }
}
