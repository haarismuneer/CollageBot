//
//  SquareGridButton.swift
//  CollageBot
//

import UIKit

class SquareGridButton: UIButton {

    var index: (Int, Int)
    
    init(index: (Int, Int)) {
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
