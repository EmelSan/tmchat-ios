//
//  PanGestureRecognizer.swift
//  tmchat
//
//  Created by Shirin on 3/20/23.
//

import UIKit

enum PanDirection {
    case vertical
    case horizontal
}

struct Constaint {
    let maxAngle: Double
    let minSpeed: CGFloat

    static let `default` = Constaint(maxAngle: 50, minSpeed: 50)
}

class PanGestureRecognizer: UIPanGestureRecognizer {
    
    let direction: PanDirection

    let constraint: Constaint


    init(direction orientation: PanDirection, target: AnyObject, action: Selector, constraint limits: Constaint = Constaint.default) {
        direction = orientation
        constraint = limits
        super.init(target: target, action: action)
    }
    
    init(direction orientation: PanDirection) {
        direction = orientation
        constraint = Constaint.default
        
        super.init(target: nil, action: nil)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let tangent = tan(constraint.maxAngle * Double.pi / 180)
        if state == .began {
            let vel = velocity(in: view)
            switch direction {
            case .horizontal where abs(vel.y)/abs(vel.x) > CGFloat(tangent) || abs(vel.x) < constraint.minSpeed:
                state = .cancelled
            case .vertical where abs(vel.x)/abs(vel.y) > CGFloat(tangent) || abs(vel.y) < constraint.minSpeed:
                state = .cancelled
            default:
                break
            }
        }
    }
}
