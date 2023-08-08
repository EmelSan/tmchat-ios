//
//  ErrorCodes.swift
//  tmchat
//
//  Created by Shirin on 3/22/23.
//

import Foundation

class ErrorCodes {
    
    static private let errorCodes = [
        400: "invalid_phone".localized(),

    ]
    
    class func handleError(_ code: Int) {
        guard let desc = errorCodes[code] else { return }
        print("error ", desc)
//        PopUpLauncher.showErrorMessage(text: desc)
    }
}
