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

}
