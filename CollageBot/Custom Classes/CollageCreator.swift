//
//  CollageCreator.swift
//  CollageBot
//

import Foundation
import UIKit

class CollageCreator {
    
    class func createCollage(rows: Int, columns: Int, images: [UIImage]) -> UIImage? {
        var counter = 0
        let imageHeight = CGFloat(rows * Constants.imageDimension)
        let imageWidth = CGFloat(columns * Constants.imageDimension)
        
        UIGraphicsBeginImageContext(CGSize(width: imageWidth, height: imageHeight))
        
        for row in 0..<rows {
            for column in 0..<columns {
                let image = images[counter]
                let xPosition = column * Constants.imageDimension
                let yPosition = row * Constants.imageDimension
                image.draw(at: CGPoint(x: xPosition, y: yPosition))
                counter += 1
            }
        }
        
        guard let collage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return collage
    }
    
}

