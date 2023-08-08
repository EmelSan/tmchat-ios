//
//  TextField.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class TextField: UIStackView {

    let title = UILabel(font: .text_14_m,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 0)
    
    let errorDesc = UILabel(font: .text_14_m,
                            color: .alert,
                            alignment: .left,
                            numOfLines: 0,
                            text: " ".localized())

    var fieldBg = UIView()
    
    let fieldWrapper = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 14)
    
    let leadingText = UILabel(font: .text_14_m,
                              color: .blade,
                              alignment: .left,
                              numOfLines: 1)
    
    let field = UITextField()
    
    let trailingBtn = IconBtn(image: nil, color: .clear)
    
    var errorText = "should_be_filled".localized()

    var didBeginEditing: ( ()->() )?
    var didEndEditing: ( (_ value: String)->() )?
    var maxCharCount: Int = 0
    init(title: String,
         text: String? = nil,
         leadingText: String? = nil,
         placeholder: String,
         errorText: String? = nil,
         keyboardType: UIKeyboardType = .default,
         maxCharCount: Int = 0) {
        
        super.init(frame: .zero)
        
        setupView()
        setupFiledWrapper()
        if leadingText == nil { self.leadingText.removeFromSuperview() }

        self.title.text = title
        self.leadingText.text = leadingText
        self.errorText = errorText ?? self.errorText
        self.maxCharCount = maxCharCount
        
        field.placeholder = placeholder
        field.text = text
        field.keyboardType = keyboardType
        field.font = .text_14_m
        field.delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        axis = .vertical
        spacing = 6
        alignment = .fill
        
        addArrangedSubviews([title,
                             fieldWrapper,
                             errorDesc])
    }
    
    func setupFiledWrapper(){
        leadingText.setContentHuggingPriority(.required, for: .horizontal)
        fieldWrapper.addMargins(left: 20, right: 20)
        fieldWrapper.easy.layout(Height(48))
        
        fieldBg = fieldWrapper.addBackground(color: .white,
                                             cornerRadius: 6,
                                             borderWidth: 1,
                                             borderColor: .clear)

        fieldWrapper.addArrangedSubviews([leadingText,
                                          field])
    }
    
    func addTrailingBtn(iconName: String){
        trailingBtn.setImage(UIImage(named: iconName), for: .normal)
        fieldWrapper.addArrangedSubview(trailingBtn)
    }
    
    func active(){
        fieldBg.layer.borderColor = UIColor.accent.cgColor
        fieldBg.backgroundColor = .white
        errorDesc.text = " "
    }
    
    func inactive(){
        fieldBg.layer.borderColor = UIColor.clear.cgColor
        fieldBg.backgroundColor = .white
        errorDesc.text = " "
    }
    
    func error(){
        fieldBg.layer.borderColor = UIColor.alert.cgColor
        fieldBg.backgroundColor = .alert.withAlphaComponent(0.1)
        errorDesc.text = errorText
    }
    
    func error(text: String){
        fieldBg.layer.borderColor = UIColor.alert.cgColor
        fieldBg.backgroundColor = .alert.withAlphaComponent(0.1)
        errorDesc.text = text
    }
    
    func setValue(_ text: String?) {
        field.text = text
    }
    
    func getValue(withChecking: Bool = true) -> String? {
        let value = field.text ?? ""
        
        if withChecking && value.isEmpty {
            error()
            return nil
        }

        inactive()
        return value
    }
    
    func isValidPhoneNumber() -> String? {
        guard let value = getValue() else { return nil }
        
        if !value.isValidNumber() {
            error(text: "invalid_phone_number".localized())
            return nil
        }

        inactive()
        return value
    }
    
    func isValidUsername() -> String? {
        guard let value = getValue() else { return nil }
        
        if !value.isValidUsername() {
            error(text: "invalid_username".localized())
            return nil
        }

        inactive()
        return value
    }
}

extension TextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        active()
        didBeginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inactive()
        didEndEditing?(textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if maxCharCount == 0 || string.isEmpty { return true }
        return !(textField.text?.count ?? 0 >= maxCharCount)
    }
}

