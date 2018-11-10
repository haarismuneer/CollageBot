//
//  InformationEntryViewController.swift
//  CollageBot
//

import UIKit

class InformationEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var topAlbums = [Album]()
        LastfmAPIClient.getTopAlbums(username: "moonear", timeframe: .oneMonth, limit: 9) { (result) in
            switch result {
            case let .success(albums):
                for album in albums {
                    topAlbums.append(Album(dictionary: album))
                }
                ImageDownloader.downloadImages(albums: topAlbums, completion: { (images) in
                    
                    let image = CollageCreator.createCollage(rows: 3, columns: 3, images: images)
                    let collageVC = CollageDisplayViewController()
                    collageVC.collageImage = image
                    self.present(collageVC, animated: true, completion: nil)
                    
                })
            case let .failure(error):
                print(error)
            }
        }
    }

}
