//
//  SDP.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import Foundation
import WebRTC

struct SDPData: Codable {

    var type: String? = ""
    var candidate: IceCandidate? = nil
    var sessionDescription: SessionDescription? = nil
    var friend: String? = ""
    var roomId: String? = ""
    var call_type: String? = ""
    var sdp_data: String? = ""

    var friendModel: User? {
        guard let friend = friend?.data(using: .utf8) else { return nil }

        return try? JSONDecoder().decode(User.self, from: friend)
    }
}

struct IceCandidate: Codable {

    let sdp: String
    let sdpMLineIndex: Int32
    let sdpMid: String?

    init(from iceCandidate: RTCIceCandidate) {
        self.sdpMLineIndex = iceCandidate.sdpMLineIndex
        self.sdpMid = iceCandidate.sdpMid
        self.sdp = iceCandidate.sdp
    }

    var rtcIceCandidate: RTCIceCandidate {
        return RTCIceCandidate(sdp: self.sdp, sdpMLineIndex: self.sdpMLineIndex, sdpMid: self.sdpMid)
    }
}

enum SdpType: String, Codable {
    case offer, prAnswer, answer, close, candidate

    var rtcSdpType: RTCSdpType? {
        switch self {
        case .offer: return .offer
        case .answer: return .answer
        case .prAnswer: return .prAnswer
        case .close, .candidate: return nil
        }
    }
}

struct SessionDescription: Codable {

    var sdp: String
    var type: String

    var rtcSessionDescription: RTCSessionDescription? {
        guard let type = SdpType(rawValue: type)?.rtcSdpType else { return nil }

        return RTCSessionDescription(type: type, sdp: sdp)
    }

    init(sdp: String, type: SdpType) {
        self.sdp = sdp
        self.type = type.rawValue
    }
}

struct DataSDP: Codable {

    var sdp_data: SDPData?
}
