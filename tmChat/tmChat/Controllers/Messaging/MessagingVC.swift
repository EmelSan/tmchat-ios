//
//  MessagingVC.swift
//  tmchat
//
//  Created by Shirin on 3/10/23.
//

import UIKit
import TLPhotoPicker
import UniformTypeIdentifiers

class MessagingVC: UIViewController {
    
    var sheetTransitioningDelegate = SheetTransitioningDelegate()
    var documentInteractor = UIDocumentInteractionController()

    var viewModel = MessagingVM()
    
    var datasource = MessagingDataSource()
    
    var replyToMsg: ShortMsg?

    var oldMessages: [Message] = []
    
    var mainView: MessagingView {
        return view as! MessagingView
    }

    override func loadView() {
        super.loadView()
        view = MessagingView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DownloadService.shared.view = mainView
        mainView.addNotification()
        
        viewModel.messages.value = MessageTable.shared.getRoomMsgs(room: viewModel.room)
        oldMessages = viewModel.messages.value

        setupBindings()
        setupCallbacks()
        setupData()
        viewModel.subscribe()
    }
    
    deinit {
        RoomTable.shared.updateDraft(id: viewModel.room?.id,
                                     draft:  mainView.textField.getText())
        print("Messaging deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.readRoom()
    }
    
    func setupData(){
        datasource.viewModel = viewModel
        
        mainView.tableView.dataSource = datasource
        mainView.header.setupData(viewModel.room)
        mainView.textField.setText(viewModel.room?.draft)
        datasource.cellDelegate = self
    }
    
    func setupBindings(){
        viewModel.messages.bind { [weak self] messages in
            if messages.count > 1000 {
                self?.oldMessages = messages
                self?.mainView.tableView.reloadData()
            } else {
                self?.mainView.tableView.beginUpdates()
                self?.mainView.tableView.animateRowChanges(oldData: self?.oldMessages ?? [],
                                                           newData: messages,
                                                           deletionAnimation: .fade,
                                                           insertionAnimation: .none)
                self?.oldMessages = messages
                self?.mainView.tableView.endUpdates()
            }
            
            if messages.count > 1 {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self?.mainView.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)],
                                                        with: .none)
                }
            }
        }
        
        viewModel.popVc.bind { [weak self] pop in
            if pop == true {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.header.clickCallback = { [weak self] in
            self?.openChatProfile()
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            self?.setupMessagingActions()
        }
        
        mainView.selectionHeader.backBtn.clickCallback = { [weak self] in
            self?.closeSelection()
        }
        
        mainView.selectionFooter.deleteBtn.clickCallback = { [weak self] in
            self?.viewModel.deleteMsgs()
            self?.closeSelection()
        }
        
        mainView.selectionFooter.copyBtn.clickCallback = { [weak self] in
            self?.viewModel.copyMsgs()
            self?.closeSelection()
        }
        
        mainView.selectionFooter.replyBtn.clickCallback = { [weak self] in
            guard let msg = self?.viewModel.selectedMessages.first else { return }
            self?.closeSelection()
            self?.swipe(data: msg)
        }
        
        mainView.selectionFooter.forwardBtn.clickCallback = { [weak self] in
            let selectedMsg = self?.viewModel.selectedMessages ?? []
            self?.closeSelection()
            
            let vc = ContactListVC()
            vc.viewModel.params = PaginationParams(page: 1, id: AccUserDefaults.id)
            vc.type = .forward
            vc.mainView.sendBtn.clickCallback = { [weak self] in
                self?.dismiss(animated: true)
                self?.viewModel.forwardMsgs(toUsers: vc.selectedContacts,
                                            selectedMsgs: selectedMsg)
            }
            self?.present(vc, animated: true)
        }
        
        mainView.replyMsgView.deleteBtn.clickCallback = { [weak self] in
            self?.mainView.hideReplyView()
        }
        
        mainView.textField.addBtn.clickCallback = { [weak self] in
            self?.setupAttachmentActions()
        }
        
        mainView.textField.cameraBtn.clickCallback = { [weak self] in
            self?.takeImg()
        }
        
        mainView.textField.sendBtn.clickCallback = { [weak self] in
            guard let content = self?.mainView.textField.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            self?.mainView.textField.showAddBtn()
            self?.mainView.hideReplyView()
            
            var msg = Message.emptyMsg
            msg.content = content
            msg.type = MsgType.text.rawValue
            msg.repliedToMessage = self?.replyToMsg
            self?.replyToMsg = nil
            self?.viewModel.sendMsg(msg)
        }
        
        mainView.textField.voiceRecordingView.sendVoice = { [weak self] res in
            let uploadF = UploadImage(uploadName: "file",
                                      filename: res.url?.lastPathComponent ?? "",
                                      duration: res.duration,
                                      fileSize: Int64(res.data?.count ?? 0),
                                      data: res.data,
                                      localPath: res.url?.absoluteString)

            self?.viewModel.uploadMsg(file: uploadF, type: MsgType.voice.rawValue)
        }
    }
    
    func setupMessagingActions(){
        view.endEditing(true)
        let vc = MessagingActionsBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.delegete = self
        vc.setupFullOptions()
        present(vc, animated: true)
    }
    
    func setupAttachmentActions(){
        let vc = AttachmentOptionsBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.delegate = self
        present(vc, animated: true)
    }

    func openSelection(){
        datasource.toAnimateSelection = true
        datasource.isSelectionOpened = true
        RxSubjects.openSelection.onNext((true))
        mainView.openSelection()
    }
    
    func closeSelection(){
        datasource.toAnimateSelection = true
        datasource.isSelectionOpened = false
        RxSubjects.openSelection.onNext((false))
        mainView.closeSelection()
        viewModel.selectedMessages = []
    }
}



