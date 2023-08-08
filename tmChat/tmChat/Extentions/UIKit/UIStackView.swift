//
//  UIStackView.swift
//  Meninki
//
//  Created by NyanDeveloper on 08.12.2022.
//

import UIKit.UIStackView

extension UIStackView {

    convenience init(axis: NSLayoutConstraint.Axis,
                     alignment: Alignment,
                     spacing: CGFloat,
                     edgeInsets: UIEdgeInsets? = nil,
                     distribution: Distribution? = nil,
                     backgroundColor: UIColor? = nil,
                     cornerRadius: CGFloat? = nil) {
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        
        if edgeInsets != nil {
            isLayoutMarginsRelativeArrangement = true
            layoutMargins = edgeInsets!
        }
        
        if distribution != nil {
            self.distribution = distribution!
        }
        
        if backgroundColor != nil || cornerRadius != nil {
            let _ = addBackground(color: backgroundColor,
                                  cornerRadius: cornerRadius)
        }
    }
    
    func addMargins(top: CGFloat = 0,
                    left: CGFloat = 0,
                    bottm: CGFloat = 0,
                    right: CGFloat = 0) {
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: top,
                                     left: left,
                                     bottom: bottm,
                                     right: right)
    }
    
    func addMargins(edges: CGFloat = 0) {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: edges,
                                     left: edges,
                                     bottom: edges,
                                     right: edges)
    }
    
    func addBackground(color: UIColor?,
                       cornerRadius: CGFloat?,
                       borderWidth: CGFloat = 0,
                       borderColor: UIColor? = nil) -> UIView {
        
        let subView = UIView(frame: frame)
        subView.backgroundColor = color
        subView.layer.cornerRadius = cornerRadius ?? 0
        subView.layer.borderWidth = borderWidth
        subView.layer.borderColor = borderColor?.cgColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        return subView
    }
    
    func addBackground(bgView: UIView) {
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(bgView, at: 0)
    }



    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { vw in
            addArrangedSubview(vw)
        }
    }
    
    func removeSubviews() {
        self.subviews.forEach { vw in
            vw.removeFromSuperview()
        }
    }
}
