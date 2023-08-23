//
//  Dictionary.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import Foundation

extension Dictionary {

    var jsonData: Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else { return nil }

        return data
    }
}
