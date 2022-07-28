//
//  ImageDownloader.swift
//  CollageBot
//

import Foundation
import UIKit

class ImageDownloader {
    class func downloadImages(albums: [MediaItem], completion: @escaping () -> Void) {
        let imageDownloadGroup = DispatchGroup()
        for i in 0 ..< albums.count {
            let album = albums[i]
            imageDownloadGroup.enter()
            if let url = album.imageURL {
                downloadImageFromURL(url) { image in
                    album.image = image
                    imageDownloadGroup.leave()
                }
            } else {
                album.image = UIImage(named: "default_album_art")
                imageDownloadGroup.leave()
            }
        }
        imageDownloadGroup.notify(queue: .main) {
            completion()
        }
    }

    class func downloadImageFromURL(_ url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let image = UIImage(data: data)
            {
                completion(image)
            } else if let defaultImage = UIImage(named: "default_album_art") {
                completion(defaultImage)
            }
        }.resume()
    }
}
