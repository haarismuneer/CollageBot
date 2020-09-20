//
//  Album.swift
//  CollageBot
//

import Foundation
import UIKit

class MediaItem {
    
    var albumTitle: String?
    var trackTitle: String?
    var artistName: String?
    var playCount: String?
    var imageURL: URL?
    var image: UIImage?
    
    init(albumDictionary: [String: Any]) {
        albumTitle = (albumDictionary["name"] as? String)
        artistName = getArtistName(albumDictionary["artist"] as? [String: Any])
        playCount = albumDictionary["playcount"] as? String
        imageURL = URL(string: getImageURL(albumDictionary["image"] as? [[String: String]]))
    }
    
    private func getArtistName(_ dict: [String: Any]?) -> String {
        return dict?["name"] as? String ?? ""
    }
    
    private func getImageURL(_ images: [[String: String]]?) -> String {
        let largestImageDictionary = images?.filter { return $0["size"] == "extralarge" }.first
        return largestImageDictionary?["#text"] ?? ""
    }
    
}

