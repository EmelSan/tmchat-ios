//
//  ChatRequests.swift
//  tmchat
//
//  Created by Shirin on 3/28/23.
//

import Foundation
import Alamofire

class ChatRequests {
    
    static let shared = ChatRequests()
    
    func sendContacts(contacts: [Contact],
                      completionHandler: @escaping (Response<Bool>?)->()) {
        
        Network.perform(url: ApiPath.CONTACT,
                        method: .post,
                        params: ["contacts": contacts],
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func getContacts(params: PaginationParams,
                     completionHandler: @escaping (Response<Pagination<User>>?)->()) {
        
        Network.perform(url: ApiPath.CONTACT,
                        params: params,
                        completionHandler: completionHandler)
    }


    func createRoom(userId: String,
                    completionHandler: @escaping (Response<Room>?)->()) {
        
        Network.perform(url: ApiPath.CREATE_ROOM,
                        method: .post,
                        params: ["userId": userId],
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func deleteRoom(roomId: String,
                    completionHandler: @escaping (Response<Bool>?)->()) {
        
        Network.perform(url: ApiPath.GET_ROOMS+"/\(roomId)/remove",
                        method: .patch,
                        params: Empty(),
                        completionHandler: completionHandler)
    }

    func toggleNotification(roomId: String,
                            completionHandler: @escaping (Response<Empty>?)->()) {
        
        Network.perform(url: ApiPath.GET_ROOMS+"/\(roomId)/notification",
                        method: .patch,
                        params: Empty(),
                        completionHandler: completionHandler)
    }

    // FIXME: It's first request on app start, replace logout logic
    func getRooms(completionHandler: @escaping (Response<[Room]>?)->()) {
        Network.perform(url: ApiPath.GET_ROOMS,
                        params: Empty()) { [weak self] (response: Response<[Room]>?) in
            completionHandler(response)

            if response?.code == 401 {
                (UIApplication.shared.delegate as? AppDelegate)?.logout()
            }
        }
    }
    
    func uploadMedia(file: UploadImage,
                     type: MsgType.RawValue,
                     roomId: String,
                     msgId: String,
                     completionHandler: @escaping (Response<Empty>?)->()){
        Network.upload(images: [file],
                       fields: ["type": type,
                                "roomId": roomId,
                                "localId": msgId,
                                "duration": "\(file.duration ?? 0)",
                                "filesize": "\(file.fileSize ?? 0)"],
                       path: ApiPath.UPLOAD_MEDIA,
                       completionHandler: completionHandler)
    }
}

