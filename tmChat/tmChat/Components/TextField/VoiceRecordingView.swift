//
//  VoiceRecordingView.swift
//  tmchat
//
//  Created by Shirin on 3/17/23.
//

import UIKit
import EasyPeasy

class VoiceRecordingView: UIStackView {
    
    var micIcon = IconBtn(image:UIImage(named: "voice")?
                            .withRenderingMode(.alwaysTemplate),
                          color: .alert)
    
    var duration = UILabel(font: .sb_16_r,
                           color: .bladeContrast,
                           alignment: .left,
                           numOfLines: 1,
                           text: "00:00")
    
    var cancel = UILabel(font: .sb_16_r,
                         color: .bladeContrast,
                         alignment: .center,
                         numOfLines: 1,
                         text: "< "+"cancel".localized())
    
    var voiceActiveBtn = UIImageView(contentMode: .scaleToFill,
                                     cornerRadius: 0,
                                     image: UIImage(named: "voice-recording"),
                                     backgroundColor: .clear)

    var voiceActiveBtnPlaceholder = UIView()

    var cancelWidth: CGFloat = 0
    var initialPoint: CGPoint = .zero
    
    var timer: Timer?
    var seconds: Int = 0

    var sendVoice: ( (VoiceRecordResult)->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRecordingView()
        setupContentStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentStack(){
        axis = .horizontal
        alignment = .fill
        spacing = 0
        distribution = .fill
//        addMargins(right: 40)
        let _ = addBackground(color: .white, cornerRadius: 20)

        addArrangedSubviews([micIcon,
                             duration,
                             cancel,
                             voiceActiveBtnPlaceholder])
        
    }
    
    func setupRecordingView(){
        voiceActiveBtn.frame = CGRect(origin: .zero, size: CGSize(width: 72, height: 72))
        micIcon.easy.layout(Size(40))
        voiceActiveBtnPlaceholder.easy.layout(Width(72))
        duration.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func startTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.seconds += 1
            self?.setSeconds(self?.seconds ?? 0)
        }
    }
    
    func setSeconds(_ sec: Int) {
        duration.text = String(format: "%02d", sec / 60) + ":" + String(format: "%02d", sec % 60)
    }

    func prepareForNew(){
        duration.text = "00:00"
        timer?.invalidate()
        seconds = 0
    }
    
    func startRecording(){
        addSubview(voiceActiveBtn)
        cancelWidth = frame.size.width/2
        startTimer()
        VoiceRecorder.shared.startRecording()
    }
    
    func cancelRecording(){
        prepareForNew()
        removeFromSuperview()
        let result = VoiceRecorder.shared.stopRecording(toCancel: true)
        VoiceRecorder.shared.deleteRecordedVoice(path: result?.url?.path ?? "")
    }
    
    func saveRecording(){
        prepareForNew()
        removeFromSuperview()
        guard let result = VoiceRecorder.shared.stopRecording(toCancel: false) else {
            PopUpLauncher.showErrorMessage(text: "could_not_save")
            return
        }
        sendVoice?(result)
    }
    
    func setupGestureStates(_ sender: UILongPressGestureRecognizer){
        let point = sender.location(in: self)

        switch sender.state{
        case .began:
            startRecording()
            voiceActiveBtn.center = point
            initialPoint = point
            
        case .changed:
            let x = point.x > initialPoint.x ? initialPoint.x : point.x
            voiceActiveBtn.center = CGPoint(x: x, y: initialPoint.y)
            if x <= cancelWidth {
                sender.cancel()
                cancelRecording()
            }

        case .cancelled, .failed:
            sender.cancel()
            cancelRecording()
            
        case .ended:
            sender.cancel()
            if point.x <= cancelWidth {
                cancelRecording()
            } else {
                saveRecording()
            }
            
        default:
            return
        }
    }
}
