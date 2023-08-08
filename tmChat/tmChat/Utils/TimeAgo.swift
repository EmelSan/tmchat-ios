//
//  TimeAgo.swift
//  tmchat
//
//  Created by Shirin on 3/30/23.
//

import Foundation

class TimeAgo {
    
    static let shared = TimeAgo()

    /// For last mesaage date in Chatlist
    func getTimeOrDayOrDate(_ date: Date?) -> String {
        guard let date = date else { return ""}

        let calendar = Calendar.current
        let now = Date()
        
        let unitFlags: NSCalendar.Unit = [.minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])

        let df = DateFormatter()
        
        if let day = components.day, day > 6 {
            df.dateFormat = "dd.MM.yy"
            return df.string(from: date)
        }
        
        if let day = components.day, day > 1 {
            df.dateFormat = "EEE"
            return df.string(from: date)
        }
        
        if let day = components.day, day == 1 {
            return "yesterday".localized()
        }
        
        df.dateFormat = "HH:mm"
        return df.string(from: date)
    }
    
    func getTimeOrDay(_ date: Date?) -> String {
        guard let date = date else { return ""}

        let calendar = Calendar.current
        let now = Date()
        
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])

        let df = DateFormatter()
        
        if let day = components.day, day > 6 {
            df.dateFormat = "dd.MM.yy"
            return df.string(from: date)
        }
        
        if let day = components.day, day > 1 {
            df.dateFormat = "EEE"
            return df.string(from: date)
        }
        
        if let day = components.day, day == 1 {
            return "yesterday".localized()
        }
        
        return "today".localized()
    }

    /// For last active date of room
    func getAgo(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let calendar = Calendar.current
        let now = Date()
        
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])

        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        if days >= 1 {
            return getTimeAndDate(date)
            
        } else if hours > 0 {
            // hours ago
            if hours == 1 {
                return "hour_ago".localized()
                
            } else if (hours > 1 && hours < 5) || (hours > 21 && hours < 25) {
                return "\(hours)" + "2_4_hours_ago".localized()
                
            } else {
                return "\(hours)" + "hours_ago".localized()
            }
            
            
        } else if minutes > 0 {

            if minutes == 1 {
                return "minute_ago".localized()

            } else if (minutes > 1 && minutes < 5)
                        || (minutes > 21 && minutes < 25)
                        || (minutes > 31 && minutes < 35)
                        || (minutes > 41 && minutes < 45)
                        || (minutes > 51 && minutes < 55){
                
                return "\(minutes)" + "2_4_minutes_ago".localized()

            } else {
                return "\(minutes)" + "minutes_ago".localized()

            }

        } else {
            return "just_now".localized()
            
        }
    }

    /// for date headers inside messaging
    func getDayOrDate(_ date: Date?) -> String {
        guard let date = date else { return ""}
        
        let nowDays = Date().days(sinceDate: Date(milliseconds: 1)) ?? 0
        let headerDays = date.days(sinceDate: Date(milliseconds: 1)) ?? 0

        let day = nowDays - headerDays

        if day > 1 {
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yyyy"
            return df.string(from: date)
        }
        
        if day > 0 {
            return "yesterday".localized()
        }
        
        return "today".localized()
    }

    
    func getTimeAndDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let df = DateFormatter()
        df.dateFormat = "HH:mm | dd.MM.yyyy"
        return df.string(from: date)
    }
    
    
    func getTime(_ date: Date?) -> String {
        guard let date = date else { return "error" }
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: date)
    }    
}