extension MessagingVC: MessagingActionsDelegate {
    func openChatProfile() {
//        let vc = ChatProfileVC()
//        vc.viewModel = viewModel
//        navigationController?.pushViewController(vc, animated: true)
        
        let vc = ProfileVC(type: .user(id: viewModel.room?.userId ?? ""))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSearch() {
        print("search")
    }
    
    func call() {
        let phone = "viewModel.room"
        if let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func clearRoom() {
        print("clear")
    }
    
    func deleteRoom() {
        print("delete")
    }
}



extension MessagingVC: AttachmentDelegate {
    func takeImg() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        present(vc, animated: true, completion: nil)
    }
    
    func openMediaPicker(){
        let vc = TLPhotosPickerViewController()
        vc.configure.maxSelectedAssets = 9
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func openFilePicker(){
        if #available(iOS 14, *){
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet

            self.present(documentPicker, animated: true, completion: nil)
        } else {
            let types: [String] = ["public.image", "public.movie", "public.video", "public.audio", "public.data", "public.archive", "public.text"]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
        }
    }
}



extension MessagingVC: MsgCellDelegate {
    func openFile(data: Message) {
        documentInteractor.delegate = self
        documentInteractor.url = URL(fileURLWithPath: FileManager.default.getDocDir().appendingPathComponent(data.content).path)
        documentInteractor.presentPreview(animated: true)
        documentInteractor.presentOptionsMenu(from: .zero, in: view, animated: true)
    }
    
    func selectionClick(isChecked: Bool, data: Message) {
        if viewModel.selectedMessages.contains(where: {$0.id == data.id}) {
            viewModel.selectedMessages.removeAll(where: {$0.id == data.id })
        } else {
            viewModel.selectedMessages.append(data)
        }

        let count = viewModel.selectedMessages.count
        if count == 0 {
            closeSelection()
            return
        }

        mainView.selectionHeader.title.text = "selected:".localized() + "\(count)"
        mainView.selectionFooter.replyBtn.isEnabled = count == 1
    }
    
