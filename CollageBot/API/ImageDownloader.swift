//
//  ImageDownloader.swift
//  CollageBot
//

import Foundation
import UIKit

class ImageDownloader {
    
    class func downloadImages(albums: [Album], completion: @escaping ([UIImage]) -> Void) {
        let imageURLs = albums.compactMap { return $0.imageURL }
        var images = [UIImage]()
        
        let imageDownloadGroup = DispatchGroup()
        for url in imageURLs {
            imageDownloadGroup.enter()
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                let image = UIImage(data: data) {
                    images.append(image)
                }
                imageDownloadGroup.leave()
            }.resume()
            
        }
        imageDownloadGroup.notify(queue: .main) {
            completion(images)
        }
    }
    
}
