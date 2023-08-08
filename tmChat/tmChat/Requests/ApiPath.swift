//
//  ApiPath.swift
//  tmchat
//
//  Created by Shirin on 3/22/23.
//

import Foundation

class ApiPath {
    
    static let BASE_URL = "https://kpro.tmcell.tm/"
    static let SOCKET_URL = "wss://kpro.tmcell.tm/websocket/?token=\(AccUserDefaults.token)"
    
//    static let BASE_URL = "http://192.168.88.161:8000/"
//    static let SOCKET_URL = "ws://192.168.88.161:8080/?token=\(AccUserDefaults.token)"

    static let SEND_OTP = BASE_URL + "auth/login/by-phone"
    static let CHECK_OTP = BASE_URL + "auth/verify-phone"
    static let USER = BASE_URL + "user/profile"
    static let SEARCH_USER = BASE_URL + "user/search"
    
    static let USER_PROFILE = BASE_URL + "user/"
    static let USER_DELETE = BASE_URL + "user/profile/remove"
    static let UPDATE_PROFILE_IMG = BASE_URL + "user/profile/avatar"

    
    static let CONTACT = BASE_URL + "user-contacts"

    
    static let CREATE_ROOM = BASE_URL + "chat/request"
    static let GET_ROOMS = BASE_URL + "room"
    static let UPLOAD_MEDIA = BASE_URL + "media/message"
    
    static let POST = BASE_URL + "post"
    static let REPORT_POST = BASE_URL + "post/report"
    static let ADD_POST = BASE_URL + "post/with-files"
    
    static func url(_ path: String) -> URL {
        return URL(string: BASE_URL+path)!
    }
}
