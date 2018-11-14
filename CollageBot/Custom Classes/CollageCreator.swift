//
//  CollageCreator.swift
//  CollageBot
//

import Foundation
import UIKit

struct CollageOptions: OptionSet {
    let rawValue: Int
    
    static let displayAlbumTitle = CollageOptions(rawValue: 1)
    static let displayArtist = CollageOptions(rawValue: 2)
    static let displayPlayCount = CollageOptions(rawValue: 4)
}

class CollageCreator {
    
    class func createCollage(rows: Int, columns: Int, albums: [Album], options: CollageOptions) -> UIImage? {
        var counter = 0
        let imageHeight = CGFloat(rows * Constants.imageDimension)
        let imageWidth = CGFloat(columns * Constants.imageDimension)
        
        UIGraphicsBeginImageContext(CGSize(width: imageWidth, height: imageHeight))
        
        for row in 0..<rows {
            for column in 0..<columns {
                let album = albums[counter]
                guard let image = albums[counter].image else { continue }
                
                let xPosition = column * Constants.imageDimension
                let yPosition = row * Constants.imageDimension
                let imagePoint = CGPoint(x: xPosition, y: yPosition)
                image.draw(at: imagePoint)
                
                let textConfiguration = getTextDrawingConfiguration(album: album, options: options)
                let stringToDraw = textConfiguration.0
                let textPoint = CGPoint(x: xPosition + 10, y: yPosition + 10)
                
                // TODO: draw in rect instead of at point so that the text truncates/wraps properly
                if stringToDraw != "" {
                    NSString(string: stringToDraw).draw(at: textPoint, withAttributes: textConfiguration.1)
                }
                
                counter += 1
            }
        }
        
        guard let collage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return collage
    }
    
    private class func getTextDrawingConfiguration(album: Album, options: CollageOptions) -> (String, [NSAttributedString.Key: Any]) {
        var stringToDraw = ""
        if options.contains(.displayAlbumTitle), let title = album.title {
            stringToDraw += "\(title)\n"
        }
        if options.contains(.displayArtist), let artist = album.artistName {
            stringToDraw += "\(artist)\n"
        }
        if options.contains(.displayPlayCount), let playCount = album.playCount {
            stringToDraw += "\(playCount)"
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 20) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.yellow,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -3,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        return (stringToDraw, textAttributes)
    }
    
}

