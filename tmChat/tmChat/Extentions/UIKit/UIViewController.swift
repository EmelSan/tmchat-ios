//
//  UIViewController.swift
//  Meninki
//
//  Created by NyanDeveloper on 08.12.2022.
//

import UIKit.UIViewController

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @discardableResult
    func add(child: UIViewController, container: UIView) -> UIView? {
        guard let childView = child.view else { return nil }

        child.willMove(toParent: self)
        container.addSubview(childView)
        addChild(child)
        child.didMove(toParent: self)

        return childView
    }

    func remove(child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
