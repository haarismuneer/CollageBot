//
//  CollagePreferencesViewController.swift
//  CollageBot
//

import UIKit

class CollagePreferencesViewController: UIViewController {
    var outerStackView: UIStackView = createView {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }

    var switchesStackView: UIStackView = createView {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalCentering
    }

    var labelsStackView: UIStackView = createView {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .equalCentering
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
    var loadingIndicator = UIActivityIndicatorView(frame: .zero)
    var collageCreator: CollageCreator?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .collageBotTeal
        setUpGridView()
        setUpStackViews()
        setUpGenerateButton()
        setUpLoadingIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
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
            make.top.equalTo(gridView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(120)
        }

        configureSwitches()
    }

    private func configureSwitches() {
        if let showTitle = SettingsManager.get(Setting.showTitle) as? Bool {
            titleSwitch.isOn = showTitle
        }
        if let showArtistName = SettingsManager.get(Setting.showArtistName) as? Bool {
            artistSwitch.isOn = showArtistName
        }
        if let showPlaycount = SettingsManager.get(Setting.showPlaycount) as? Bool {
            playCountSwitch.isOn = showPlaycount
        }

        switchesStackView.subviews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(30)
            }
        }

        labelsStackView.subviews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(30)
            }
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

    private func setUpLoadingIndicator() {
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .large
        } else {
            loadingIndicator.style = .whiteLarge
        }
        loadingIndicator.alpha = 0
        loadingIndicator.color = .collageBotOrange
        loadingIndicator.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        loadingIndicator.layer.cornerRadius = view.frame.width / 4
        loadingIndicator.layer.borderWidth = 3
        loadingIndicator.layer.borderColor = UIColor.collageBotOrange.cgColor
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(loadingIndicator.snp.width)
        }
    }

    @objc private func generateCollage(sender: UIButton) {
        defer {
            sender.isEnabled = true
            SettingsManager.set(Setting.showTitle, to: titleSwitch.isOn)
            SettingsManager.set(Setting.showArtistName, to: artistSwitch.isOn)
            SettingsManager.set(Setting.showPlaycount, to: playCountSwitch.isOn)
        }
        sender.isEnabled = false

        guard let username = collageCreator?.username,
              let timeframe = collageCreator?.timeframe,
              let contentType = collageCreator?.contentType else { return /* handle error here */ }

        guard let selectedRow = gridView.selectedIndex?.row,
              let selectedColumn = gridView.selectedIndex?.column else { return /* handle error here */ }

        showLoadingIndicator()

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
            limit: numRows * numColumns
        ) { result in
            switch result {
            case let .success(content):
                for item in content {
                    media.append(MediaItem(albumDictionary: item))
                }
                ImageDownloader.downloadImages(albums: media, completion: {
                    do {
                        if let image = try self.collageCreator?.createCollage(
                            rows: selectedRow + 1,
                            columns: selectedColumn + 1,
                            albums: media,
                            options: options
                        ) {
                            let collageVC = CollageDisplayViewController()
                            collageVC.collageImage = image
                            self.hideLoadingIndicator()
                            self.present(collageVC, animated: true, completion: nil)
                        }
                    } catch {
                        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.addButton("OK") {}
                        self.showGenericErrorAlert(title: "Oh no!", subtitle: "There was an error while creating your collage. Please try again later. Additional info: \(error.localizedDescription)")
                    }
                })
            case let .failure(error):
                var title = ""
                var subtitle = ""
                switch error {
                case CollageBotError.incorrectCount:
                    title = "Hmmm..."
                    let contentType = self.collageCreator?.contentType?.displayableName() ?? "album"
                    subtitle = "We couldn't fetch enough \(contentType) data to fill your collage. Try again with a different timeframe or grid size."
                default:
                    title = "Oh no!"
                    subtitle = "There was an error while fetching your account data. Please try again later. Additional info: \(error.localizedDescription)"
                }
                self.showGenericErrorAlert(title: title, subtitle: subtitle)
            }
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }

    private func showLoadingIndicator() {
        UIView.animate(withDuration: 0.2) {
            self.loadingIndicator.alpha = 1
            self.loadingIndicator.isHidden = false
        } completion: { _ in
            self.loadingIndicator.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        UIView.animate(withDuration: 0.2) {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.alpha = 0
        } completion: { _ in
            self.loadingIndicator.stopAnimating()
        }
    }
}
