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
        dismissButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dismissButton.tintColor = .collageBotOrange
        dismissButton.layer.cornerRadius = 15
        dismissButton.layer.borderWidth = 2
        dismissButton.layer.borderColor = UIColor.collageBotOrange.cgColor
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.contentHorizontalAlignment = .fill
        dismissButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(30)
        }
        
        saveButton.setImage(UIImage(named: "download")?.withRenderingMode(.alwaysTemplate), for: .normal)
        saveButton.tintColor = .collageBotOrange
        saveButton.layer.cornerRadius = 30
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.collageBotOrange.cgColor
        saveButton.contentVerticalAlignment = .fill
        saveButton.contentHorizontalAlignment = .fill
        saveButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        saveButton.addTarget(self, action: #selector(saveCollage), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.height.width.equalTo(60)
            make.width.equalTo(saveButton.snp.height)
        }
        
        shareButton.setImage(UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.tintColor = .collageBotOrange
        shareButton.layer.cornerRadius = 30
        shareButton.layer.borderWidth = 2
        shareButton.layer.borderColor = UIColor.collageBotOrange.cgColor
        shareButton.contentVerticalAlignment = .fill
        shareButton.contentHorizontalAlignment = .fill
        shareButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        shareButton.addTarget(self, action: #selector(shareCollage), for: .touchUpInside)
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.height.width.equalTo(60)
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
