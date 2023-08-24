//
//  TabbarController.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit

class TabbarController: BubbleTabBarController {

    private var signalingClient: SignalingClient!

    private lazy var webRTCClient: WebRTCClient = {
        let client = WebRTCClient()
        client.delegate = signalingClient
        return client
    }()
    private var callSnackbar = CallSnackbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.clipsToBounds = true
        
        setupVc()
        connectToSocekt()
        connectToWebRTC()
        sendContacts()
        
//        ChatRequests.shared.getContacts { resp in
//            print(resp)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupVc() {
        let chatlist = ChatlistVC()
        chatlist.tabBarItem = UITabBarItem(title: "chats".localized(),
                                           image: UIImage(named: "chat"),
                                           selectedImage: UIImage(named: "chat-active"))
        
        let feed = FeedVC()
        feed.tabBarItem = UITabBarItem(title: "feed".localized(),
                                           image: UIImage(named: "feed"),
                                           selectedImage: UIImage(named: "feed-active"))

        let profile = ProfileTabVC()
        profile.tabBarItem = UITabBarItem(title: "profile".localized(),
                                           image: UIImage(named: "profile"),
                                           selectedImage: UIImage(named: "profile-active"))

        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "profile".localized(),
                                           image: UIImage(named: "profile"),
                                           selectedImage: UIImage(named: "profile-active"))

        setViewControllers([chatlist, feed, profile], animated: false)
    }
    
    func connectToSocekt() {
        ChatRequests.shared.getRooms { resp in
            RoomTable.shared.upsertRooms(rooms: resp?.data ?? [])
            SocketClient.shared.connect()
        }
    }

    // MARK: - FIXME: Replace this
    func connectToWebRTC() {
        signalingClient = SignalingClient { [weak self] action in
            guard let self else { return }

            switch action {
            case let .didRequestLocalSDP(data):
                guard
                    let window = UIWindow.currentVisibleWindow,
                    let friend = data.friendModel,
                    let roomID = data.roomId
                else {
                    return
                }
                let avatarURL = ApiPath.url(friend.avatar ?? "")
                let colorCode = friend.colorCode
                self.callSnackbar.model = .init(userName: friend.fullName ?? friend.username ?? "unknown",
                                                avatarURL: avatarURL,
                                                colorCode: colorCode)

                self.callSnackbar.show(on: window, onAnswer: { [weak self] in
                    PermissionManager.requestPermission(for: .camera) { [weak self] granted in
                        guard let self, granted else { return }

                        self.webRTCClient.setup()

                        if let sessionDescription = data.sessionDescription?.data(using: .utf8),
                           let session = try? JSONDecoder().decode(SessionDescription.self, from: sessionDescription) {
                            self.webRTCClient.set(remoteSdp: session)
                            self.signalingClient.didReceivedRemoteSDP = true
                        }
                        self.webRTCClient.answer { [weak self] sdp in
                            self?.signalingClient.sendAnswer(sessionDescription: .init(sdp: sdp.sdp),
                                                             friend: friend,
                                                             roomID: roomID,
                                                             callType: data.call_type)
                        }
                        self.callSnackbar.hide()
                        self.showCall(type: .incoming, friend: friend, roomID: roomID)
                    }
                }, onDismiss: { [weak self] in
                    self?.callSnackbar.hide()
                    self?.signalingClient.sendClose(friend: friend, roomID: roomID)
                })
            case let .didReceiveRemoteSDP(description):
                self.signalingClient.didReceivedRemoteSDP = true
                self.webRTCClient.set(remoteSdp: description)
            case let .didReceiveCandidate(candidate):
                self.webRTCClient.set(remoteCandidate: candidate)
            case .close:
                self.callSnackbar.hide()
                self.webRTCClient.disconnect()

                guard UIWindow.topVisibleViewController is CallVC else { return }

                UIWindow.topVisibleViewController?.dismiss(animated: true)
            }
        }
    }

    // MARK: - FIXME: Replace this
    func call(friend: User, roomID: String) {
        PermissionManager.requestPermission(for: .camera) { [weak self] granted in
            guard let self, granted else { return }

            self.webRTCClient.setup()
            self.webRTCClient.offer { [weak self] sdp in
                self?.signalingClient.sendOffer(sessionDescription: .init(sdp: sdp.sdp), friend: friend, roomID: roomID)
            }
            self.showCall(type: .outgoing, friend: friend, roomID: roomID)
        }
    }

    func finishCall(friend: User, roomID: String) {
        if UIWindow.topVisibleViewController is CallVC {
            UIWindow.topVisibleViewController?.dismiss(animated: true)
        }
        webRTCClient.disconnect()
        signalingClient.sendClose(friend: friend, roomID: roomID)
    }
    
    func sendContacts() {
        if AccUserDefaults.contactsSend { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let _ = self else { return }
            ContactService().sendContactList()
        }
    }

    private func showCall(type: CallVC.CallType, friend: User, roomID: String, completion: VoidClosure? = nil) {
        let callVC = CallVC(callType: type, friend: friend, roomID: roomID, webRTCClient: webRTCClient)
        callVC.modalPresentationStyle = .fullScreen
        callVC.modalTransitionStyle = .crossDissolve

        UIWindow.topVisibleViewController?.present(callVC, animated: true, completion: completion)
    }
}
