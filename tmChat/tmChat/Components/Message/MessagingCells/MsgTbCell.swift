//
//  MessageCellTableViewCell.swift
//  tmchat
//
//  Created by Shirin on 3/20/23.
//

import UIKit
import EasyPeasy
import RxSwift

class MsgTbCell: UITableViewCell {

    weak var delegate: MsgCellDelegate?
    
    var isSelectionOpened = false
    
    var dateView = DateView()
    
    var unreadHeaderView = UIView()
    
    var headerStack = UIStackView(axis: .vertical,
                                  alignment: .center,
                                  spacing: 0,
                                  edgeInsets: UIEdgeInsets(horizontalEdges: 8))
    
    var msgView = MsgView()
    
    var disposeBag = DisposeBag()
    
    var replyVibrated = false
    
    var message: Message!
    var prevMessage: Message!
    var nextMessage: Message!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        UIView.performWithoutAnimation {
            transform = CGAffineTransform(rotationAngle: .pi)
            backgroundColor = .clear
            selectionStyle = .none
        }
        
        addGestureRecognizers()
        setupView()
        setupRxSubscriptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        msgView.checkbox.isChecked = false
        dateView.isHidden = false
    }
    
    func setupRxSubscriptions(){
        RxSubjects.openSelection.subscribe { [weak self] toOpen in
            if toOpen.element == true {
                self?.openSelection()
            } else {
                self?.closeSelection()
            }
        }.disposed(by: disposeBag)
    }
    
    func setupData(message: Message){
        self.message = message
        let date = message.date.getDate()
        msgView.msgContent?.date.text = TimeAgo.shared.getTime(date)
        msgView.msgContent?.status.setup(message.status)
        
        msgView.msgContent?.clickCallback = { [weak self] in
            if message.type == MsgType.image.rawValue || message.type == MsgType.video.rawValue {
                self?.delegate?.openMedia(data: message)
            }
        }
        
        msgView.msgContent?.repliedMsgView.clickCallback = { [weak self] in
            self?.delegate?.replyClick(data: message.repliedToMessage)
        }
        
        msgView.selectionOverlay.clickCallback = {[weak self] in
            guard let s = self else { return }
            s.msgView.checkbox.click()
            self?.delegate?.selectionClick(isChecked: s.msgView.checkbox.isChecked,
                                           data: s.message)
        }
        
        
        dateView.setupDate(currentMsgDate: message.date,
                           nextMsgDate: nextMessage == nil ? nil : nextMessage.date )

        if msgView.isOwn {
            roundOwnCorners()
        } else {
            roundOtherCorners()
        }
        
        layoutSubviews()
    }


    func setupView(){
        headerStack.addArrangedSubviews([dateView, unreadHeaderView])
        contentView.addSubview(headerStack)
        headerStack.easy.layout([
            Top(), CenterX()
        ])
        
        contentView.addSubview(msgView)
        msgView.easy.layout([
            Top().to(headerStack, .bottom), Leading(-32), Trailing(-64), Bottom(4)
        ])
    }
    
    func addGestureRecognizers(){
        let replyPanGesture = PanGestureRecognizer(direction: .horizontal, target: self, action: #selector(pan(_:)))
        msgView.addGestureRecognizer(replyPanGesture)
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longClick))
        long.minimumPressDuration = 0.3
        msgView.addGestureRecognizer(long)
    }
    
    func roundOwnCorners(){
        msgView.msgWrapper.topLeftRadius = 14
        msgView.msgWrapper.bottomLeftRadius = 14

        if messageSenderEqualWithPrevAndNext() && dateView.isHidden == true {
            msgView.msgWrapper.bottomRightRadius = 4
            msgView.msgWrapper.topRightRadius = 4


        } else if messageSenderEqualWithPrev() {
            msgView.msgWrapper.bottomRightRadius = 4
            msgView.msgWrapper.topRightRadius = 14

        } else if messageSenderEqualWithNext() {
            msgView.msgWrapper.bottomRightRadius = 14
            msgView.msgWrapper.topRightRadius = 4

        } else {
            msgView.msgWrapper.bottomRightRadius = 14
            msgView.msgWrapper.topRightRadius = 14
        }
    }
    
    func roundOtherCorners(){
        msgView.msgWrapper.bottomRightRadius = 14
        msgView.msgWrapper.topRightRadius = 14

        if messageSenderEqualWithPrevAndNext() && dateView.isHidden == true {
            msgView.msgWrapper.bottomLeftRadius = 4
            msgView.msgWrapper.topLeftRadius = 4

        } else if messageSenderEqualWithPrev(){
            msgView.msgWrapper.bottomLeftRadius = 4
            msgView.msgWrapper.topLeftRadius = 14

        } else if messageSenderEqualWithNext(){
            msgView.msgWrapper.bottomLeftRadius = 14
            msgView.msgWrapper.topLeftRadius = 4

        } else {
            msgView.msgWrapper.bottomLeftRadius = 14
            msgView.msgWrapper.topLeftRadius = 14
        }
    }
        
    func messageSenderEqualWithPrevAndNext() -> Bool {
        if nextMessage == nil || prevMessage == nil { return false }
        return message.senderUUID == prevMessage?.senderUUID && message.senderUUID == nextMessage?.senderUUID
    }
    
    func messageSenderEqualWithPrev() -> Bool {
        if prevMessage == nil { return false }
        return message.senderUUID == prevMessage?.senderUUID
    }
    
    func messageSenderEqualWithNext() -> Bool {
        if nextMessage == nil { return false }
        return message.senderUUID == nextMessage?.senderUUID
    }

    func openSelection(toAnimate: Bool = true){
        isSelectionOpened = true
        UIView.animate(withDuration: toAnimate ? 0.2 : 0) {
            self.msgView.selectionOverlay.isHidden = false
            self.msgView.spacer.easy.layout(Width(>=48))
            self.msgView.easy.layout(Leading())
            self.layoutIfNeeded()
        }
    }
    
    func closeSelection(toAnimate: Bool = true){
        isSelectionOpened = false
        UIView.animate(withDuration: toAnimate ? 0.2 : 0) {
            self.msgView.selectionOverlay.isHidden = true
            self.msgView.spacer.easy.layout(Width(>=80))
            self.msgView.easy.layout(Leading(-32))
            self.msgView.checkbox.isChecked = false
            self.layoutIfNeeded()
        }
    }
    
    
    @objc func longClick(){
        msgView.checkbox.isChecked = true
        delegate?.longClick(data: message)
    }
    
    @objc func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if isSelectionOpened { return }
        if message.status == MsgStatus.error.rawValue || message.status == MsgStatus.local.rawValue { return }
        let translation = gestureRecognizer.translation(in: self)

        switch gestureRecognizer.state {
        case .ended, .failed, .cancelled:
            replyVibrated = false
            UIView.animate(withDuration: 0.2) {
                self.msgView.easy.layout([
                    Trailing(-64), Leading(-32)
                ])
                self.layoutIfNeeded()
            }
            
            if translation.x < -60  {
                self.delegate?.swipe(data: message)
            }

        case .changed, .began, .possible:
            let trailingCons = 64+max(min(translation.x, 0), -64)
            let leadingCons = 32-max(min(translation.x, 0), -64)
            
            if trailingCons == 0 && !replyVibrated {
                replyVibrated = true
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } else if trailingCons >= 40 {
                replyVibrated = false
            }
            
            msgView.easy.layout([
                Trailing(-trailingCons), Leading(-leadingCons)
            ])

        @unknown default:
            UIView.animate(withDuration: 0.2) {
                self.msgView.easy.layout([
                    Trailing(-64), Leading(-32)
                ])
                self.layoutIfNeeded()
            }
        }
    }
}
