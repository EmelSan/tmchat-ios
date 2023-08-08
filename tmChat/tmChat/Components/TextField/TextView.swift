//
//  TextView.swift
//  tmchat
//
//  Created by Shirin on 3/18/23.
//

import UIKit
import EasyPeasy

class TextView: UIStackView {
    
    let title = UILabel(font: .text_14_m,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 0)
    
    let errorDesc = UILabel(font: .text_14_m,
                            color: .alert,
                            alignment: .left,
                            numOfLines: 0,
                            text: " ".localized())
    
    var textView: UITextView = {
        let t = UITextView()
        t.layer.cornerRadius = 6
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.clear.cgColor
        t.backgroundColor = .white
        t.font = .text_14_m
        t.isScrollEnabled = false
        t.textContainer.lineFragmentPadding = 0
        t.textContainerInset = UIEdgeInsets(horizontalEdges: 20, verticalEdges: 16)
        return t
    }()
        
    var errorText = "should_be_filled".localized()
    var placeholderText = ""

    var didBeginEditing: ( ()->() )?
    var editing: ( (_ value: String)->() )?
    var didEndEditing: ( (_ value: String)->() )?
    
    init(title: String,
         text: String? = nil,
         placeholder: String,
         errorText: String? = nil) {
        
        super.init(frame: .zero)
        
        setupView()

        self.title.text = title
        self.errorText = errorText ?? self.errorText
        
        textView.text = text ?? placeholder
        textView.textColor = text == nil ? .lee : .blade
        textView.delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        axis = .vertical
        spacing = 6
        alignment = .fill
        
        addArrangedSubviews([title,
                             textView,
                             errorDesc])
    }
    
    func active(){
        textView.layer.borderColor = UIColor.accent.cgColor
        textView.backgroundColor = .white
        errorDesc.text = " "
    }
    
    func inactive(){
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.backgroundColor = .white
        errorDesc.text = " "
    }
    
    func error(){
        textView.layer.borderColor = UIColor.alert.cgColor
        textView.backgroundColor = .alert.withAlphaComponent(0.1)
        errorDesc.text = errorText
    }
    
    func error(text: String){
        textView.layer.borderColor = UIColor.alert.cgColor
        textView.backgroundColor = .alert.withAlphaComponent(0.1)
        errorDesc.text = text
    }
    
    func setValue(_ text: String?) {
        if (text ?? "").isEmpty {
            textView.text = placeholderText
            textView.textColor = .lee
            return
        }
        
        textView.text = text
        textView.textColor = .blade
    }

    func getValue(withChecking: Bool = true) -> String? {
        let value = textView.text ?? ""
        
        if withChecking && value.isEmpty {
            error()
            return nil
        }

        inactive()
        return value
    }
}

extension TextView: UITextViewDelegate {    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text.count <= 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        active()
        if textView.textColor == .lee {
            textView.text = nil
            textView.textColor = .blade
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        inactive()
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lee
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        editing?(textView.text)
    }
}
