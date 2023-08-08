//
//  EditProfileView.swift
//  tmchat
//
//  Created by Shirin on 3/18/23.
//

import UIKit
import EasyPeasy

class EditProfileView: BaseView {

    let header = Header(title: "update_profile".localized())
    
    let scrollView = ScrollView(spacing: 10,
                                edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                         verticalEdges: 20),
                                keyboardDismissMode: .interactive)
    
    let img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 14)
    
    let camerBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), color: .white)
        b.backgroundColor = .black.withAlphaComponent(0.4)
        b.layer.cornerRadius = 26
        return b
    }()
    
    let name = TextField(title: "first_name".localized(),
                         placeholder: "enter_first_name".localized())
    
    let surname = TextField(title: "last_name".localized(),
                            placeholder: "enter_last_name".localized())

    let nickname = TextField(title: "username".localized(),
                             placeholder: "enter_username".localized())
        
    let about = TextView(title: "about_me".localized(),
                         placeholder: "about_me".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.addTrailingBtn(iconName: "checkmark")
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing()
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
    }
    
    func setupContentStack(){
        img.easy.layout(Size(DeviceDimensions.width-32))
        img.addSubview(camerBtn)
        camerBtn.easy.layout([
            Trailing(20), Bottom(20), Size(52)
        ])
        
        scrollView.contentStack.addArrangedSubviews([img,
                                                     name,
                                                     surname,
                                                     nickname,
                                                     about])
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRectangle.size.height - DeviceDimensions.bottomInset
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            UIView.animate(withDuration: duration) { [weak self] in
                self?.scrollView.easy.layout(Bottom(keyboardHeight))
                self?.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        UIView.animate(withDuration: duration) { [weak self] in
            self?.scrollView.easy.layout(Bottom().to(self!.safeAreaLayoutGuide, .bottom))
            self?.layoutIfNeeded()
        }
    }
}
