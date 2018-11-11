//
//  InformationEntryViewController.swift
//  CollageBot
//

import UIKit
import SnapKit

class InformationEntryViewController: UIViewController {
    
    lazy var usernameField = UITextField()
    lazy var timeframePicker = UIPickerView()
    lazy var generateButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    private func setUpUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        usernameField.placeholder = "Username"
        usernameField.autocorrectionType = .no
        usernameField.borderStyle = .roundedRect
        usernameField.textAlignment = .center
        view.addSubview(usernameField)
        usernameField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(timeframePicker)
        timeframePicker.delegate = self
        timeframePicker.dataSource = self
        timeframePicker.snp.makeConstraints { (make) in
            make.top.equalTo(usernameField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        generateButton.setTitle("Generate collage", for: .normal)
        generateButton.addTarget(self, action: #selector(generateCollage), for: .touchUpInside)
        view.addSubview(generateButton)
        generateButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func generateCollage() {
        guard let username = usernameField.text else { return /*handle error here*/}
        let timeframe = Timeframe.allCases[timeframePicker.selectedRow(inComponent: 0)]
        
        var topAlbums = [Album]()
        LastfmAPIClient.getTopAlbums(username: username, timeframe: timeframe, limit: 9) { (result) in
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

extension InformationEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Timeframe.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Timeframe.allCases[row].displayableName()
    }
    
}
