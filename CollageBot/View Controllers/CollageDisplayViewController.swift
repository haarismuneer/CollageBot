//
//  CollageDisplayViewController.swift
//  CollageBot
//

import SnapKit
import UIKit

class CollageDisplayViewController: UIViewController {
    var collageScrollView = UIScrollView()
    var collageImageView = UIImageView()

    var dismissButton = UIButton(type: .system)
    var saveButton = UIButton(type: .system)
    var shareButton = UIButton(type: .system)
    var buttons: [UIButton] = []

    var collageImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    // MARK: - UI Setup

    private func setUpUI() {
        setUpButtons()
        setUpScrollView()
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

        buttons = [dismissButton, saveButton, shareButton]
    }

    private func setUpScrollView() {
        collageScrollView = UIScrollView(frame: view.frame)
        collageScrollView.maximumZoomScale = 4.0
        collageScrollView.showsVerticalScrollIndicator = false
        collageScrollView.showsHorizontalScrollIndicator = false
        collageScrollView.delegate = self
        view.addSubview(collageScrollView)
        view.sendSubviewToBack(collageScrollView)

        collageScrollView.snp.makeConstraints { make in
            make.centerX.centerY.width.height.equalToSuperview()
        }
    }

    private func configureCollage() {
        collageImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))

        let collageWidth = collageImage.size.width
        let collageHeight = collageImage.size.height

        func setConstraintsBasedOnWidth() {
            collageImageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(collageImageView.snp.width).multipliedBy(collageHeight / collageWidth)
            }
        }

        func setConstraintsBasedOnHeight() {
            collageImageView.snp.makeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.7)
                make.width.equalTo(collageImageView.snp.height).multipliedBy(collageWidth / collageHeight)
            }
        }

        collageScrollView.addSubview(collageImageView)
        collageWidth >= collageHeight ? setConstraintsBasedOnWidth() : setConstraintsBasedOnHeight()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleButtonVisibility))
        collageImageView.isUserInteractionEnabled = true
        collageImageView.addGestureRecognizer(tapGesture)

        collageImageView.image = collageImage
        collageImageView.contentMode = .scaleAspectFit
        collageScrollView.contentSize = collageImageView.frame.size
        adjustCentering()
    }

    @objc private func shareCollage() {
        let activityController = UIActivityViewController(activityItems: [collageImage], applicationActivities: nil)
        present(activityController, animated: true)
    }

    @objc private func saveCollage() {
        UIImageWriteToSavedPhotosAlbum(collageImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    @objc func image(_: UIImage, didFinishSavingWithError error: NSError?, contextInfo _: UnsafeRawPointer) {
        if let error = error {
            displayErrorMessage(error: error)
        } else {
            displaySuccessMessage()
        }
    }

    private func displaySuccessMessage() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showSuccess("Successfully saved your collage!")
    }

    private func displayErrorMessage(error: Error) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK") {}
        alertView.showError("Oh no!", subTitle: "There was an error while saving your collage. Please try again later. Additional info: \(error.localizedDescription)")
    }
}

extension CollageDisplayViewController: UIScrollViewDelegate {
    func viewForZooming(in _: UIScrollView) -> UIView? {
        return collageImageView
    }

    func scrollViewWillBeginZooming(_: UIScrollView, with _: UIView?) {
        buttons.forEach {
            $0.isHidden = true
        }
    }

    func scrollViewDidEndZooming(_: UIScrollView, with _: UIView?, atScale scale: CGFloat) {
        buttons.forEach {
            $0.isHidden = scale > 1.0
        }
    }

    @objc private func toggleButtonVisibility() {
        buttons.forEach {
            $0.isHidden = !$0.isHidden
        }
    }

    func scrollViewDidZoom(_: UIScrollView) {
        adjustCentering()
    }

    private func adjustCentering() {
        if collageImageView.frame.height <= collageScrollView.frame.height {
            let shiftHeight = collageScrollView.frame.height / 2.0 - collageScrollView.contentSize.height / 2.0
            collageScrollView.contentInset.top = shiftHeight
        }
        if collageImageView.frame.width <= collageScrollView.frame.width {
            let shiftWidth = collageScrollView.frame.width / 2.0 - collageScrollView.contentSize.width / 2.0
            collageScrollView.contentInset.left = shiftWidth
        }
    }
}
