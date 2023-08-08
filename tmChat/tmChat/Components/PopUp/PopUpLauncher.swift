//
//  PopUpLauncher.swift
//  Salam
//
//  Created by Begga on 2/16/21.
//

import UIKit
import EasyPeasy

class PopUpLauncher {
    
    static var popUpTimer: Timer?
    static var remainingTime = 0
    
    static var errorMessageView: ErrorMessageView = {
        let msg = ErrorMessageView()
        return msg
    }()
    
    static func showSuccessMessage(text: String) {
        errorMessageView.backgroundColor = .systemGreen
        show(text: text)
    }
    
    static func showErrorMessage(text: String) {
        errorMessageView.backgroundColor = .alert
        show(text: text)
    }
    
    static func showWarningMessage(text: String) {
        errorMessageView.backgroundColor = .orange
        show(text: text)
    }
    
    static func show(text: String) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.addSubview(errorMessageView)

        errorMessageView.frame = CGRect(x: 20, y: 0, width: DeviceDimensions.width - 40, height: 50)
        errorMessageView.set(errorMessage: text)
        
        errorMessageView.interactionCallback = {
            self.remainingTime = 2
        }
        
        UIView.animate(withDuration: 0.2) {
            self.errorMessageView.frame.origin.y = 60 
        }
        
        self.remainingTime = 2
        if ( popUpTimer == nil ) {
            self.popUpTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
    }
    
    @objc static func countDown() {
        self.remainingTime -= 1
        
        if (self.remainingTime < 0) {
            self.popUpTimer?.invalidate()
            self.popUpTimer = nil
            self.errorMessageView.close()
        }
    }
}