    func swipe(data: Message) {
        replyToMsg = ShortMsg(UUID: data.UUID ?? "",
                              senderUUID: data.senderUUID,
                              type: data.type,
                              content: data.content,
                              fileUrl: data.fileUrl ?? "",
                              senderName: data.senderUUID == AccUserDefaults.id ? AccUserDefaults.name : viewModel.room?.roomName)
        mainView.replyMsgView.setupData(replyToMsg)
        mainView.showReplyView()
    }
    
    func longClick(data: Message) {
        mainView.selectionHeader.title.text = "selected:".localized() + "1"
        viewModel.selectedMessages = [data]
        openSelection()
    }
    
    func replyClick(data: ShortMsg?) {
        guard let ind = viewModel.messages.value.firstIndex(where: {$0.UUID == (data?.UUID ?? "") }) else { return }
        mainView.tableView.scrollToRow(at: IndexPath(row: ind, section: 0), at: .middle, animated: true)
    }
    
    func openMedia(data: Message) {
        let messages = Array(viewModel.messages.value.filter({$0.type == MsgType.video.rawValue
                                                            || $0.type == MsgType.image.rawValue })
                                                        .reversed())

        let ind = messages.firstIndex(where: {$0.id == data.id })

        let vc = MediaViewerPagerVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.presenterVM = viewModel
        vc.currentInd = ind ?? 0
        vc.data = messages
        present(vc, animated: true)
    }
}


extension MessagingVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        withTLPHAssets.forEach { asset in
            asset.tempCopyMediaFile { url, _ in
                let localPath = self.copyToLocal(url: url, filename: asset.originalFileName)
                
                let d = try? (asset.type == .video ? Data(contentsOf: url) : asset.fullResolutionImage?.jpegData(compressionQuality: 0.75))
                
                let uplF = UploadImage(uploadName: "file",
                                       filename: asset.originalFileName,
                                       duration: Int64(asset.phAsset?.duration ?? 0),
                                       fileSize: Int64(d?.count ?? 0),
                                       data: d ?? Data(),
                                       localPath: localPath)
                
                self.viewModel.uploadMsg(file: uplF, type: asset.type == .video
                                                            ? MsgType.video.rawValue
                                                            : MsgType.image.rawValue)
            }
        }
    }
    
    func copyToLocal(url: URL, filename: String?) -> String {
        let path = FileManager.default.getDocDir().path
        let localUrl = URL(fileURLWithPath: path).appendingPathComponent(filename ?? "")
        let filePath = localUrl.path
        
        if FileManager.default.fileExists(atPath: filePath) {
            try? FileManager.default.removeItem(at: filePath.asURL())
        }
        
        try? FileManager.default.copyItem(at: url, to: localUrl)
        return filePath
    }
}

extension MessagingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imgData = img?.jpegData(compressionQuality: 0.75)
        
        let filename = UUID().uuidString+".jpeg"
        let urlToSave = FileManager.default.getDocDir()
                                   .appendingPathComponent(filename)
        
        FileManager.default.createFile(atPath: urlToSave.path, contents: imgData)
        
        let uplF = UploadImage(uploadName: "file",
                               filename: filename,
                               duration: 0,
                               fileSize: Int64(imgData?.count ?? 0),
                               data: imgData,
                               localPath: urlToSave.path)
        

        viewModel.uploadMsg(file: uplF, type: MsgType.image.rawValue)
    }
}


extension MessagingVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        urls.forEach { url in
            let d = try? Data(contentsOf: url)
            let uplF = UploadImage(uploadName: "file",
                                   filename: url.lastPathComponent,
                                   duration: 0,
                                   fileSize: Int64(d?.count ?? 0),
                                   data: d,
                                   localPath: copyToLocal(url: url, filename: url.lastPathComponent))

            viewModel.uploadMsg(file: uplF, type: MsgType.file.rawValue)
        }
    }
}

extension MessagingVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
