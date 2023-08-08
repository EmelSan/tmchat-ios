//
//  DateView.swift
//  tmchat
//
//  Created by Shirin on 4/11/23.
//

import UIKit
import EasyPeasy

class DateView: UIView {

    var dateWrapper = UIView()
    
    var date = UILabel(font: .text_14_r,
                       color: .white,
                       alignment: .justified,
                       numOfLines: 1,
                       text: "--.--.----")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        dateWrapper.backgroundColor = .bapAccent
        dateWrapper.layer.cornerRadius = 16
        
        dateWrapper.addSubview(date)
        date.easy.layout([
            Leading(10), Trailing(10), CenterY()
        ])
        
        date.setContentHuggingPriority(.required, for: .horizontal)
        date.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addSubview(dateWrapper)
        dateWrapper.easy.layout([
            Top(10), CenterX(), Bottom(8), Height(32)
        ])
    }
    
    func setupDate(currentMsgDate: String?, nextMsgDate: String?){        
        guard let current = currentMsgDate?.getDate() else { return }
        guard let next = nextMsgDate?.getDate() else {
            self.date.text = TimeAgo.shared.getDayOrDate(current)
            isHidden = false
            return
        }
                
        self.date.text = TimeAgo.shared.getDayOrDate(current)
        let nextDays = next.days(sinceDate: Date(milliseconds: 1)) ?? 0
        let currentDays = current.days(sinceDate: Date(milliseconds: 1)) ?? 0
        isHidden = !(currentDays > nextDays)
    }
}
