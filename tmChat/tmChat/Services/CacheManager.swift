//
//  CacheManager.swift
//  tmchat
//
//  Created by Shirin on 4/29/23.
//

import Foundation

class CacheManager {
    
    class func sizeOfAllCache() -> String {
        guard let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return "cachePath" }
        guard let fileArr = FileManager.default.subpaths(atPath: cachePath.path) else { return "fileArr" }
        var size: Double = 0
        for file in fileArr {
            let path = (cachePath.path).appending("/\(file)")
            guard let floder = try? FileManager.default.attributesOfItem(atPath: path) else { return "floder" }
            for (abc, bcd) in floder {
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).doubleValue
                }
            }
        }

        if size == 0 {
            return "0 KB"
        }
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .memory)
    }

    class func clearAllCache() {
        guard let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        guard let fileArr = FileManager.default.subpaths(atPath: cachePath.path) else { return }
        for file in fileArr {
            let path = (cachePath.path).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    debugPrint("Could not delete file: ", error)
                }
            }
        }
    }
}
