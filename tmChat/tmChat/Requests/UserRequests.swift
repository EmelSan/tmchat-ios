//
//  UserRequests.swift
//  tmchat
//
//  Created by Shirin on 3/22/23.
//

import Foundation
import Alamofire

class UserRequests {
    
    static let shared = UserRequests()
    
    func sendOtp(phone: String,
                 completionHandler: @escaping (Response<SendOtpResponse>?)->() ) {
        
        Network.perform(url: ApiPath.SEND_OTP,
                        method: .post,
                        params: ["phone": phone],
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func checkOtp(code: String,
                  completionHandler: @escaping (Response<CheckOtpResponse>?)->() ) {
        
        Network.perform(url: ApiPath.CHECK_OTP,
                        method: .post,
                        params: CheckOtpParams(code: Int(code) ?? 0),
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }

    func updateUser(params: UpdateUserParams,
                    completionHandler: @escaping (Response<User>?)->() ) {
        
        Network.perform(url: ApiPath.USER,
                        method: .patch,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func updateProfileImg(params: UploadImage?,
                          completionHandler: @escaping (Response<String>?)->() ) {
        
        Network.upload(images: [params],
                       fields: [:],
                       method: .patch,
                       path: ApiPath.UPDATE_PROFILE_IMG,
                       completionHandler: completionHandler)
    }
    

    func getUser(id: String,
                 completionHandler: @escaping (Response<User>?)->() ){
        Network.perform(url: ApiPath.USER_PROFILE+id+"/profile",
                        params: Empty(),
                        completionHandler: completionHandler)

    }
    
    func deleteUser(completionHandler: @escaping (Response<Bool>?)->() ){
        Network.perform(url: ApiPath.USER_DELETE,
                        method: .patch,
                        params: Empty(),
                        completionHandler: completionHandler)

    }

    
    func searchUser(searchKey: String,
                    completionHandler: @escaping (Response<[User]>?)->() ) {
        
        Network.perform(url: ApiPath.SEARCH_USER,
                        params: ["searchText": searchKey],
                        completionHandler: completionHandler)
    }
}
