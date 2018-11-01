//
//  Album.swift
//  CollageBot
//

import Foundation

struct Album {
    
    var title: String!
    var artistName: String!
    var playCount: String!
    var imageURL: URL!
    
    init(dictionary: [String: Any]) {
        title = dictionary["name"] as? String
        artistName = dictionary["name"] as? String
        playCount = dictionary["name"] as? String
        imageURL = URL(string: dictionary["name"] as? String ?? "") // replace with default image link
    }
    
}

