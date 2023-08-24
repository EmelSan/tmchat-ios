//
//  FeedRequests.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import Foundation
import Alamofire

class FeedRequests {
    static let shared = FeedRequests()
    
    func getFeed(params: PaginationParams,
                 completionHandler: @escaping (Response<Pagination<PostData>>?)->()) {
        
        Network.perform(url: ApiPath.POST,
                        params: params,
                        completionHandler: completionHandler)
    }
    
    func getPost(uuid: String,
                 completionHandler: @escaping (Response<PostData>?)->()) {
        
        Network.perform(url: ApiPath.POST+"/\(uuid)",
                        params: Empty(),
                        completionHandler: completionHandler)
    }
    
    func toggleLike(uuid: String,
                    completionHandler: @escaping (Response<PostData>?)->()) {

        Network.perform(url: ApiPath.POST+"/\(uuid)/toggle-like",
                           params: Empty(),
                           completionHandler: completionHandler)
       }
    
    func addPost(params: [String: String],
                 files: [UploadImage],
                 completionHandler: @escaping (Response<Empty>?)->()) {
        
        Network.upload(images: files,
                       fields: params,
                       method: .post,
                       path: ApiPath.ADD_POST,
                       completionHandler: completionHandler)
    }

    func addComment(uuid: String, comment: String, completionHandler:@escaping (Response<[PostComment]>?)->()) {
        Network.perform(url: ApiPath.POST+"/\(uuid)/comment",
                        method: .post,
                        params: ["comment": comment],
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func deletePost(uuid: String,
                 completionHandler: @escaping (Response<Empty>?)->()) {

        Network.perform(url: ApiPath.POST+"/\(uuid)/remove",
                        method: .patch,
                        params: Empty(),
                        completionHandler: completionHandler)
    }
    
    func reportPost(uuid: String, text: String,
                    completionHandler: @escaping (Response<Empty>?)->()) {

        Network.perform(url: ApiPath.REPORT_POST,
                        method: .post,
                        params: ["postId": uuid, "text": text],
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
}
