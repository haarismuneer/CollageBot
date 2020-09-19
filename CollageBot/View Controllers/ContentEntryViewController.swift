//
//  InformationEntryViewController.swift
//  CollageBot
//

import UIKit
import SnapKit

class ContentEntryViewController: UIViewController {
    
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - UIPickerView Delegate/DataSource

extension ContentEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == timeframePicker ? Timeframe.allCases.count : ContentType.allCases.count
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
        label.text = pickerView == timeframePicker ? Timeframe.allCases[row].displayableName() : ContentType.allCases[row].displayableName()
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timeframePicker {
            if let label = timeframePicker.view(forRow: row, forComponent: component) as? UILabel {
                label.textColor = .collageBotOrange
                label.font = UIFont.collageBotFont(18, fontType: .bold)
            }
        } else {
            
        }
    }
    
}
