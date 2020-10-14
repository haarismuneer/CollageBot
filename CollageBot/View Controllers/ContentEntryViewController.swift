//
//  InformationEntryViewController.swift
//  CollageBot
//

import UIKit
import SnapKit
import SCLAlertView

class ContentEntryViewController: UIViewController {
    
    private let numberOfContentTypeRows = 100000
    
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
    var contentTypeStackView: UIStackView = createView {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    var getLabel: UILabel = createView {
        $0.text = "Get"
        $0.textColor = .black
        $0.font = .collageBotFont(16, fontType: .regular)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    var dataLabel: UILabel = createView {
        $0.text = "data"
        $0.textColor = .black
        $0.font = .collageBotFont(16, fontType: .regular)
        $0.textAlignment = .right
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    var forLabel: UILabel = createView {
        $0.text = "for..."
        $0.textColor = .black
        $0.font = .collageBotFont(16, fontType: .regular)
    }
    var mainStackView: UIStackView = createView {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    var nextButton = UIButton(type: .system)
    let logoView = UIImageView(image: UIImage(named: "logo"))
    var contentTypePicker = UIPickerView()
    var timeframePicker = UIPickerView()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: replace with user defaults
        timeframePicker.selectRow(0, inComponent: 0, animated: false)
        pickerView(timeframePicker, didSelectRow: 0, inComponent: 0)
        
        contentTypePicker.selectRow(numberOfContentTypeRows / 2, inComponent: 0, animated: false)
        pickerView(contentTypePicker, didSelectRow: numberOfContentTypeRows / 2, inComponent: 0)
    }
    
    // MARK: - UI Setup
    
    private func setUpUI() {
        title = ""
        view.backgroundColor = .collageBotOffWhite
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setUpNextButton()
        setUpStackView()
        setUpLogoView()
        setUpUsernameField()
        setUpContentTypeStackView()
        setUpTimeframePicker()
    }
    
    private func setUpNextButton() {
        nextButton.setTitle("Next →", for: .normal)
        nextButton.setTitleColor(.collageBotOrange, for: .normal)
        nextButton.titleLabel?.font = .collageBotFont(20, fontType: .bold)
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpStackView() {
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.8)
            make.bottom.greaterThanOrEqualTo(nextButton.snp.top).offset(-15)
            make.top.greaterThanOrEqualToSuperview().offset(15)
        }
    }
    
    private func setUpLogoView()  {
        logoView.contentMode = .scaleAspectFit
        mainStackView.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(logoView.snp.width).multipliedBy(0.25)
            make.top.equalToSuperview().offset(50)
        }
    }
    
    private func setUpUsernameField() {
        mainStackView.addSubview(usernameField)
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        }
    }
    
    private func setUpContentTypeStackView() {
        contentTypeStackView.addArrangedSubview(getLabel)
        contentTypeStackView.addArrangedSubview(contentTypePicker)
        contentTypeStackView.addArrangedSubview(dataLabel)
        setUpContentTypePicker()
        
        mainStackView.addSubview(contentTypeStackView)
        contentTypeStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(usernameField.snp.bottom).offset(15)
            make.height.equalTo(100)
        }
    }
    
    private func setUpContentTypePicker() {
        contentTypePicker.delegate = self
        contentTypePicker.dataSource = self
        
        getLabel.snp.makeConstraints { make in make.width.equalTo(50) }
        dataLabel.snp.makeConstraints { make in make.width.equalTo(50) }
    }
    
    private func setUpTimeframePicker() {
        mainStackView.addSubview(forLabel)
        forLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentTypeStackView.snp.bottom).offset(10)
        }
        
        mainStackView.addSubview(timeframePicker)
        timeframePicker.delegate = self
        timeframePicker.dataSource = self
        timeframePicker.snp.makeConstraints { make in
            make.top.equalTo(forLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(100)
        }
    }
    
    // MARK: - User Interaction
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        if let text = usernameField.text, text.isValidUsername() {
            performSegue(withIdentifier: "ContentEntryToCollagePreferences", sender: nextButton)
        } else {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {}
            alertView.showError("Whoops!", subTitle: "You need to enter a valid Last.fm username to continue.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collageCreator = CollageCreator()
        collageCreator.username = usernameField.text
        collageCreator.timeframe = Timeframe.allCases[timeframePicker.selectedRow(inComponent: 0)]
        let actualContentTypeIndex = contentTypePicker.selectedRow(inComponent: 0) % ContentType.allCases.count
        collageCreator.contentType = ContentType.allCases[actualContentTypeIndex]
        
        if let preferencesVC = segue.destination as? CollagePreferencesViewController {
            preferencesVC.collageCreator = collageCreator
        }
    }

}

// MARK: - UIPickerView Delegate/DataSource

extension ContentEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == timeframePicker ? Timeframe.allCases.count : numberOfContentTypeRows
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constants.pickerRowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: timeframePicker.frame.width, height: Constants.pickerRowHeight)
        label.textAlignment = .center
        label.font = .collageBotFont(18)
        label.textColor = .darkGray
        if pickerView == timeframePicker {
            label.text = Timeframe.allCases[row].displayableName()
        } else if pickerView == contentTypePicker {
            let actualRowNumber = row % ContentType.allCases.count
            label.text = ContentType.allCases[actualRowNumber].displayableName()
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedLabel = UILabel()
        if let label = timeframePicker.view(forRow: row, forComponent: component) as? UILabel {
            selectedLabel = label
        } else if let label = contentTypePicker.view(forRow: row % numberOfContentTypeRows, forComponent: component) as? UILabel {
            selectedLabel = label
        }
        
        selectedLabel.textColor = .collageBotTeal
//        selectedLabel.backgroundColor = .red
        selectedLabel.font = .collageBotFont(18, fontType: .bold)
    }
    
}
