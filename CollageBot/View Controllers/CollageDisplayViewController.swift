//
//  CollageDisplayViewController.swift
//  CollageBot
//

import UIKit
import SnapKit

class CollageDisplayViewController: UIViewController {
    
    var collageImage: UIImage!
    lazy var dismissButton = UIButton(type: .system)
    lazy var collageImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        let collageWidth = collageImage.size.width
        let collageHeight = collageImage.size.height
        
        func setConstraintsBasedOnWidth() {
            collageImageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(collageImageView.snp.width).multipliedBy(collageHeight/collageWidth)
            }
        }
        
        func setConstraintsBasedOnHeight() {
            collageImageView.snp.makeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.55)
                make.width.equalTo(collageImageView.snp.height).multipliedBy(collageWidth/collageHeight)
            }
        }
        
        view.backgroundColor = .collageBotOffWhite
        
        dismissButton.setTitle("❌", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(collageImageView)
        
        collageImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dismissButton.snp.bottom).offset(20)
        }
        
        collageWidth >= collageHeight ? setConstraintsBasedOnWidth() : setConstraintsBasedOnHeight()
        
        collageImageView.image = collageImage
        collageImageView.contentMode = .scaleAspectFit
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
