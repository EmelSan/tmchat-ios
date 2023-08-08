//
//  MessagingView.swift
//  tmchat
//
//  Created by Shirin on 3/10/23.
//

import UIKit
import EasyPeasy

class MessagingView: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    var topInsetBg = UIView()
    
    var header = UserDataStack(withBackBtn: true)
    
    var selectionHeader = Header(title: "selected: 1", isPresented: true, backIsFirst: false)
    
    var tableView :  UITableView = {
        let t = UITableView(rowHeight: UITableView.automaticDimension,
                            backgroundColor: .clear)
        t.register(TextMsgTbCell.self, forCellReuseIdentifier: TextMsgTbCell.id)
        t.register(FileMsgTbCell.self, forCellReuseIdentifier: FileMsgTbCell.id)
        t.register(ContactMsgTbCell.self, forCellReuseIdentifier: ContactMsgTbCell.id)
        t.register(MediaMsgTbCell.self, forCellReuseIdentifier: MediaMsgTbCell.id)
        t.register(VoiceMsgTbCell.self, forCellReuseIdentifier: VoiceMsgTbCell.id)
        
        t.transform = CGAffineTransform(rotationAngle: -.pi)
        t.scrollIndicatorInsets.right = DeviceDimensions.width - 8.0
        t.contentInset.top = 4
        return t
    }()

    var replyMsgView = ReplyMsgBottomView()
    
    var textField = MessagingTextField()

    var selectionFooter = MessagingSelectionFooter()
    
    var bottomInsetBg = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([topInsetBg,
                                          header,
                                          selectionHeader,
                                          tableView,
                                          replyMsgView,
                                          textField,
                                          selectionFooter,
                                          bottomInsetBg])
        
//        header.addAudio()
        header.trailingBtn.isHidden = true
        
        header.layoutMargins.bottom = 14
        header.bg.backgroundColor = .white
        selectionHeader.isHidden = true
        let _ = selectionHeader.addBackground(color: .white, cornerRadius: .zero)
        selectionFooter.isHidden = true

        topInsetBg.backgroundColor = .white
        topInsetBg.easy.layout(Height(DeviceDimensions.topInset))
        bottomInsetBg.easy.layout(Height(DeviceDimensions.bottomInset ))

        replyMsgView.isHidden = true
        replyMsgView.alpha = 0
    }
    
    func showReplyView(){
        UIView.animate(withDuration: 0.2) {
            self.replyMsgView.alpha = 1
        } completion: { _ in
            self.replyMsgView.isHidden = false
        }
    }
    
    func hideReplyView(){
        UIView.animate(withDuration: 0.2) {
            self.replyMsgView.alpha = 0
        } completion: { _ in
            self.replyMsgView.isHidden = true
        }
    }
    
    func openSelection(){
        header.isHidden = true
        selectionHeader.isHidden = false
        textField.isHidden = true
        selectionFooter.isHidden = false
    }
    
    func closeSelection(){
        header.isHidden = false
        selectionHeader.isHidden = true
        textField.isHidden = false
        selectionFooter.isHidden = true
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRectangle.size.height - DeviceDimensions.bottomInset
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            UIView.animate(withDuration: duration) { [weak self] in
                self?.contentStack.easy.layout(Bottom(keyboardHeight))
                self?.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        UIView.animate(withDuration: duration) { [weak self] in
            self?.contentStack.easy.layout(Bottom())
            self?.layoutIfNeeded()
        }
    }
}
