//
//  CollagePreferencesViewController.swift
//  CollageBot
//

import UIKit

class CollagePreferencesViewController: UIViewController {
    
    var outerStackView: UIStackView = createView {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    var switchesStackView: UIStackView = createView {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
    }
    var labelsStackView: UIStackView = createView {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fillEqually
    }
    var titleLabel: UILabel = createView {
        $0.text = "Display album title"
        $0.textColor = .black
        $0.font = .collageBotFont(15, fontType: .thin)
    }
    var artistLabel: UILabel = createView {
        $0.text = "Display artist"
        $0.textColor = .black
        $0.font = .collageBotFont(15, fontType: .thin)
    }
    var playCountLabel: UILabel = createView {
        $0.text = "Display playcount"
        $0.textColor = .black
        $0.font = .collageBotFont(15, fontType: .thin)
    }
    var gridSizeLabel: UILabel = createView {
        $0.text = "Grid size:"
        $0.textColor = .black
        $0.font = .collageBotFont(18, fontType: .regular)
    }
    var artistSwitch = UISwitch()
    var titleSwitch = UISwitch()
    var playCountSwitch = UISwitch()
    var gridView = GridSelectionView()
    var generateButton = UIButton(type: .system)
    var collageCreator: CollageCreator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGridView()
        setUpStackViews()
        setUpGenerateButton()
    }
    
    private func setUpGridView() {
        view.addSubview(gridSizeLabel)
        gridSizeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        view.addSubview(gridView)
        gridView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(gridView.snp.width)
            make.top.equalTo(gridSizeLabel.snp.bottom).offset(10)
        }
        view.layoutIfNeeded()
        gridView.setUpUI()
    }
    
    private func setUpStackViews() {
        // TODO: set initial state of switches based on User Defaults
        // If an artist collage is being made, there's no title to display
        // so no need for title preferences.
        if collageCreator?.contentType != .artists {
            titleLabel.text = collageCreator?.contentType == .albums ? "Display album title" : "Display track title"
            labelsStackView.addArrangedSubview(titleLabel)
            switchesStackView.addArrangedSubview(titleSwitch)
        }
        
        labelsStackView.addArrangedSubview(artistLabel)
        labelsStackView.addArrangedSubview(playCountLabel)
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
        generateButton.setTitle("Generate collage!", for: .normal)
        generateButton.setTitleColor(.collageBotOrange, for: .normal)
        generateButton.titleLabel?.font = UIFont.collageBotFont(22)
        generateButton.addTarget(self, action: #selector(generateCollage(sender:)), for: .touchUpInside)
        view.addSubview(generateButton)
        generateButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    @objc private func generateCollage(sender: UIButton) {
        sender.isEnabled = false
        
        guard let username = collageCreator?.username,
              let timeframe = collageCreator?.timeframe,
              let contentType = collageCreator?.contentType else { return /*handle error here*/}
        
        guard let selectedRow = gridView.selectedIndex?.row,
              let selectedColumn = gridView.selectedIndex?.column else { return /*handle error here*/}
        
        let numRows = selectedRow + 1
        let numColumns = selectedColumn + 1
        
        var optionsValue = 0
        if contentType != .artists {
            optionsValue += titleSwitch.isOn ? CollageTextOptions.displayTitle.rawValue : 0
        }
        optionsValue += artistSwitch.isOn ? CollageTextOptions.displayArtist.rawValue : 0
        optionsValue += playCountSwitch.isOn ? CollageTextOptions.displayPlayCount.rawValue : 0
        let options = CollageTextOptions(rawValue: optionsValue)
        
        var media = [MediaItem]()
        LastfmAPIClient.getTopContent(
            type: contentType,
            username: username,
            timeframe: timeframe,
            limit: numRows*numColumns
        ) { result in
            switch result {
            case let .success(content):
                // return and show alert if number of albums is less than rows x columns
                for item in content {
                    media.append(MediaItem(albumDictionary: item))
                }
                ImageDownloader.downloadImages(albums: media, completion: {
                    if let image = try? self.collageCreator?.createCollage(
                        rows: selectedRow + 1,
                        columns: selectedColumn + 1,
                        albums: media,
                        options: options
                    ) {
                        let collageVC = CollageDisplayViewController()
                        collageVC.collageImage = image
                        self.present(collageVC, animated: true, completion: nil)
                    }
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
