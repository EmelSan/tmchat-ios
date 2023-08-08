//
//  ErrorMessageView.swift
//  Salam
//
//  Created by Begga on 2/16/21.
//

import UIKit

class ErrorMessageView: UIView {
    
    private var msg = UILabel(font: .medium(size: 14), color: .white, alignment: .left, numOfLines: 0, text: "smth_went_wrong".localized())
        
    var beginningPositionY: CGFloat = 0

    var interactionCallback: ( () -> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        
        layer.cornerRadius = 6
        
        addSubview(msg)
    }
    
    override func layoutSubviews() {
        msg.frame = CGRect(x: 15, y: 17, width: frame.width - 10 - 40, height: 30)
        msg.sizeToFit()
        
        frame.size.height = msg.frame.height + 32
    }
    
    func set(errorMessage: String) {
        msg.text = errorMessage
        self.layoutSubviews()
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        self.interactionCallback?()
        
        switch recognizer.state {
        case .began:
            beginningPositionY = self.frame.minY
            break
            
        case .changed:
            if self.frame.origin.y + translation.y < beginningPositionY {
                self.frame.origin.y += translation.y / 5
            } else {
                self.frame.origin.y = min(self.frame.origin.y + translation.y, 70)
            }
            
            recognizer.setTranslation(.zero, in: self)
            
        case .ended:
            if self.frame.origin.y < beginningPositionY {
                UIView.animate(withDuration: 0.2) {
                    self.frame.origin.y = -100
                }
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.frame.origin.y = (UIApplication.shared.windows.first?.frame.minY ?? 0) + 60
                }
            }
            
        default:
            break
        }
    }
    
    @objc func close() {
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y = -100
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

