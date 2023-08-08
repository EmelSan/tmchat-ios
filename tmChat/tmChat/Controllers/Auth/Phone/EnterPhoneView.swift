//
//  EnterPhoneView.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class EnterPhoneView: BaseView {

    let header = Header(title: "Введите свой телефон".localized())
    
    let scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(top: 60, left: 30, bottom: 30, right: 30),
                                keyboardDismissMode: .onDrag)
    
    let title = UILabel(font: .header_24,
                        color: .blade,
                        alignment: .center,
                        numOfLines: 0,
                        text: "Добро пожаловать в TmChat!".localized())

    let desc = UILabel(font: .sb_16_m,
                        color: .blade,
                        alignment: .center,
                        numOfLines: 0,
                        text: "Введите свой номер телефона для регистрации.".localized())


    let phone = TextField(title: "Введите свой телефон".localized(),
                          leadingText: "+993",
                          placeholder: "Введите свой телефон".localized(),
                          keyboardType: .phonePad,
                          maxCharCount: 8)
    
    let continueBtn = ColoredBtn(title: "Продолжить".localized())
    
    let inEnglishBtn = TextBtn(title: "Продолжить на английском".localized())
    
    let inTurkmenBtn = TextBtn(title: "Продолжить на туркменском".localized())
    
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
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing(),
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Leading(), Trailing(),
            Top().to(header, .bottom), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
    }
    
    func setupContentStack(){
        scrollView.contentStack.easy.layout([
            Height(>=(DeviceDimensions.safeAreaHeight-50))
        ])
        
        scrollView.contentStack.addArrangedSubviews([ title,
                                                      desc,
                                                      phone,
                                                      continueBtn,
                                                      UIView(),
                                                      inEnglishBtn,
                                                      inTurkmenBtn])
        
        scrollView.contentStack.setCustomSpacing(70, after: desc)
        scrollView.contentStack.setCustomSpacing(40, after: inEnglishBtn)
    }
    
    func setupWithoutHeader(){
        header.removeFromSuperview()
        scrollView.easy.layout(Top().to(safeAreaLayoutGuide, .top))
        scrollView.contentStack.easy.layout([
            Height(>=(DeviceDimensions.safeAreaHeight))
        ])
    }
}
