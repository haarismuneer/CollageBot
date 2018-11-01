//
//  InformationEntryViewController.swift
//  CollageBot
//

import UIKit

class InformationEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        LastfmAPIClient.getTopAlbums(username: "moonear", timeframe: .oneMonth) { (result) in
            switch result {
            case let .success(albums):
                for album in albums {
                    let albumObject = Album(dictionary: album)
                    print(albumObject)
                }
            case let .failure(error):
                print(error)
            }
        }
    }

}
