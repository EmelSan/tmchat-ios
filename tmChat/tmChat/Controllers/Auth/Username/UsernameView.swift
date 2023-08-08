//
//  EnterUsernameView.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class UsernameView: BaseView {

    let header = Header(title: "enter_username".localized())
    
    let scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(top: 60, left: 30, bottom: 30, right: 30),
                                keyboardDismissMode: .onDrag)
    

    let desc = UILabel(font: .sb_16_m,
                        color: .blade,
                        alignment: .center,
                        numOfLines: 0,
                        text: "enter_phone_desc".localized())


    let name = TextField(title: "enter_username".localized(),
                          leadingText: "@",
                         placeholder: "enter_username".localized())
    
    let continueBtn = ColoredBtn(title: "continue".localized())

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
        
        scrollView.contentStack.addArrangedSubviews([ desc,
                                                      name,
                                                      continueBtn,
                                                      UIView()])
        
        scrollView.contentStack.setCustomSpacing(100, after: desc)
    }
    
    func setupForName(){
        name.leadingText.removeFromSuperview()
        desc.text = "enter_name".localized()
        name.title.text = "enter_name".localized()
        name.field.placeholder = "enter_name".localized()
        continueBtn.setTitle("done".localized(), for: .normal)
    }
}
