//
//  FeedVC.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import Kingfisher

class FeedVC: UIViewController {
    static var toUpdate = false
    
    let viewModel = FeedVM()
    
    var posts: [PostData] = []
    
    var cellCount = 0
    
    var sheetTransitioningDelegate = SheetTransitioningDelegate()

    var offset: CGFloat = 0
    
    var mainView: FeedView {
        return view as! FeedView
    }
    
    override func loadView() {
        super.loadView()
        view = FeedView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self

        setupCallbacks()
        setupBindings()

        viewModel.getFeed(forPage: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FeedVC.toUpdate {
            FeedVC.toUpdate = true
            viewModel.getFeed(forPage: 1)
        }
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            print("toShow, ", toShow)
            self?.mainView.loading(toShow)
        }

        viewModel.noContent.bind {[weak self] toShow in
            self?.mainView.noContent(toShow)
        }

        viewModel.noConnection.bind {[weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
        
        viewModel.reloadData.bind { [weak self] toReload in
            if toReload {
                self?.mainView.tableView.reloadData()
            }
        }
        
        viewModel.deleteIndPath.bind { [weak self] ind in
            guard let ind = ind else { return }
            self?.mainView.tableView.deleteRows(at: [ind], with: .fade)
        }
        
        viewModel.reloadIndPath.bind { [weak self] ind in
            guard let ind = ind else { return }
            self?.mainView.tableView.reloadRows(at: [ind], with: .automatic)
        }
    }
    
    func setupCallbacks(){
        mainView.fabBtn.clickCallback = { [weak self] in
            let vc = AddPostVC()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            let vc = NotificationsVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.header.search.clickCallback = { [weak self] in
            let vc = SearchVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.refreshCallback = { [weak self] in
            self?.viewModel.getFeed(forPage: 1)
        }        
    }
    
    func openBottomSheet(id: String, ownerId: String, files: [File]){
        let vc = FeedMoreBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        if ownerId != AccUserDefaults.id {
            vc.mainView.btnStack.addArrangedSubviews([vc.complainBtn])
        } else {
            vc.mainView.btnStack.addArrangedSubviews([vc.complainBtn,
                                                      vc.deleteBtn])
        }
        
        if files.isEmpty == false { vc.mainView.btnStack.insertArrangedSubview(vc.saveImgBtn, at: 0) }
        
        vc.complainBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            let vc = ComplainVC()
            vc.viewModel.uuid = id
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        vc.deleteBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.viewModel.deletePost(uuid: id)
        }
        
        vc.saveImgBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            if files.isEmpty { return }
            self?.saveImg(files: files)
        }
        
        present(vc, animated: true)
    }
    
    func saveImg(files: [File]){
        files.forEach { file in
            guard let url = URL(string: file.fileUrl) else { return }
            KingfisherManager.shared.retrieveImage(with: url) { receivedSize, totalSize in
                print(receivedSize, totalSize)
            } completionHandler: { result in
                switch result {
                case .success(let value):
                    let img: UIImage = value.image
                    UIImageWriteToSavedPhotosAlbum(img, self,  #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                case .failure(_):
                    break
                }
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
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount = viewModel.data.count
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTbCell.id, for: indexPath) as! FeedTbCell
        let post = viewModel.data[indexPath.row]
        cell.data = post

        cell.likeCallback = { [weak self] in
            self?.viewModel.toggleLike(uuid: cell.data?.uuid ?? "")
        }
        
        cell.userDataStack.clickCallback = { [weak self] in
            let vc = ProfileVC(type: .user(id: cell.data?.ownerId ?? ""))
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.userDataStack.trailingBtn.clickCallback = { [weak self] in
            self?.openBottomSheet(id: cell.data?.uuid ?? "", ownerId: cell.data?.owner.id ?? "", files: cell.data?.files ?? [])
        }
        cell.commentView.clickCallback = { [weak self] in
            guard let comments = post.comments else { return }

            let vc = CommentsVC(postUUID: post.uuid, comments: comments)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != cellCount - 1 { return }
        viewModel.getFeed(forPage: viewModel.params.page + 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.fabBtn.isHidden = offset < scrollView.contentOffset.y
        offset = scrollView.contentOffset.y
    }
}
