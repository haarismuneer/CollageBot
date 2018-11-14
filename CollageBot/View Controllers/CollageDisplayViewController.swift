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
        view.backgroundColor = .white
        
        dismissButton.setTitle("❌", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(collageImageView)
        collageImageView.snp.makeConstraints { (make) in
            make.center.width.equalToSuperview()
            make.height.equalTo(collageImageView.snp.width)
        }
        
        collageImageView.image = collageImage
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
