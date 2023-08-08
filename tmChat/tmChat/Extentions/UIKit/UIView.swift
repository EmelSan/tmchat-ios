//
//  UIView.swift
//  Meninki
//
//  Created by NyanDeveloper on 11.12.2022.
//

import UIKit.UIView

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension UIGestureRecognizer {
  func cancel() {
    isEnabled = false
    isEnabled = true
  }
}
