//
//  UploadImage.swift
//  tmchat
//
//  Created by Shirin on 3/8/23.
//

import UIKit.UIImage

struct UploadImage {
    var type: MsgType.RawValue?
    var uploadName: String
    var filename: String?
    var duration: Int64?
    var fileSize: Int64?
    var data: Data?
    var localPath: String?
    var localId: String?
}
