//
//  UIFont+CollageBot.swift
//  CollageBot
//

import UIKit

enum FontType: String {
    case regular = ""
    case bold = "-Bold"
    case thin = "-Thin"
}

extension UIFont {
    
    class func collageBotFont(_ size: CGFloat, fontType: FontType = .regular) -> UIFont {
        return UIFont(name: "Comfortaa\(fontType.rawValue)", size: size) ?? UIFont()
    }
    
}
