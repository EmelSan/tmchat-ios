//
//  OtpView.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class OtpView: BaseView {

    let header = Header(title: "enter_otp".localized())
    
    let scrollView = ScrollView(spacing: 30,
                                edgeInsets: UIEdgeInsets(top: 60, left: 30, bottom: 30, right: 30),
                                keyboardDismissMode: .onDrag)
    
    let title = UILabel(font: .sb_16_m,
                        color: .blade,
                        alignment: .center,
                        numOfLines: 0,
                        text: "sent_to_phone".localized())

    let otpField = OtpField()
    
    let timerWrapper = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 0)
    
    let resendBtn = TextBtn(title: "resend_btn".localized())
    
    let timerText = UILabel(font: .text_14_m,
                            color: .lee,
                            alignment: .center,
                            numOfLines: 0,
                            text: "resend_code_after".localized() + "01:00")
    
    var timer: Timer?
    var remainingTime = 60
    var timerStopped = false

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
        otpField.configure()
        
        scrollView.contentStack.easy.layout([
            Height(>=(DeviceDimensions.safeAreaHeight))
        ])
        
        scrollView.contentStack.addArrangedSubviews([ title,
                                                      otpField,
                                                      timerWrapper,
                                                      UIView()])
    }
    
    func startTimer() {
        resendBtn.removeFromSuperview()
        timerWrapper.addArrangedSubview(timerText)
        
        timerStopped = false
        remainingTime = 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timerStopped = true
    }
    
    func resumeTimer(){
        timerStopped = false
    }
    
    func timerFinished() {
        timer?.invalidate()
        timerText.removeFromSuperview()
        timerWrapper.addArrangedSubview(resendBtn)
    }
    
    func getDurationText() -> String {
        let secs = remainingTime % 60
        let mins = remainingTime / 60

        return String(format: "%02i:%02i", arguments: [mins, secs])
    }

    @objc func countDown() {
        if timerStopped { return }
        self.remainingTime -= 1
        timerText.text = "resend_code_after".localized() + getDurationText()
        
        if (self.remainingTime < 1) {
            timerFinished()
        }
    }
}
