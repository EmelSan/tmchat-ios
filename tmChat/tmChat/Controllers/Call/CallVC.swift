//
//  CallVC.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import UIKit
import EasyPeasy

final class CallVC: UIViewController {

    // MARK: - Types

    enum CallType {
        case incoming
        case outgoing
    }

    // MARK: - Public Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Private Properties

    private let titleLabel = UILabel(font: .bold(size: 32), color: .lightClear)
    private let subtitleLabel = UILabel(font: .semibold(size: 14), color: .lightClear)
    private let rejectButton = IconBtn(image: UIImage(named: "call-rejection"), color: .lightClear)
    private let volumeButton = BluredButton(image: UIImage(named: "volume-on"))
    private let cameraButton = BluredButton(image: UIImage(named: "camera-off"))
    private let microButton = BluredButton(image: UIImage(named: "mic-on"))
    private let avatarImageView = UIImageView(contentMode: .scaleAspectFill, cornerRadius: 0)
    private let videoContainer = UIView()

    private let bottomBar: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        return stack
    }()

    private let callType: CallType
    private let friend: User
    private let roomID: String
    private let webRTCClient: WebRTCClient
    private lazy var videoVC = VideoCallVC(webRTCClient: webRTCClient)


    private var isOnVolume = true {
        didSet {
            volumeButton.setImage(named: isOnVolume ? "volume-on" : "volume-off")
            webRTCClient.setAudioEnabled(isOnVolume)
        }
    }

    private var isOnCamera = true {
        didSet {
            if isOnCamera {
                if PermissionManager.hasPermission(for: .camera) {
                    cameraButton.setImage(named: "camera-on")
                    webRTCClient.setVideoEnabled(true)
                    add(child: videoVC, container: videoContainer)
                } else {
                    PermissionManager.requestPermission(for: .camera) { [weak self] granted in
                        guard granted else {
                            self?.isOnCamera.toggle()
                            return
                        }

                        self?.cameraButton.setImage(named: "camera-on")
                        self?.webRTCClient.setVideoEnabled(true)
                    }
                }
            } else {
                cameraButton.setImage(named: "camera-off")
                webRTCClient.setVideoEnabled(false)
                remove(child: videoVC)
            }
        }
    }

    private var isOnMicro = true {
        didSet {
            if isOnMicro {
                if PermissionManager.hasPermission(for: .microphone) {
                    microButton.setImage(named: "mic-on")
                    webRTCClient.speakerOn()
                } else {
                    PermissionManager.requestPermission(for: .microphone) { [weak self] granted in
                        guard granted else {
                            self?.isOnMicro.toggle()
                            return
                        }

                        self?.microButton.setImage(named: "mic-on")
                        self?.webRTCClient.speakerOn()
                    }
                }
            } else {
                microButton.setImage(named: "mic-off")
                webRTCClient.speakerOff()
            }
        }
    }

    // MARK: - Init

    init(callType: CallType, friend: User, roomID: String, webRTCClient: WebRTCClient) {
        self.callType = callType
        self.friend = friend
        self.roomID = roomID
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

        setupViews()
        reloadData()
        bind()

        isOnMicro = true
        isOnVolume = true
        isOnCamera = true
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(avatarImageView)
        view.addSubview(videoContainer)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(bottomBar)

        bottomBar.addArrangedSubviews([volumeButton, cameraButton, microButton, UIView(), rejectButton])
        avatarImageView.easy.layout(Edges())
        videoContainer.easy.layout(Edges())

        titleLabel.easy.layout([
            Top(6).to(view.safeAreaLayoutGuide, .top), Leading(30), Trailing(80)
        ])
        subtitleLabel.easy.layout([
            Top(6).to(titleLabel, .bottom), Leading(30), Trailing(80)
        ])
        bottomBar.easy.layout([
            Leading(30), Trailing(30), Bottom(30)
        ])

        rejectButton.backgroundColor = .alert
        rejectButton.layer.cornerRadius = 20
    }

    private func bind() {
        rejectButton.clickCallback = { [weak self] in
            guard let self else { return }

            (UIApplication.shared.delegate as? AppDelegate)?.tabbar?.finishCall(friend: self.friend, roomID: self.roomID)
        }
        cameraButton.clickCallback = { [weak self] in
            self?.isOnCamera.toggle()
        }
        microButton.clickCallback = { [weak self] in
            self?.isOnMicro.toggle()
        }
        volumeButton.clickCallback = { [weak self] in
            self?.isOnVolume.toggle()
        }
    }

    private func reloadData() {
        avatarImageView.kf.setImage(with: ApiPath.url(friend.avatar ?? ""))
        avatarImageView.backgroundColor = UIColor(hexString: friend.colorCode ?? "#A5A5A5")

        switch callType {
        case .incoming:
            subtitleLabel.text = "incoming_call".localized()
        case .outgoing:
            subtitleLabel.text = "outgoing_call".localized()
        }
        if !friend.fullName.isEmpty {
            titleLabel.text = friend.fullName
        } else {
            titleLabel.text = friend.username
        }
    }
}
