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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = self.isSelected ? .blue : .clear
        }
    }

}
