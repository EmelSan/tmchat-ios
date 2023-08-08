//
//  .swift
//  Meninki
//
//  Created by NyanDeveloper on 07.12.2022.
//

import UIKit.UIFont

extension UIFont {
    class func thin(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoFlex-Regular_Thin", size: size)
    }
    
    class func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoFlex-Regular", size: size)
    }
    
    class func medium(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoFlex-Regular_Medium", size: size)
    }
    
    class func semibold(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoFlex-Regular_SemiBold", size: size)
    }
    
    class func bold(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoFlex-Regular_Bold", size: size)
    }
    
    
    static var header_24 = UIFont.bold(size: 24)
    
    static var metadata_12 = UIFont.semibold(size: 12)

    static var sb_16_m = UIFont.medium(size: 16)
    
    static var sb_16_r = UIFont.regular(size: 16)

    static var text_14_m = UIFont.medium(size: 14)
    
    static var text_14_r = UIFont.regular(size: 14)

    static var minitext_12 = UIFont.regular(size: 12)

    static var comments_10 = UIFont.regular(size: 10)
}
