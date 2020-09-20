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
    }
    
    private func setUpGridView() {
        view.addSubview(gridView)
        gridView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(gridView.snp.width)
            make.top.equalToSuperview().offset(30)
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
        optionsValue += titleSwitch.isOn ? CollageTextOptions.displayAlbumTitle.rawValue : 0
        optionsValue += artistSwitch.isOn ? CollageTextOptions.displayArtist.rawValue : 0
        optionsValue += playCountSwitch.isOn ? CollageTextOptions.displayPlayCount.rawValue : 0
        let options = CollageTextOptions(rawValue: optionsValue)
        
        var topAlbums = [Album]()
        LastfmAPIClient.getTopContent(type: .albums, username: username, timeframe: timeframe, limit: numRows*numColumns) { (result) in
            switch result {
            case let .success(albums):
                // return and show alert if number of albums is less than rows x columns
                for album in albums {
                    topAlbums.append(Album(dictionary: album))
                }
                ImageDownloader.downloadImages(albums: topAlbums, completion: {
                    if let image = try? self.collageCreator?.createCollage(
                        rows: selectedRow + 1,
                        columns: selectedColumn + 1,
                        albums: topAlbums,
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
