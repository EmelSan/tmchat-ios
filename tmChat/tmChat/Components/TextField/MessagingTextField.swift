//
//  MessagingTextField.swift
//  tmchat
//
//  Created by Shirin on 3/14/23.
//

import UIKit
import EasyPeasy

class MessagingTextField: UIStackView {
    
    var fieldWrapperBg: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        return v
    }()
    
    var fieldWrapper = UIStackView(axis: .horizontal,
                                   alignment: .bottom,
                                   spacing: 0,
                                   distribution: .fill)
        
    var textView: UITextView = {
        let t = UITextView()
        t.font = .sb_16_r
        t.isScrollEnabled = false
        t.backgroundColor = .clear
        t.textColor = .lee
        t.textContainer.lineFragmentPadding = 0
        t.textContainerInset = UIEdgeInsets(horizontalEdges: 16, verticalEdges: 10)
        t.text = "msg_field_placeholder".localized()
        return t
    }()
    
    var cameraBtn = IconBtn(image: UIImage(named: "camera"), color: .blade)
    
    var voiceBtn = IconBtn(image: UIImage(named: "voice"), color: .blade)
    
    var sendBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "send"), color: .white)
        b.backgroundColor = .accent
        b.layer.cornerRadius = 20
        b.isHidden = true
        return b
    }()
    
    var addBtn: IconBtn = {
        let b = IconBtn(image: UIImage(named: "add"), color: .white)
        b.backgroundColor = .accent
        b.layer.cornerRadius = 20
        return b
    }()
    
    var voiceRecordingView = VoiceRecordingView()

    var placeholderText = "msg_field_placeholder".localized()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(voiceLongClick))
        voiceBtn.addGestureRecognizer(longPress)
        textView.delegate = self
        textView.easy.layout(Height(<=300))

        setupContentStack()
        setupTextField()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let h = textView.frame.size.height
        textView.isScrollEnabled = h > 270 && h < 300
    }
    
    func setupContentStack(){
        axis = .horizontal
        alignment = .bottom
        spacing = 10
        distribution = .fill
        addMargins(top: 10, left: 16, bottm: 10, right: 16)
        
        addArrangedSubviews([fieldWrapper, addBtn, sendBtn])
    }
    
    func setupTextField(){
        fieldWrapper.addArrangedSubviews([textView,
                                          cameraBtn,
                                          voiceBtn])
        
        fieldWrapperBg = fieldWrapper.addBackground(color: .white,
                                                 cornerRadius: 20)
    }
    
    func showAddBtn(){
        textView.text = nil
        addBtn.isHidden = false
        sendBtn.isHidden = true
    }
    
    func setText(_ text: String?) {
        if text == nil || text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.textColor = .lee
            textView.text = placeholderText
        } else {
            textView.textColor = .blade
            textView.text = text
        }
    }

    func getText() -> String {
        if textView.textColor == .lee {
            return ""
        } else {
            return textView.text
        }
    }
        
    @objc func voiceLongClick(_ sender: UILongPressGestureRecognizer){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        addSubview(voiceRecordingView)
        voiceRecordingView.frame = fieldWrapper.frame
        voiceRecordingView.setupGestureStates(sender)
    }
}

extension MessagingTextField: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        addBtn.isHidden = !textView.text.isEmpty
        sendBtn.isHidden = textView.text.isEmpty
        
        let h = textView.contentSize.height
        if h <= 300 && textView.isScrollEnabled {
            layoutSubviews()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lee {
            textView.text = nil
            textView.textColor = .blade
        }
        
        UIView.animate(withDuration: 0.2) {
            self.cameraBtn.alpha = 0
            self.voiceBtn.alpha = 0
        } completion: { _ in
            self.cameraBtn.isHidden = true
            self.voiceBtn.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lee
        }
        
        UIView.animate(withDuration: 0.2) {
            self.cameraBtn.alpha = 1
            self.voiceBtn.alpha = 1
        } completion: { _ in
            self.cameraBtn.isHidden = false
            self.voiceBtn.isHidden = false
        }
    }
}
