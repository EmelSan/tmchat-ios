//
//  PostData.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import Foundation

struct Pagination<T: Codable>: Codable {
    var count: Int
    var rows: [T]
}

struct PostData: Codable {
    var uuid: String
    var ownerId: String
    var owner: User
    var description: String?
    var publishAt: String?
    var isLikeable: Bool
    var isCommentable: Bool
    var isLiked: Bool
    var likeCount: String
    var viewCount: String
    var files: [File]?
    var createdAt: String?
    var comments: [PostComment]?
}

struct PostComment: Codable {

    var id: Int
    var postId: String
    var commenterId: String?
    var comment: String?
    var commenter: User?
}

struct File: Codable {
    var type: MsgType.RawValue
    var fileUrl: String
    var filename: String
}

struct LikeData: Codable {
    var isLiked: Bool
    var count: String
}

struct AddPostParams: Codable {
    var description: String
    var visibility: PostPermissionType.RawValue
    var publishAt: String
    var isLikeable: Bool
}
