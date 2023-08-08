//
//  UINavigationController.swift
//  TmAuction
//
//  Created by Shirin on 12/23/22.
//

import UIKit.UINavigationController

extension UINavigationController {
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
