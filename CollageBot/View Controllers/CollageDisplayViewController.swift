//
//  CollageDisplayViewController.swift
//  CollageBot
//

import UIKit
import SnapKit

class CollageDisplayViewController: UIViewController {
    
    var collageImage: UIImage!
    lazy var collageImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        view.addSubview(collageImageView)
        collageImageView.snp.makeConstraints { (make) in
            make.center.width.equalTo(self.view)
            make.height.equalTo(collageImageView.snp.width)
        }
        
        collageImageView.image = collageImage
    }

}
