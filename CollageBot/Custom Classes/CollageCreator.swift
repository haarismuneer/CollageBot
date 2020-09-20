//
//  CollageCreator.swift
//  CollageBot
//

import Foundation
import UIKit

struct CollageTextOptions: OptionSet {
    let rawValue: Int
    
    static let displayAlbumTitle = CollageTextOptions(rawValue: 1)
    static let displayArtist = CollageTextOptions(rawValue: 2)
    static let displayPlayCount = CollageTextOptions(rawValue: 4)
}

class CollageCreator {
    
    var username: String?
    var timeframe: Timeframe?
    var contentType: ContentType?
    
    func createCollage(rows: Int, columns: Int, albums: [Album], options: CollageTextOptions) throws -> UIImage {
        var counter = 0
        let imageHeight = CGFloat(rows * Constants.imageDimension)
        let imageWidth = CGFloat(columns * Constants.imageDimension)
        
        UIGraphicsBeginImageContext(CGSize(width: imageWidth, height: imageHeight))
        
        for row in 0..<rows {
            for column in 0..<columns {
                let album = albums[counter]
                guard let image = albums[counter].image else { continue }
                
                let xPosition = CGFloat(column * Constants.imageDimension)
                let yPosition = CGFloat(row * Constants.imageDimension)
                let imagePoint = CGPoint(x: xPosition, y: yPosition)
                image.draw(at: imagePoint)
                
                let textConfiguration = getTextAndDrawingConfiguration(album: album, options: options)
                let stringToDraw = textConfiguration.0
                let textRect = CGRect(x: xPosition + 10.0, y: yPosition + 10, width: 280, height: 280)
                
                // TODO: draw in rect instead of at point so that the text truncates/wraps properly
                if stringToDraw != "" {
                    NSString(string: stringToDraw).draw(in: textRect, withAttributes: textConfiguration.1)
                }
                
                counter += 1
            }
        }
        
        guard let collage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw NSError()
        }
        UIGraphicsEndImageContext()
        return collage
    }
    
    private func getTextAndDrawingConfiguration(album: Album, options: CollageTextOptions) -> (String, [NSAttributedString.Key: Any]) {
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
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 20) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.yellow,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -4,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.kern: 1.35
        ]
        
        return (stringToDraw, textAttributes)
    }
    
}

