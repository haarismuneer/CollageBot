//
//  CollageDisplayViewController.swift
//  CollageBot
//

import UIKit
import SnapKit

class CollageDisplayViewController: UIViewController {
    
    var collageImage = UIImage()
    var dismissButton = UIButton(type: .system)
    var collageImageView = UIImageView()
    var saveButton = UIButton(type: .system)
    var shareButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    // MARK: - UI Setup
    
    private func setUpUI() {
        setUpButtons()
        configureCollage()
        
        view.backgroundColor = .collageBotOffWhite
    }
    
    private func setUpButtons() {
        dismissButton.setTitle("❌", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(40)
        }
        
        saveButton.setTitle("⬇️", for: .normal)
        saveButton.addTarget(self, action: #selector(saveCollage), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(saveButton.snp.height)
        }
        
        shareButton.setTitle("⬆️", for: .normal)
        shareButton.addTarget(self, action: #selector(shareCollage), for: .touchUpInside)
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(shareButton.snp.height)
        }
    }
    
    private func configureCollage() {
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
                make.height.equalToSuperview().multipliedBy(0.7)
                make.width.equalTo(collageImageView.snp.height).multipliedBy(collageWidth/collageHeight)
            }
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
    
    @objc private func shareCollage() {
        let activityController = UIActivityViewController(activityItems: [collageImage], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    @objc private func saveCollage() {
        UIImageWriteToSavedPhotosAlbum(collageImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // failed
        } else {
            
        }
    }

}
