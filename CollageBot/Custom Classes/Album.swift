//
//  Album.swift
//  CollageBot
//

import Foundation

struct Album {
    
    var title: String?
    var artistName: String?
    var playCount: String?
    var imageURL: URL?
    
    init(dictionary: [String: Any]) {
        title = dictionary["name"] as? String
        artistName = getArtistName(dictionary["artist"] as? [String: Any])
        playCount = dictionary["playcount"] as? String
        imageURL = URL(string: getImageURL(dictionary["image"] as? [[String: String]])) // replace with default image link
    }
    
    private func getArtistName(_ dict: [String: Any]?) -> String {
        return dict?["name"] as? String ?? ""
    }
    
    private func getImageURL(_ images: [[String: String]]?) -> String {
        let largestImageDictionary = images?.filter { return $0["size"] == "extralarge" }.first
        return largestImageDictionary?["#text"] ?? ""
    }
    
}

