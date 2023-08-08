//
//  Helpers.swift
//  tmchat
//
//  Created by Shirin on 3/30/23.
//

import Foundation

class Helpers {

    static func getInitials(name: String) -> String {
        let avatarCharacter = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let segments = avatarCharacter.components(separatedBy: " ")
        
        var shortName: String = "-"
        
        if segments.count > 1 {
            shortName = avatarCharacter.first?.uppercased() ?? "-"
        } else {
            shortName = avatarCharacter.first?.uppercased() ?? "-"
        }
        
        return shortName
    }
}
