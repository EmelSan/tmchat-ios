//
//  UIWindow.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import UIKit

extension UIWindow {

    static var currentVisibleWindow: UIWindow? {
        let application = UIApplication.shared
        let windows: [UIWindow]?

        if #available(iOS 13.0, *) {
            windows = (application.connectedScenes.first as? UIWindowScene)?.windows
        } else {
            guard let window = application.keyWindow else { return nil }

            windows = [window]
        }
        return windows?.last { $0.windowLevel == .normal }
    }

    static var keyWindow: UIWindow? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }

    static var topVisibleViewController: UIViewController? {
        currentVisibleWindow?.topVisibleViewController
    }

    var topVisibleViewController: UIViewController? {
        guard let rootViewController else { return nil }

        return topVisibleViewController(rootViewController: rootViewController)
    }

    private func topVisibleViewController(rootViewController: UIViewController) -> UIViewController? {
        if let tabBarController = rootViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topVisibleViewController(rootViewController: selectedViewController)
        }
        if let navigationController = rootViewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return topVisibleViewController(rootViewController: visibleViewController)
        }
        if let presentedViewController = rootViewController.presentedViewController {
            return topVisibleViewController(rootViewController: presentedViewController)
        }
        return rootViewController
    }
}
