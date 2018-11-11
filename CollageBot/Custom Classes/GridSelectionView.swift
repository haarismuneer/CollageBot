//
//  GridSelectionView.swift
//  CollageBot
//

import UIKit

class GridSelectionView: UIView {
    
    func setUpUI() {
        for row in 0..<5 {
            for column in 0..<5 {
                let squareButton = SquareGridButton(index: (row, column))
            }
        }
    }
    
}
