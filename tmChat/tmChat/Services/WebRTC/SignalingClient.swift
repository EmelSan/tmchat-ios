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

    var callback: Closure<Action>

    var didReceivedRemoteSDP = false {
        didSet {
            guard didReceivedRemoteSDP, !cachedLocalCandidates.isEmpty else { return }
            guard let cachedFriend, let cachedRoomID, let cachedCallType else { return }


            cachedLocalCandidates.forEach {
                sendCandidate(candidate: .init(from: $0), friend: cachedFriend, roomID: cachedRoomID, callType: cachedCallType)
            }
            cachedLocalCandidates = []
        }
    }

    // MARK: - Private Properties

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private var cachedFriend: User?
    private var cachedRoomID: String?
    private var cachedCallType: String?
    private var cachedLocalCandidates = [RTCIceCandidate]()

    // MARK: - Init

    init(callback: @escaping Closure<Action>) {
        self.callback = callback
        observeWebSocket()
    }

    // MARK: - Public Methods

    func sendAnswer(sessionDescription: SessionDescription, friend: User, roomID: String, callType: String?) {
        let type = SdpType.answer.rawValue
        var sessionDescription = sessionDescription
        sessionDescription.type = type
        let data = SDPData(type: type,
                           sessionDescription: toString(model: sessionDescription),
                           friend: toString(model: friend),
                           roomId: roomID,
                           call_type: callType)
        cachedFriend = friend
        cachedRoomID = roomID
        cachedCallType = callType
        sendSDP(data: data)
    }

    func sendOffer(sessionDescription: SessionDescription, friend: User, roomID: String, callType: String = "video") {
        let type = SdpType.offer.rawValue
        var sessionDescription = sessionDescription
        sessionDescription.type = type
        let data = SDPData(type: type,
                           sessionDescription: toString(model: sessionDescription),
                           friend: toString(model: friend),
                           roomId: roomID,
                           call_type: callType)
        cachedFriend = friend
        cachedRoomID = roomID
        cachedCallType = callType
        sendSDP(data: data)
    }

    func sendCandidate(candidate: IceCandidate, friend: User, roomID: String, callType: String) {
        let type = SdpType.candidate.rawValue
        let data = SDPData(type: type, candidate: toString(model: candidate), friend: toString(model: friend), roomId: roomID)
        sendSDP(data: data)
    }

    func sendClose(friend: User, roomID: String) {
        let type = SdpType.close.rawValue
        let data = SDPData(type: type, friend: toString(model: friend), roomId: roomID)
        cachedFriend = nil
        cachedRoomID = nil
        cachedCallType = nil
        cachedLocalCandidates = []
        didReceivedRemoteSDP = false
        sendSDP(data: data)
    }

    // MARK: - Private Methods

    private func observeWebSocket() {
        NotificationCenter.default.addObserver(self, selector: #selector(socketDidReceiveEvent(notification:)),
                                               name: .socketClientDidReceiveEvent,
                                               object: nil)
    }

    private func sendSDP(data: SDPData) {
        SocketClient.shared.sendMsg(data: DataSDP(sdp_data: data), emit: .sendSDP)
    }

    private func didReceiveData(data: DataSDP) {
        guard let sdp = data.sdp_data, let sessionDescription = sdp.sessionModel else { return }

        switch SdpType(rawValue: sessionDescription.type) {
        case .offer:
            callback(.didRequestLocalSDP(sdp))
        case .candidate:
            guard let candidate = sdp.candidateModel else { return }

            callback(.didReceiveCandidate(candidate))
        case .answer:
            callback(.didReceiveRemoteSDP(sessionDescription))
        case .close:
            callback(.close)
        default:
            break
        }
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

    private func sendLocalCandidates() {

    }

    private func toString<T: Codable>(model: T?) -> String? {
        guard let model, let encoded = try? encoder.encode(model) else { return nil }

        return String(data: encoded, encoding: .utf8)
    }
}

// MARK: - WebRTCClientDelegate

extension SignalingClient: WebRTCClientDelegate {

    func webRTCClient(_ client: WebRTCClient, didReceiveCandidate candidate: RTCIceCandidate) {
        guard didReceivedRemoteSDP else {
            cachedLocalCandidates.append(candidate)
            return
        }
        guard let cachedFriend, let cachedRoomID, let cachedCallType else { return }

        sendCandidate(candidate: .init(from: candidate), friend: cachedFriend, roomID: cachedRoomID, callType: cachedCallType)
    }
}
