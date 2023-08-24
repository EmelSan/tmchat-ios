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

    // MARK: - Private Methods

    private let myVideoContainerView = UIView()
    private let otherVideoContainerView = UIView()

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Public Methods

    func disable() {
        otherVideoContainerView.subviews.forEach { $0.removeFromSuperview() }
        myVideoContainerView.subviews.forEach { $0.removeFromSuperview() }
    }

    func setup(client: WebRTCClient) {
        #if arch(arm64)
        let localRenderer = RTCMTLVideoView(frame: .zero)
        let remoteRenderer = RTCMTLVideoView(frame: .zero)
        localRenderer.videoContentMode = .scaleAspectFill
        localRenderer.layoutMargins = .zero
        remoteRenderer.videoContentMode = .scaleAspectFill
        remoteRenderer.layoutMargins = .zero
        #else
        let localRenderer = RTCEAGLVideoView(frame: .zero)
        let remoteRenderer = RTCEAGLVideoView(frame: .zero)
        #endif

        client.startCaptureLocalVideo(renderer: localRenderer)
        client.renderRemoteVideo(to: remoteRenderer)

        myVideoContainerView.addSubview(localRenderer)
        otherVideoContainerView.addSubview(remoteRenderer)

        localRenderer.easy.layout(Edges())
        remoteRenderer.easy.layout(Edges())
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(otherVideoContainerView)
        view.addSubview(myVideoContainerView)

        otherVideoContainerView.easy.layout(Edges())
        myVideoContainerView.easy.layout(Trailing(16), Bottom(64), Height(200), Width(120))

        myVideoContainerView.layer.cornerRadius = 24
    }
}
