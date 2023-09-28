//
//  AddPostView.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class AddPostView: BaseView {

    var header = Header(title: "add_post".localized(), isPresented: true)
    
    var scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                         verticalEdges: 20),
                                keyboardDismissMode: .interactive)
    
    var btnStack = UIStackView(axis: .horizontal,
                               alignment: .center,
                               spacing: 10,
                               edgeInsets: UIEdgeInsets(horizontalEdges: 16,
                                                        verticalEdges: 10),
                               backgroundColor: .onBg)
    
    var comments = CheckBtn(title: "comments_title".localized(), isChecked: true)
    var reactions = CheckBtn(title: "reactions".localized(), isChecked: true)
    var incognito = IconBtn(image: UIImage(named: "incognito"), color: .bapAccent)
    
    var textView: UITextView = {
        let t = UITextView()
        t.font = .sb_16_r
        t.isScrollEnabled = false
        t.backgroundColor = .clear
        t.textColor = .lee
        t.textContainer.lineFragmentPadding = 0
        t.textContainerInset = .zero
        return t
    }()
    
    var imageList = AddPostImageList(title: "images".localized())
    
    var footer = UIStackView(axis: .horizontal,
                             alignment: .fill,
                             spacing: 10,
                             edgeInsets: UIEdgeInsets(horizontalEdges: 20,
                                                      verticalEdges: 12))
    
    var attachBtn = IconTextBtn(title: "attach".localized(),
                                image: UIImage(named: "pin"),
                                isPrimary: false)
    
    var timerBtn = IconTextBtn(title: nil,
                               image: UIImage(named: "timer"),
                               isPrimary: false)

    var doneBtn = IconTextBtn(title: "publish".localized(),
                              image: nil,
                              isPrimary: true)
    
    var placeholderText = "add_post_placeholder".localized()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.delegate = self
        textView.text = placeholderText
        
        setupView()
        setupContentStack()
        setupFooter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing()
        ])
        
        addSubview(btnStack)
        btnStack.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing()
        ])

        addSubview(footer)
        footer.easy.layout([
            Bottom().to(safeAreaLayoutGuide, .bottom), Leading(), Trailing()
        ])
        
        addSubview(scrollView)
        scrollView.backgroundColor = .bg
        scrollView.easy.layout([
            Top().to(btnStack, .bottom), Leading(), Trailing(), Bottom().to(footer, .top)
        ])
        
        scrollView.contentStack.easy.layout([
            Height(>=(DeviceDimensions.safeAreaHeight-160))
        ])
    }
    
    func setupContentStack(){
        scrollView.contentStack.addArrangedSubviews([textView,
                                                     UIView(),
                                                     imageList])
        
        btnStack.addArrangedSubviews([comments,
                                      reactions,
                                      UIView(),
                                      incognito])
        
        incognito.easy.layout([
            Height(32), Width(48)
        ])
    }
    
    func setupFooter(){
        footer.addArrangedSubviews([attachBtn,
                                    UIView(),
//                                    timerBtn,
                                    doneBtn])
    }
    
    func postDescription() -> String {
        if textView.textColor == .lee {
            return ""
        } else {
            return textView.text
        }
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
            UIView.animate(withDuration: duration) { [self] in
                footer.easy.layout(Bottom(keyboardHeight).to(safeAreaLayoutGuide, .bottom))
                layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        UIView.animate(withDuration: duration) { [self] in
            footer.easy.layout(Bottom().to(safeAreaLayoutGuide, .bottom))
            layoutIfNeeded()
        }
    }
}

extension AddPostView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lee {
            textView.text = nil
            textView.textColor = .blade
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lee
        }
    }
}
