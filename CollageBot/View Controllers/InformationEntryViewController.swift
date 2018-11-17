//
//  InformationEntryViewController.swift
//  CollageBot
//

import UIKit
import SnapKit

class InformationEntryViewController: UIViewController {
    
    let usernameField: UITextField = createView {
        let placeholder = NSAttributedString(
            string: "Last.fm username",
            attributes: [NSAttributedString.Key.font: UIFont.collageBotFont(16)]
        )
        $0.attributedPlaceholder = placeholder
        $0.font = UIFont.collageBotFont(16)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.borderStyle = .roundedRect
        $0.textAlignment = .center
    }
    lazy var timeframePicker = UIPickerView()
    lazy var generateButton = UIButton(type: .system)
    lazy var outerStackView: UIStackView = createView {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
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
        $0.font = UIFont.collageBotFont(15, fontType: .thin)
    }
    lazy var artistLabel: UILabel = createView {
        $0.text = "Display artist"
        $0.textColor = .black
        $0.font = UIFont.collageBotFont(15, fontType: .thin)
    }
    lazy var playCountLabel: UILabel = createView {
        $0.text = "Display playcount"
        $0.textColor = .black
        $0.font = UIFont.collageBotFont(15, fontType: .thin)
    }
    lazy var artistSwitch = UISwitch()
    lazy var titleSwitch = UISwitch()
    lazy var playCountSwitch = UISwitch()
    lazy var gridView = GridSelectionView()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: replace with user defaults
        timeframePicker.selectRow(0, inComponent: 0, animated: false)
        pickerView(timeframePicker, didSelectRow: 0, inComponent: 0)
    }
    
    // MARK: - UI Setup
    
    private func setUpUI() {
        view.backgroundColor = .collageBotOffWhite
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setUpUsernameField()
        setUpTimeFramePicker()
        setUpGridView()
        setUpStackViews()
        setUpGenerateButton()
    }
    
    private func setUpUsernameField() {
        view.addSubview(usernameField)
        usernameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setUpTimeFramePicker() {
        view.addSubview(timeframePicker)
        timeframePicker.delegate = self
        timeframePicker.dataSource = self
        timeframePicker.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(100)
        }
    }
    
    private func setUpGridView() {
        view.addSubview(gridView)
        gridView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(gridView.snp.width)
            make.top.equalTo(timeframePicker.snp.bottom).offset(20)
        }
        view.layoutIfNeeded()
        gridView.setUpUI()
    }
    
    private func setUpStackViews() {
        // TODO: set initial state of switches based on User Defaults
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(artistLabel)
        labelsStackView.addArrangedSubview(playCountLabel)
        switchesStackView.addArrangedSubview(titleSwitch)
        switchesStackView.addArrangedSubview(artistSwitch)
        switchesStackView.addArrangedSubview(playCountSwitch)
        
        for case let optionSwitch as UISwitch in switchesStackView.arrangedSubviews {
            optionSwitch.onTintColor = .collageBotOrange
        }
        
        outerStackView.addArrangedSubview(labelsStackView)
        outerStackView.addArrangedSubview(switchesStackView)
        view.addSubview(outerStackView)
        outerStackView.snp.makeConstraints { make in
            make.top.equalTo(gridView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    private func setUpGenerateButton() {
        generateButton.setTitle("Generate collage", for: .normal)
        generateButton.setTitleColor(.collageBotOrange, for: .normal)
        generateButton.titleLabel?.font = UIFont.collageBotFont(22)
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
                // return and show alert if number of albums is less than rows x columns
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

// MARK: - UIPickerView Delegate/DataSource

extension InformationEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Timeframe.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constants.pickerRowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: timeframePicker.frame.width, height: Constants.pickerRowHeight)
        label.textAlignment = .center
        label.font = UIFont.collageBotFont(18)
        label.textColor = .darkGray
        label.text = Timeframe.allCases[row].displayableName()
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let label = timeframePicker.view(forRow: row, forComponent: component) as? UILabel {
            label.textColor = .collageBotOrange
            label.font = UIFont.collageBotFont(18, fontType: .bold)
        }
    }
    
}
