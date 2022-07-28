//
//  InformationEntryViewController.swift
//  CollageBot
//

import SnapKit
import UIKit

class ContentEntryViewController: UIViewController {
    private let numberOfContentTypeRows = 1

    let usernameField: UITextField = createView {
        let placeholder = NSAttributedString(
            string: "Last.fm username",
            attributes: [NSAttributedString.Key.font: UIFont.collageBotFont(16)]
        )
        $0.attributedPlaceholder = placeholder
        $0.font = .collageBotFont(16)
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

        var prefereredTimeFrameIndex = 0
        if let preferredTimeframe = SettingsManager.get(Setting.preferredTimeframe) as? Int {
            prefereredTimeFrameIndex = preferredTimeframe
        }
        timeframePicker.selectRow(prefereredTimeFrameIndex, inComponent: 0, animated: false)
        pickerView(timeframePicker, didSelectRow: prefereredTimeFrameIndex, inComponent: 0)

//        contentTypePicker.selectRow(numberOfContentTypeRows / 2, inComponent: 0, animated: false)
//        pickerView(contentTypePicker, didSelectRow: numberOfContentTypeRows / 2, inComponent: 0)
        contentTypePicker.selectRow(0, inComponent: 0, animated: false)
        pickerView(contentTypePicker, didSelectRow: 0, inComponent: 0)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
    }

    private func setUpStackView() {
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(nextButton.snp.top).offset(-15)
            make.top.greaterThanOrEqualToSuperview().offset(15)
        }
    }

    private func setUpLogoView() {
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
        contentTypePicker.isUserInteractionEnabled = false

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
        sender.isEnabled = false

        func showErrorAlert() {
            showErrorAlert(
                title: "Oops!",
                message: "You need to enter a valid Last.fm username to continue. Please try again."
            )
        }

        if let text = usernameField.text {
            text.isValidUsername { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        self.performSegue(withIdentifier: "ContentEntryToCollagePreferences", sender: self.nextButton)
                    } else {
                        showErrorAlert()
                    }
                    sender.isEnabled = true
                }
            }
        } else {
            showErrorAlert()
            sender.isEnabled = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        let collageCreator = CollageCreator()
        collageCreator.username = usernameField.text
        collageCreator.timeframe = Timeframe.allCases[timeframePicker.selectedRow(inComponent: 0)]
//        let actualContentTypeIndex = contentTypePicker.selectedRow(inComponent: 0) % ContentType.allCases.count
//        collageCreator.contentType = ContentType.allCases[actualContentTypeIndex]
        collageCreator.contentType = .albums

        if let preferencesVC = segue.destination as? CollagePreferencesViewController {
            preferencesVC.collageCreator = collageCreator
        }
    }
}

// MARK: - UIPickerView Delegate/DataSource

extension ContentEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return pickerView == timeframePicker ? Timeframe.allCases.count : 1
    }

    func pickerView(_: UIPickerView, rowHeightForComponent _: Int) -> CGFloat {
        return Constants.pickerRowHeight
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent _: Int, reusing _: UIView?) -> UIView {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: timeframePicker.frame.width, height: Constants.pickerRowHeight)
        label.textAlignment = .center
        label.font = .collageBotFont(18)
        label.textColor = .darkGray
        if pickerView == timeframePicker {
            label.text = Timeframe.allCases[row].displayableName()
        } else if pickerView == contentTypePicker {
//            let actualRowNumber = row % ContentType.allCases.count
//            label.text = ContentType.allCases[actualRowNumber].displayableName()
            label.text = "album"
        }
        // Workaround for disabling new UIPickerView styling introduced in iOS 14.
        if #available(iOS 14.0, *) {
            pickerView.subviews[1].backgroundColor = .clear
        }

        return label
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedLabel = UILabel()
        if let label = timeframePicker.view(forRow: row, forComponent: component) as? UILabel {
            selectedLabel = label
            SettingsManager.set(Setting.preferredTimeframe, to: row)
        } else if let label = contentTypePicker.view(forRow: row % numberOfContentTypeRows, forComponent: component) as? UILabel {
            selectedLabel = label
        }

        selectedLabel.textColor = .collageBotTeal
        selectedLabel.font = .collageBotFont(18, fontType: .bold)
    }
}
