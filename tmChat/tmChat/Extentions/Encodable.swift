//
//  Encodable.swift
//  Guncha
//
//  Created by Shirin on 2/19/23.
//

import Foundation

extension Encodable {
    var dictionary: [String: String?]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    .flatMap { $0 as! [String: String] }
    }
}
