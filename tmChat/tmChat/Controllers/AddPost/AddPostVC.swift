//
//  AddPostVC.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import TLPhotoPicker
import Photos
import CropViewController

class AddPostVC: UIViewController {

    let viewModel = AddPostVM()
    var editingAtInd = -1
    var selectedAssets: [TLPHAsset] = []
    var uploadImgs: [UploadImage] = []
    var images: [UIImage?] = []
    
    var sheetTransitioningDelegate = SheetTransitioningDelegate()
    var postPemisionType: PostPermissionType = .contacts

    var mainView: AddPostView {
        return view as! AddPostView
    }

    override func loadView() {
        super.loadView()
        view = AddPostView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addNotification()
        mainView.imageList.delegate = self
        mainView.imageList.images = []
        
        setupCallbacks()
        setupBindings()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.success.bind { [weak self] succes in
            if succes {
                ProfileVC.toUpdate = true
                FeedVC.toUpdate = true
                self?.dismiss(animated: true)
            }
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        mainView.attachBtn.clickCallback = { [weak self] in
            self?.openPicker()
        }
        
//        mainView.timerBtn.clickCallback = { [weak self] in
//            print("open date picker ")
//        }

        mainView.incognito.clickCallback = { [weak self] in
            let vc = AddPostIncognitoBS()
            vc.selected = self?.postPemisionType ?? .contacts
            vc.optionClickCallback = { [weak self] option in
                self?.postPemisionType = option
                vc.dismiss(animated: true)
            }
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self?.sheetTransitioningDelegate
            self?.present(vc, animated: true)
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            guard let postData = self?.getPostData() else { return }
            self?.mainView.loading(true)
            self?.getUploadData { files in
                if files.isEmpty && postData["description"]?.isEmpty == true {
                    PopUpLauncher.showErrorMessage(text: "empty_post_error".localized())
                    return
                }
                self?.viewModel.addPost(params: postData, files: files)
            }
        }
    }
    
    func openPicker(){
        let vc = TLPhotosPickerViewController()
        vc.configure.allowedVideo = false
        vc.configure.maxSelectedAssets = 9-selectedAssets.count
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func getPostData() -> [String: String]? {
        var params: [String: String] = [:]
        params["visibility"] = postPemisionType.rawValue
        params["description"] = mainView.postDescription()
        params["publishAt"] = Date().getTimeStamp()
        params["isLikeable"] = "\(mainView.reactions.isChecked)"
        params["isCommentable"] = "\(mainView.comments.isChecked)"
        return params
    }
    
    func getUploadData(completion: @escaping ([UploadImage])->() ){
        if selectedAssets.isEmpty {
            completion([])
            return
        }
        
        var result: [UploadImage] = []

        selectedAssets.forEach { asset in
            asset.tempCopyMediaFile { url, _ in
                print(url)
                let d = try? (asset.type == .video ? Data(contentsOf: url) : asset.fullResolutionImage?.jpegData(compressionQuality: 0.75))
                
                result.append(UploadImage(type: asset.type == .video
                                                        ? MsgType.video.rawValue
                                                        : MsgType.image.rawValue,
                                                   uploadName: asset.type == .video
                                                                ? "videos"
                                                                : "images",
                                                   filename: asset.originalFileName,
                                                   data: d))
                
                if result.count == self.selectedAssets.count {
                    completion(result)
                }
            }
        }
    }
}

extension AddPostVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        selectedAssets.append(contentsOf: withTLPHAssets)
        images.append(contentsOf: withTLPHAssets.map({$0.fullResolutionImage}))
        mainView.imageList.images = images
        mainView.attachBtn.title.text = selectedAssets.count == 0
                                            ? "attach".localized()
                                            : "\(selectedAssets.count)"
    }
}

extension AddPostVC: ImageListDelegate {
    func imageClicked(_ atIndex: Int) {
        if selectedAssets[atIndex].type == .video {
            
        } else {
            editingAtInd = atIndex
            presentCrop()
        }
    }
    
    func deleteClicked(_ atIndex: Int) {
        selectedAssets.remove(at: atIndex)
        images.remove(at: atIndex)
        mainView.imageList.images = images
        mainView.attachBtn.title.text = selectedAssets.count == 0
                                            ? "attach".localized()
                                            : "\(selectedAssets.count)"
    }
}

extension AddPostVC: CropViewControllerDelegate {
    func presentCrop() {
        guard let img = images[editingAtInd] else {
            return
        }
        
        let vc = CropViewController(croppingStyle: .default,
                                                    image: img)
        vc.delegate = self
        vc.customAspectRatio = DeviceDimensions.postCellDimensions
        vc.aspectRatioLockEnabled = true
        present(vc, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        images[editingAtInd] = image
        cropViewController.dismiss(animated: true, completion: { [weak self] in
            self?.mainView.imageList.images = self?.images ?? []
        })
    }
}
