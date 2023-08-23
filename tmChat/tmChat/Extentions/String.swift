//
//  String.swift
//  Meninki
//
//  Created by NyanDeveloper on 25.12.2022.
//

import Foundation
import UIKit

extension String {
    
    func isValidNumber() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^6[0-9]{7}$", options: .caseInsensitive)
            
            if regex.matches(in: self,
                             options: [],
                             range: NSRange(location: 0, length: self.count)).count > 0 {
                return true
            }
            
        } catch {}
        
        return false
    }
    
    func isValidUsername() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "\\A\\w{6,30}\\z", options: .caseInsensitive)
            
            if regex.matches(in: self,
                             options: [],
                             range: NSRange(location: 0, length: self.count)).count > 0 {
                return true
            }
            
        } catch {}
        
        return false
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_us_posix")
        let date = dateFormatter.date(from: self)
        return date
    }

    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude,
                                    height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)

        return ceil(boundingBox.width)
    }
}
