//
//  RemoteVideoView.swift
//  tmchat
//
//  Created by Farid Guliev on 24.08.2023.
//

import MetalKit
import WebRTC
import EasyPeasy

final class VideoView: UIView {

    private lazy var rtcMetalView = RTCMTLVideoView(frame: bounds)
    private var applyDefaultRendererConfigurationOnNextFrame = false

    init() {
        super.init(frame: .zero)

        addSubview(rtcMetalView)

        rtcMetalView.easy.layout(Edges())
        rtcMetalView.layoutMargins = .zero

        for subview in rtcMetalView.subviews {
            if subview is MTKView, subview.superview != nil {
                subview.easy.layout(Edges())
            }
        }

        applyDefaultRendererConfiguration()

        #if targetEnvironment(simulator)
        backgroundColor = .blue.withAlphaComponent(0.4)
        #endif
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func applyDefaultRendererConfiguration() {
        rtcMetalView.videoContentMode = .scaleAspectFill
        rtcMetalView.rotationOverride = nil
    }
}

extension VideoView: RTCVideoRenderer {

    func setSize(_ size: CGSize) {
        rtcMetalView.setSize(size)
    }

    func renderFrame(_ frame: RTCVideoFrame?) {
        rtcMetalView.renderFrame(frame)

        DispatchQueue.main.async { [self] in
            if applyDefaultRendererConfigurationOnNextFrame {
                applyDefaultRendererConfigurationOnNextFrame = false
                applyDefaultRendererConfiguration()
            }

            guard let frame else { return }

            let isLandscape: Bool

            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                isLandscape = false
                rtcMetalView.rotationOverride = nil

            case .landscapeLeft:
                isLandscape = true
                switch frame.rotation {
                    // Portrait upside-down
                case ._270:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._0.rawValue)

                    // Portrait
                case ._90:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._180.rawValue)

                    // Landscape right
                case ._180:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._270.rawValue)

                    // Landscape left
                case ._0:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._90.rawValue)
                @unknown default:
                    return
                }
            case .landscapeRight:
                isLandscape = true

                switch frame.rotation {
                    // Portrait upside-down
                case ._270:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._180.rawValue)

                    // Portrait
                case ._90:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._0.rawValue)

                    // Landscape right
                case ._180:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._90.rawValue)

                    // Landscape left
                case ._0:
                    rtcMetalView.rotationOverride = NSNumber(value: RTCVideoRotation._270.rawValue)
                @unknown default:
                    return
                }
            default:
                isLandscape = false
            }
            let remoteIsLandscape = frame.rotation == RTCVideoRotation._180 || frame.rotation == RTCVideoRotation._0
            let isSquarish = max(bounds.width, bounds.height) / min(bounds.width, bounds.height) <= 1.2

            if (isLandscape == remoteIsLandscape || isSquarish) {
                rtcMetalView.videoContentMode = .scaleAspectFill
            } else {
                rtcMetalView.videoContentMode = .scaleAspectFit
            }
        }
    }
}
