//
//  SignalingClient.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import Foundation
import WebRTC

final class SignalingClient {

    // MARK: - Types

    enum Action {
        case didRequestLocalSDP(SDPData)
        case didReceiveRemoteSDP(SessionDescription)
        case didReceiveCandidate(IceCandidate)
        case close
    }

    // MARK: - Public Properties

    var callback: ((Action) -> ())

    // MARK: - Private Properties

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    // MARK: - Init

    init(callback: @escaping ((Action) -> ())) {
        self.callback = callback
        observeWebSocket()
    }

    // MARK: - Public Methods

    func sendSDP(type: SdpType,
                 sessionDescription: SessionDescription? = nil,
                 candidate: IceCandidate? = nil,
                 roomID: String? = nil,
                 friend: User? = nil,
                 callType: String? = "audio") {
        var friendStr: String?

        if let friend, let friendData = try? encoder.encode(friend) {
            friendStr = String(data: friendData, encoding: .utf8)
        }
        let sdp = SDPData(type: type.rawValue,
                          candidate: candidate,
                          sessionDescription: sessionDescription,
                          friend: friendStr,
                          roomId: roomID,
                          call_type: callType)
        sendSDP(data: sdp)
    }

    func sendSDP(data: SDPData) {
        SocketClient.shared.sendMsg(data: DataSDP(sdp_data: data), emit: .sendSDP)
    }

    func close(friend: User, roomID: String) {
        sendSDP(type: .close, sessionDescription: .init(sdp: "", type: .close), roomID: roomID, friend: friend)
    }

    func didReceiveData(data: DataSDP) {
        guard let sdp = data.sdp_data, let sessionDescription = sdp.sessionDescription else { return }

        switch SdpType(rawValue: sessionDescription.type) {
        case .offer:
            callback(.didRequestLocalSDP(sdp))
        case .candidate:
            guard let candidate = sdp.candidate else { return }

            callback(.didReceiveCandidate(candidate))
        case .answer:
            callback(.didReceiveRemoteSDP(sessionDescription))
        case .close:
            callback(.close)
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func observeWebSocket() {
        NotificationCenter.default.addObserver(self, selector: #selector(socketDidReceiveEvent(notification:)),
                                               name: .socketClientDidReceiveEvent,
                                               object: nil)
    }

    @objc
    private func socketDidReceiveEvent(notification: Notification) {
        guard let data = notification.object as? Data else { return }

        do {
            let event = try decoder.decode(SocketEvent<DataSDP>.self, from: data)

            guard event.event == SocketEmits.sendSDP.rawValue else { return }

            didReceiveData(data: event.data)
        } catch {
            debugPrint("PARSING ERROR: \(error)")
        }
    }
}

// MARK: - WebRTCClientDelegate

extension SignalingClient: WebRTCClientDelegate {

    func webRTCClient(_ client: WebRTCClient, didReceiveCandidate candidate: RTCIceCandidate) {
        sendSDP(type: .candidate, candidate: .init(from: candidate))
    }
}
