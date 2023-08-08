//
//  FeedParams.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import Foundation

struct PaginationParams: Codable {
    var page: Int
    var limit: Int = 10
    var ownerId: String? = nil
    var id: String? = nil
}
