//
//  InformationEntryViewController.swift
//  CollageBot
//

import UIKit
import SnapKit

class InformationEntryViewController: UIViewController {
    
    let usernameField: UITextField = createView {
        $0.placeholder = "Username"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.borderStyle = .roundedRect
        $0.textAlignment = .center
    }
    lazy var timeframePicker = UIPickerView()
    let generateButton: UIButton = createView {
        $0.setTitle("Generate collage", for: .normal)
        $0.setTitleColor(.collageBotOrange, for: .normal)
    }
    
    lazy var outerStackView: UIStackView = createView {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    lazy var switchesStackView: UIStackView = createView {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
    }
    lazy var labelsStackView: UIStackView = createView {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fillEqually
    }
    lazy var titleLabel: UILabel = createView {
        $0.text = "Display album title"
        $0.textColor = .black
        $0.font = UIFont.collageBotFont(14)
    }
    lazy var artistLabel: UILabel = createView {
        $0.text = "Display artist"
        $0.textColor = .black
        $0.font = UIFont.collageBotFont(14)
    }
    lazy var playCountLabel: UILabel = createView {
        $0.text = "Display playcount"
        $0.textColor = .black
        $0.font = UIFont.collageBotFont(14)
    }
    lazy var artistSwitch = UISwitch()
    lazy var titleSwitch = UISwitch()
    lazy var playCountSwitch = UISwitch()
    lazy var gridView = GridSelectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    private func setUpUI() {
        view.backgroundColor = .collageBotOffWhite
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(usernameField)
        usernameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(timeframePicker)
        timeframePicker.delegate = self
        timeframePicker.dataSource = self
        timeframePicker.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(75)
        }
        
        view.addSubview(gridView)
        gridView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(gridView.snp.width)
            make.top.equalTo(timeframePicker.snp.bottom).offset(20)
        }
        view.layoutIfNeeded()
        gridView.setUpUI()
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(artistLabel)
        labelsStackView.addArrangedSubview(playCountLabel)
        switchesStackView.addArrangedSubview(titleSwitch)
        switchesStackView.addArrangedSubview(artistSwitch)
        switchesStackView.addArrangedSubview(playCountSwitch)
        outerStackView.addArrangedSubview(labelsStackView)
        outerStackView.addArrangedSubview(switchesStackView)
        view.addSubview(outerStackView)
        outerStackView.snp.makeConstraints { make in
            make.top.equalTo(gridView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        generateButton.addTarget(self, action: #selector(generateCollage(sender:)), for: .touchUpInside)
        view.addSubview(generateButton)
        generateButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func generateCollage(sender: UIButton) {
        sender.isEnabled = false
        
        guard let username = usernameField.text else { return /*handle error here*/}
        guard let selectedRow = gridView.selectedIndex?.row,
        let selectedColumn = gridView.selectedIndex?.column else { return /*handle error here*/}
        
        let numRows = selectedRow + 1
        let numColumns = selectedColumn + 1
        
        let timeframe = Timeframe.allCases[timeframePicker.selectedRow(inComponent: 0)]
        var optionsValue = 0
        optionsValue += titleSwitch.isOn ? CollageTextOptions.displayAlbumTitle.rawValue : 0
        optionsValue += artistSwitch.isOn ? CollageTextOptions.displayArtist.rawValue : 0
        optionsValue += playCountSwitch.isOn ? CollageTextOptions.displayPlayCount.rawValue : 0
        let options = CollageTextOptions(rawValue: optionsValue)
        
        var topAlbums = [Album]()
        LastfmAPIClient.getTopAlbums(username: username, timeframe: timeframe, limit: numRows*numColumns) { (result) in
            switch result {
            case let .success(albums):
                for album in albums {
                    topAlbums.append(Album(dictionary: album))
                }
                ImageDownloader.downloadImages(albums: topAlbums, completion: {
                    
                    let image = CollageCreator.createCollage(
                        rows: selectedRow + 1,
                        columns: selectedColumn + 1,
                        albums: topAlbums,
                        options: options
                    )
                    let collageVC = CollageDisplayViewController()
                    collageVC.collageImage = image
                    self.present(collageVC, animated: true, completion: nil)
                })
            case let .failure(error):
                print(error)
                // TODO: handle specific error case of username not existing in lastfm
            }
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
        sender.isEnabled = true
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
