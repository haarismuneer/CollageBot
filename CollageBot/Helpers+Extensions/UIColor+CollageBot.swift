//
//  UIColor+CollageBot.swift
//  CollageBot
//

import UIKit

extension UIColor {
    static var collageBotOrange: UIColor {
        return UIColor(red: 243, green: 134, blue: 48, alpha: 1.0)
    }
    
    static var collageBotTeal: UIColor {
        return UIColor(red: 167, green: 219, blue: 216, alpha: 1.0)
    }
    
    static var collageBotBlue: UIColor {
        return UIColor(red: 105, green: 210, blue: 231, alpha: 1.0)
    }
    
    static var collageBotOffWhite: UIColor {
        return UIColor(red: 270, green: 278, blue: 240, alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
}
