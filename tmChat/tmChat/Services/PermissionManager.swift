//
//  PermissionManager.swift
//  tmchat
//
//  Created by Farid Guliev on 23.08.2023.
//

import AVFoundation
import UIKit

enum PermissionType {
    case camera
    case microphone
}

class PermissionManager {

    static func hasPermission(for type: PermissionType) -> Bool {
        switch type {
        case .camera:
            return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        case .microphone:
            return AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
        }
    }

    static func requestPermission(for type: PermissionType, completion: @escaping Closure<Bool>) {
        switch type {
        case .camera:
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                completion(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            case .denied, .restricted:
                showPermissionAlert(for: .camera)
                completion(false)
            @unknown default:
                assertionFailure("Unknown permission status")
                completion(false)
            }
        case .microphone:
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized:
                completion(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            case .denied, .restricted:
                showPermissionAlert(for: .microphone)
                completion(false)
            @unknown default:
                assertionFailure("Unknown permission status")
                completion(false)
            }
        }
    }

    private static func showPermissionAlert(for type: PermissionType) {
        var permissionName = ""
        var permissionDescription = ""

        switch type {
        case .camera:
            permissionName = "Camera"
            permissionDescription = "This app needs access to your camera for video call."
        case .microphone:
            permissionName = "Microphone"
            permissionDescription = "This app needs access to your microphone for audio call."
        }

        let alertController = UIAlertController(title: "\(permissionName) Access Required",
                                                message: permissionDescription,
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        UIWindow.topVisibleViewController?.present(alertController, animated: true, completion: nil)
    }
}

