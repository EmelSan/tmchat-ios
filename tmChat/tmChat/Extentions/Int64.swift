//
//  Int64.swift
//  tmchat
//
//  Created by Shirin on 4/11/23.
//

import Foundation

extension Int64 {
    func getMinSec() -> String {
        let secs = self % 60
        let mins = self / 60

        return String(format: "%02i:%02i", arguments: [mins, secs])
    }
    
    func getHourMinSec() -> String {
        let hours = self / 3600
        let minutes = self / 60
        let seconds = self % 60
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}
