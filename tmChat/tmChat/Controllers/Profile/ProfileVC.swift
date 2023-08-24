//
//  ProfileVC.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import Kingfisher

class ProfileVC: UIViewController {
    static var toUpdate = false

    let viewModel = ProfileVM()
    
    var headerFab: FabBtn?
    var fabPosition: CGFloat = 0
    
    var type: ProfileType = .own
    
    var cellCount = 0
    var sheetTransitioningDelegate = SheetTransitioningDelegate()

    var mainView: ProfileView {
        return view as! ProfileView
    }

    required init(type: ProfileType) {
        super.init(nibName: nil, bundle: nil)
        viewModel.params.ownerId = type.id
        self.type = type.id != AccUserDefaults.id ? type : .own

        if self.type != .own {
            mainView.otherProfile()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()

        view = ProfileView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupCallbacks()
        setupBindings()
        
        viewModel.getUser()
        viewModel.getFeed(forPage: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ProfileVC.toUpdate && type.id == AccUserDefaults.id {
            ProfileVC.toUpdate = false
            viewModel.getUser()
            viewModel.getFeed(forPage: 1)
        }
    }

    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }

        viewModel.noContent.bind {[weak self] toShow in
            self?.mainView.noContent(toShow)
        }

        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
            if toShow == true {
                self?.mainView.addBgToHeader()
            }
        }
        
        viewModel.data.bind { [weak self] _ in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.user.bind { [weak self] user in
            guard let self = self else { return }

            self.mainView.tableView.reloadData()
            self.mainView.setAvatar(url: ApiPath.url(user?.avatar ?? ""), colorCode: user?.colorCode ?? "#A5A5A5")
            self.mainView.tableView.setContentOffset(.init(x: .zero, y: -self.mainView.tableView.contentInset.top), animated: false)

            if let username = user?.formattedUsername {
                self.mainView.header.username = username
            }
        }
    }
    
    func setupCallbacks(){
        mainView.fabBtn.clickCallback = { [weak self] in
            self?.fabClick()
        }
        
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        mainView.header.searchBtn.clickCallback = { [weak self] in
            #warning("handle")
        }
        mainView.header.moreBtn.clickCallback = { [weak self] in
            self?.opneBottomSheet()
        }
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.viewModel.getUser()
            self?.viewModel.getFeed(forPage: 1)
        }
        
        mainView.refreshCallback = { [weak self] in
            self?.viewModel.getUser()
            self?.viewModel.getFeed(forPage: 1)
        }
    }
    
    func fabClick(){
        if type == .own {
            let vc = AddPostVC()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            guard let user = viewModel.user.value else { return }
            let vc = MessagingVC()
            vc.viewModel.room = RoomTable.shared.get(userId: viewModel.user.value?.id) ?? Room(user: user)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openContactList(){
        let vc = ContactListVC()
        vc.viewModel.params = PaginationParams(page: 1, id: type.id)
        vc.mainView.header.title.text = "contact_list".localized()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func opneBottomSheet(){
        let vc = ProfileMoreBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.delegete = self
        if type == .own {
            vc.setupOwnOptions()
        } else {
            vc.setupOtherOptions()
        }
        present(vc, animated: true)
    }
    
    func openFeedBottomSheet(id: String, ownerId: String, files: [File]){
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

    private func callToUser() {
        guard let user = viewModel.user.value else { return }

        mainView.loading(true)

        viewModel.getChatRoomID { [weak self] roomID in
            self?.mainView.loading(false)

            guard let roomID else { return }

            (UIApplication.shared.delegate as? AppDelegate)?.tabbar?.call(friend: user, roomID: roomID)
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

extension ProfileVC: ProfileMoreDelegate {

    func openEdit() {
        navigationController?.pushViewController(EditProfileVC(), animated: true)
    }
    
    func complain() {
        let vc = ComplainVC()
        vc.viewModel.uuid = viewModel.user.value?.id ?? ""
        vc.viewModel.user = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func copyUsername() {
        UIPasteboard.general.string = viewModel.user.value?.username
        PopUpLauncher.showSuccessMessage(text: "copied".localized())
    }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount = viewModel.data.value.count
        return cellCount == 0 ? 1 : cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellCount == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoContentTbCell.id, for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTbCell.id, for: indexPath) as! FeedTbCell
        let post = viewModel.data.value[indexPath.row]
        
        cell.data = post
        cell.likeCallback = { [weak self] in
            self?.viewModel.toggleLike(uuid: cell.data?.uuid ?? "")
        }
        
        cell.userDataStack.clickCallback = { [weak self] in
            let vc = ProfileVC(type: .user(id: cell.data?.ownerId ?? ""))
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.commentView.clickCallback = { [weak self] in
            guard let comments = post.comments else { return }

            let vc = CommentsVC(postUUID: post.uuid, comments: comments)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.userDataStack.trailingBtn.clickCallback = { [weak self] in
            self?.openFeedBottomSheet(id: cell.data?.uuid ?? "", ownerId: cell.data?.owner.id ?? "", files: cell.data?.files ?? [])
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("print", viewModel.user.value as Any, viewModel.inProgress.value)
        if viewModel.user.value == nil && viewModel.inProgress.value == true {
            return nil
        }

        if viewModel.user.value == nil && viewModel.inProgress.value == false {
            viewModel.noConnection.value = true
            return nil
        }
                
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileTbHeader.id) as! ProfileTbHeader
        headerFab = header.fabBtn
        if type != .own {
            header.setupOther()
        }
        
        header.setupData(data: viewModel.user.value)

        header.editBtn.clickCallback = { [weak self] in
            self?.openEdit()
        }
//        header.notificationBtn.clickCallback = { [weak self] in
//            #warning("handle")
//        }
        header.callBtn.clickCallback = { [weak self] in
            self?.callToUser()
        }
        header.moreBtn.clickCallback = { [weak self] in
            self?.opneBottomSheet()
        }
//        header.contactsBtn.clickCallback = { [weak self] in
//            self?.openContactList()
//        }
        
        header.fabBtn.clickCallback = { [weak self] in
            self?.fabClick()
        }
    
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        if DeviceDimensions.width < offset {
            mainView.header.isScrolled = true
            mainView.addBgToHeader()
        } else {
            mainView.header.isScrolled = false
            mainView.removeBgFromHeader()
            return
        }
        
        if fabPosition == 0 {
            fabPosition = headerFab?.convert(headerFab?.bounds ?? .zero, to: scrollView).maxY ?? 0
        }
        
        mainView.fabBtn.isHidden = offset < fabPosition
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != cellCount - 1 { return }
        viewModel.getFeed(forPage: viewModel.params.page + 1)
    }
}

enum ProfileType: Equatable {
    case own
    case user(id: String)
    
    var id: String {
        switch self {
        case .own:
            return AccUserDefaults.id
            
        case .user(let id):
            return id
        }
    }
}
