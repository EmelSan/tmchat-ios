//
//  CheckOtpParams.swift
//  tmchat
//
//  Created by Shirin on 3/22/23.
//

import UIKit.UIDevice

struct CheckOtpParams: Codable {
    var code: Int
    var userId: String = AccUserDefaults.id
    var deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var firebaseToken: String = AccUserDefaults.fcm
}
