//
//  ImageDownloader.swift
//  CollageBot
//

import Foundation
import UIKit

class ImageDownloader {
    
    class func downloadImages(albums: [Album], completion: @escaping () -> Void) {
        let imageDownloadGroup = DispatchGroup()
        for i in 0..<albums.count {
            var album = albums[i]
            if let url = album.imageURL {
            imageDownloadGroup.enter()
                downloadImageFromURL(url) { (image) in
                    album.image = image
                    imageDownloadGroup.leave()
                }
            }
        }
        imageDownloadGroup.notify(queue: .main) {
            completion()
        }
    }
    
    class func downloadImageFromURL(_ url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
            let image = UIImage(data: data) {
                completion(image)
            }
        }.resume()
    }
    
}
