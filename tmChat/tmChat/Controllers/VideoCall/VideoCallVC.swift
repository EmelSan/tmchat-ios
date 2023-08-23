//
//  VideoCallVC.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import UIKit
import EasyPeasy
import WebRTC

final class VideoCallVC: UIViewController {

    // MARK: - Types

    // MARK: - Private Methods

    private let webRTCClient: WebRTCClient
    private let myVideoContainerView = UIView()
    private let otherVideoContainerView = UIView()

    // MARK: - Init

    init(webRTCClient: WebRTCClient) {
        self.webRTCClient = webRTCClient

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Private Methods

    private func setup() {
        #if arch(arm64)
        let localRenderer = RTCMTLVideoView(frame: .zero)
        let remoteRenderer = RTCMTLVideoView(frame: .zero)
        localRenderer.videoContentMode = .scaleAspectFill
        remoteRenderer.videoContentMode = .scaleAspectFill
        #else
        let localRenderer = RTCEAGLVideoView(frame: .zero)
        let remoteRenderer = RTCEAGLVideoView(frame: .zero)
        #endif

        webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
        webRTCClient.renderRemoteVideo(to: remoteRenderer)

        myVideoContainerView.addSubview(localRenderer)
        otherVideoContainerView.addSubview(remoteRenderer)

        localRenderer.easy.layout(Edges())
        remoteRenderer.easy.layout(Edges())

        view.addSubview(otherVideoContainerView)
        view.addSubview(myVideoContainerView)

        otherVideoContainerView.easy.layout(Edges())
        myVideoContainerView.easy.layout([
            Leading(16), Bottom(64), Height(200), Width(120)
        ])

        myVideoContainerView.layer.cornerRadius = 24
    }
}
