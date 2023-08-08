//
//  UIEdgeInsets.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit

extension UIEdgeInsets {

    init(edges: CGFloat) {
        self.init(top: edges,
                  left: edges,
                  bottom: edges,
                  right: edges)
    }
    
    init(horizontalEdges: CGFloat = 0, verticalEdges: CGFloat = 0) {
        self.init(top: verticalEdges,
                  left: horizontalEdges,
                  bottom: verticalEdges,
                  right: horizontalEdges)
    }
}
