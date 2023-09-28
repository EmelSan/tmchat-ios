//
//  WebRTCClient.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import Foundation
import WebRTC

protocol WebRTCClientDelegate: AnyObject {
    func webRTCClient(_ client: WebRTCClient, didReceiveCandidate candidate: RTCIceCandidate)
}

final class WebRTCClient: NSObject {

    weak var delegate: WebRTCClientDelegate?

    private static let factory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()

    private var peerConnection: RTCPeerConnection?
    private let rtcAudioSession =  RTCAudioSession.sharedInstance()
    private let audioQueue = DispatchQueue(label: "audio")
    private let mediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
                                   kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue]
    private let optionalConstraints = ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue]
    private var videoCapturer: RTCVideoCapturer?
    private var localVideoTrack: RTCVideoTrack?
    private var remoteVideoTrack: RTCVideoTrack?
    private var localDataChannel: RTCDataChannel?

    private let stunServers: [RTCIceServer] = [
        .init(urlStrings: ["stun:stun.ekiga.net"]),
        .init(urlStrings: ["stun:stunserver.org"]),
        .init(urlStrings: ["stun:stun.softjoys.com"]),
        .init(urlStrings: ["stun:stun.voipbuster.com"]),
        .init(urlStrings: ["stun:stun.voiparound.com"]),
        .init(urlStrings: ["stun:stun.voxgratia.org"])
    ]

    private let turnServers: [RTCIceServer] = [
        .init(urlStrings: ["turn:a.relay.metered.ca:80"], username: "f61fc481186fdb94ac76134f", credential: "51jtJSxhPtH2HLKD"),
        .init(urlStrings: ["turn:a.relay.metered.ca:80?transport=tcp"], username: "f61fc481186fdb94ac76134f", credential: "51jtJSxhPtH2HLKD"),
        .init(urlStrings: ["turn:a.relay.metered.ca:443"], username: "f61fc481186fdb94ac76134f", credential: "51jtJSxhPtH2HLKD"),
        .init(urlStrings: ["turn:a.relay.metered.ca:443?transport=tcp"], username: "f61fc481186fdb94ac76134f", credential: "51jtJSxhPtH2HLKD")
    ]

    private static let localAudioTrackID = "audio_track"
    private static let localVideoTrackID = "video_track"
    private static let localStreamID = "local_track"

    // MARK: - Connection

    func setup() {
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: optionalConstraints)
        let config = RTCConfiguration()
        config.iceServers = turnServers + stunServers
        config.sdpSemantics = .unifiedPlan
        config.continualGatheringPolicy = .gatherContinually

        peerConnection = Self.factory.peerConnection(with: config, constraints: constraints, delegate: self)

        createMediaSenders()
        configureAudioSession()
    }

    func answer(completion: Closure<RTCSessionDescription>? = nil)  {
        let constrains = RTCMediaConstraints(mandatoryConstraints: mediaConstrains, optionalConstraints: optionalConstraints)

        peerConnection?.answer(for: constrains) { [weak self] (sdp, error) in
            guard let sdp else { return }

            self?.setLocalSDP(sdp) {
                completion?(sdp)
            }
        }
    }

    func offer(completion: Closure<RTCSessionDescription>? = nil) {
        let constrains = RTCMediaConstraints(mandatoryConstraints: mediaConstrains, optionalConstraints: optionalConstraints)

        peerConnection?.offer(for: constrains) { [weak self] (sdp, error) in
            guard let sdp else { return }

            self?.setLocalSDP(sdp) {
                completion?(sdp)
            }
        }
    }

    func set(remoteSdp: SessionDescription) {
        guard let peerConnection, let rtcSessionDescription = remoteSdp.rtcSessionDescription else { return }

        peerConnection.setRemoteDescription(rtcSessionDescription) { _ in }
    }

    func set(remoteCandidate: IceCandidate) {
        peerConnection?.add(remoteCandidate.rtcIceCandidate)
    }

    func renderRemoteVideo(to renderer: RTCVideoRenderer) {
        remoteVideoTrack?.add(renderer)
    }

    func startCaptureLocalVideo(renderer: RTCVideoRenderer) {
        guard let capturer = videoCapturer as? RTCCameraVideoCapturer else { return }

        guard
            let frontCamera = (RTCCameraVideoCapturer.captureDevices().first { $0.position == .front }),
            let format = (RTCCameraVideoCapturer.supportedFormats(for: frontCamera).sorted { (f1, f2) -> Bool in
                let width1 = CMVideoFormatDescriptionGetDimensions(f1.formatDescription).width
                let width2 = CMVideoFormatDescriptionGetDimensions(f2.formatDescription).width
                return width1 < width2
            }).last,
            let fps = (format.videoSupportedFrameRateRanges.sorted { return $0.maxFrameRate < $1.maxFrameRate }.last) else {
            return
        }
        capturer.stopCapture()
        capturer.startCapture(with: frontCamera,
                              format: format,
                              fps: Int(fps.maxFrameRate))

        localVideoTrack?.add(renderer)
        setVideoEnabled(true)
    }

    func stopCaptureLocalVideo() {
        guard let capturer = videoCapturer as? RTCCameraVideoCapturer else { return }

        capturer.stopCapture()
        setVideoEnabled(false)
    }

    // MARK: - Actions

    func disconnect() {
        peerConnection?.close()

        peerConnection = nil
        localVideoTrack = nil
        videoCapturer = nil
        remoteVideoTrack = nil

        audioSessionToDefaults()
    }

    func setAudioEnabled(_ isEnabled: Bool) {
        setTrackEnabled(RTCAudioTrack.self, isEnabled: isEnabled)
    }

    func speakerOff() {
        audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }

            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.none)
            } catch {
                debugPrint("Error setting AVAudioSession category: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }

    func speakerOn() {
        audioQueue.async { [weak self] in
            guard let self else { return }

            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.speaker)
                try self.rtcAudioSession.setActive(true)
            } catch {
                debugPrint("Couldn't force audio to speaker: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }

    // MARK: - Private Methods

    private func setVideoEnabled(_ isEnabled: Bool) {
        setTrackEnabled(RTCVideoTrack.self, isEnabled: isEnabled)
    }

    private func setLocalSDP(_ sdp: RTCSessionDescription, completion: VoidClosure? = nil) {
        peerConnection?.setLocalDescription(sdp, completionHandler: { (error) in
            if let error = error {
                debugPrint(error)
            }
            completion?()
        })
    }

    private func setTrackEnabled<T: RTCMediaStreamTrack>(_ type: T.Type, isEnabled: Bool) {
        peerConnection?.transceivers.compactMap { $0.sender.track as? T }.forEach { $0.isEnabled = isEnabled }
    }

    private func configureAudioSession() {
        audioQueue.async { [weak self] in
            guard let self else { return }

            self.rtcAudioSession.lockForConfiguration()

            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
                try self.rtcAudioSession.setMode(AVAudioSession.Mode.voiceChat.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.speaker)
                try self.rtcAudioSession.setActive(true)
            } catch {
                debugPrint("Error changeing AVAudioSession category: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }

    func audioSessionToDefaults() {
        audioQueue.async { [weak self] in
            guard let self else { return }

            self.rtcAudioSession.lockForConfiguration()

            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.ambient.rawValue)
                try self.rtcAudioSession.setMode(AVAudioSession.Mode.default.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.none)
                try self.rtcAudioSession.setActive(false)
            } catch let error {
                debugPrint("Error changeing AVAudioSession with defaults: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }

    private func createMediaSenders() {
        // Audio
        let audioTrack = createAudioTrack()
        peerConnection?.add(audioTrack, streamIds: [Self.localStreamID])

        // Video
        let videoTrack = createVideoTrack()
        localVideoTrack = videoTrack
        peerConnection?.add(videoTrack, streamIds: [Self.localStreamID])
        remoteVideoTrack = peerConnection?.transceivers.first { $0.mediaType == .video }?.receiver.track as? RTCVideoTrack

        // Data
        if let dataChannel = createDataChannel() {
            dataChannel.delegate = self
            localDataChannel = dataChannel
        }
    }

    private func createAudioTrack() -> RTCAudioTrack {
        let audioConstrains = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let audioSource = Self.factory.audioSource(with: audioConstrains)
        let audioTrack = Self.factory.audioTrack(with: audioSource, trackId: Self.localAudioTrackID)

        return audioTrack
    }

    private func createVideoTrack() -> RTCVideoTrack {
        let videoSource = Self.factory.videoSource()

        #if targetEnvironment(simulator)
        videoCapturer = RTCFileVideoCapturer(delegate: videoSource)
        #else
        videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        #endif

        let videoTrack = WebRTCClient.factory.videoTrack(with: videoSource, trackId: Self.localVideoTrackID)

        return videoTrack
    }

    private func createDataChannel() -> RTCDataChannel? {
        let config = RTCDataChannelConfiguration()

        guard let dataChannel = peerConnection?.dataChannel(forLabel: "WebRTCData", configuration: config) else {
            debugPrint("Warning: Couldn't create data channel.")
            return nil
        }
        return dataChannel
    }
}

// MARK: - RTCPeerConnectionDelegate

extension WebRTCClient: RTCPeerConnectionDelegate {

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        debugPrint("peerConnection new signaling state: \(stateChanged)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        debugPrint("peerConnection did add stream")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        debugPrint("peerConnection did remove stream")
    }

    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        debugPrint("peerConnection should negotiate")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        debugPrint("peerConnection new connection state: \(newState)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        debugPrint("peerConnection new gathering state: \(newState)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        delegate?.webRTCClient(self, didReceiveCandidate: candidate)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        debugPrint("peerConnection did remove candidate(s)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        debugPrint("peerConnection did open data channel")
    }
}

extension WebRTCClient: RTCDataChannelDelegate {

    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        debugPrint("dataChannel did change state: \(dataChannel.readyState)")
    }

    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        debugPrint("dataChannel did receive message: \(buffer.description)")
    }
}
