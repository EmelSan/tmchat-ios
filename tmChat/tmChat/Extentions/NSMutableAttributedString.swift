//
//  NSMutableAttributedString.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
