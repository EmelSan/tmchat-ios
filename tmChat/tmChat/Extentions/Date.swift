//
//  Date.swift
//  Guncha
//
//  Created by Shirin on 3/1/23.
//

import Foundation

extension Date {
    
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }

    func getTimeStamp() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"
        df.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
        df.locale = Locale(identifier: "en_us_posix")
        let stringDate = df.string(from: self)
        return stringDate
    }

    func getTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        df.timeZone = TimeZone.current

        return df.string(from: self)
    }
}
