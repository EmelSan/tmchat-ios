//
//  .swift
//  Meninki
//
//  Created by NyanDeveloper on 07.12.2022.
//

import UIKit.UIColor

extension UIColor {
    static let accent = UIColor(red: 0, green: 0.451, blue: 1, alpha: 1)
    static let alert = UIColor(red: 1, green: 0, blue: 0.359, alpha: 1)
    static let warning = UIColor(red: 0.846, green: 0.675, blue: 0.095, alpha: 1)

    static let bapAccent = UIColor(red: 0.554, green: 0.643, blue: 0.821, alpha: 1)
    static let ownMsgBg = UIColor(red: 0.78, green: 0.902, blue: 1, alpha: 1)
    static let otherMsgBg = UIColor(red: 1, green: 1, blue: 1, alpha: 1)


    static let blade = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
    static let bladeContrast = UIColor(red: 0.358, green: 0.358, blue: 0.358, alpha: 1)
    static let lee = UIColor(red: 0.647, green: 0.647, blue: 0.647, alpha: 1)
    static let bg = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
    static let onBg = UIColor(red: 0.906, green: 0.928, blue: 0.954, alpha: 1)
    
    
    
    // trailing swipe
    static let muteColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
    static let unmuteColor = UIColor(red: 0.961, green: 0.941, blue: 0.867, alpha: 1)
    static let deleteColor = UIColor(red: 0.969, green: 0.867, blue: 0.906, alpha: 1)
    static let readColor = UIColor(red: 0.867, green: 0.914, blue: 0.969, alpha: 1)
}


extension UIColor {
    convenience init?(hexString: String?) {
        if hexString == "" || hexString?.starts(with: "#") == false || (hexString?.count == 7) == false {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        let input: String! = (hexString ?? "").replacingOccurrences(of: "#", with: "").uppercased()
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
            
        red = Self.colorComponent(from: input, start: 0, length: 2)
        green = Self.colorComponent(from: input, start: 2, length: 2)
        blue = Self.colorComponent(from: input, start: 4, length: 2)

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func colorComponent(from string: String!, start: Int, length: Int) -> CGFloat {
        let substring = (string as NSString)
            .substring(with: NSRange(location: start, length: length))
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent: UInt64 = 0
        Scanner(string: fullHex)
            .scanHexInt64(&hexComponent)
        return CGFloat(Double(hexComponent) / 255.0)
    }
}
