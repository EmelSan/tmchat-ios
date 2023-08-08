//
//  CustomCornerView.swift
//  tmchat
//
//  Created by Shirin on 4/3/23.
//

import UIKit

class CustomCornerView: UIView  {

    func applyRadiusMaskFor() {
        let path = UIBezierPath(shouldRoundRect: bounds,
                                topLeftRadius: topLeftRadius,
                                topRightRadius: topRightRadius,
                                bottomLeftRadius: bottomLeftRadius,
                                bottomRightRadius: bottomRightRadius)
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }

    var topLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    var topRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    var bottomLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    var bottomRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyRadiusMaskFor()
    }
}


