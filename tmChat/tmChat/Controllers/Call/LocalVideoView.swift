//
//  LocalVideoView.swift
//  tmchat
//
//  Created by Farid Guliev on 24.08.2023.
//

import AVFoundation
import WebRTC

final class LocalVideoView: UIView {

    private let localVideoCapturePreview = RTCCameraPreviewView()

    var captureSession: AVCaptureSession? {
        get { localVideoCapturePreview.captureSession }
        set { localVideoCapturePreview.captureSession = newValue }
    }

    override var contentMode: UIView.ContentMode {
        didSet { localVideoCapturePreview.contentMode = contentMode }
    }

    init() {
        super.init(frame: .zero)

        addSubview(localVideoCapturePreview)

        #if targetEnvironment(simulator)
        backgroundColor = .brown
        #endif
    }

    required init?(coder: NSCoder) {
        nil
    }
}

extension RTCCameraPreviewView {

    var previewLayer: AVCaptureVideoPreviewLayer? {
        layer as? AVCaptureVideoPreviewLayer
    }

    open override var contentMode: UIView.ContentMode {
        get {
            guard let previewLayer else { return .scaleToFill }

            switch previewLayer.videoGravity {
            case .resizeAspectFill:
                return .scaleAspectFill
            case .resizeAspect:
                return .scaleAspectFit
            case .resize:
                return .scaleToFill
            default:
                return .scaleToFill
            }
        }
        set {
            guard let previewLayer else { return }

            switch newValue {
            case .scaleAspectFill:
                previewLayer.videoGravity = .resizeAspectFill
            case .scaleAspectFit:
                previewLayer.videoGravity = .resizeAspect
            case .scaleToFill:
                previewLayer.videoGravity = .resize
            default:
                return
            }
        }
    }
}
