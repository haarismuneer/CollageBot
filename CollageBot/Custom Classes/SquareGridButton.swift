//
//  SquareGridButton.swift
//  CollageBot
//

import UIKit

struct ButtonIndex {
    var row: Int
    var column: Int
}

class SquareGridButton: UIButton {
    var index: ButtonIndex

    init(index: ButtonIndex) {
        self.index = index
        super.init(frame: .zero)

        setUpBorder()
    }

    private func setUpBorder() {
        layer.borderColor = UIColor.collageBotBlue.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 3
        layer.masksToBounds = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .collageBotTeal : .clear
        }
    }
}
