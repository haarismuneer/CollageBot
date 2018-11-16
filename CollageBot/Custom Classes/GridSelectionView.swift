//
//  GridSelectionView.swift
//  CollageBot
//

import UIKit

class GridSelectionView: UIView {
    
    var buttons = [SquareGridButton]()
    var selectedIndex: ButtonIndex?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        for row in 0..<5 {
            for column in 0..<5 {
                let squareButton = SquareGridButton(index: ButtonIndex(row: row, column: column))
                squareButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
                addSubview(squareButton)
                buttons.append(squareButton)
            }
        }
    }
    
    @objc private func buttonTapped(sender: SquareGridButton) {
        buttons.forEach {
            $0.isSelected = $0.index.row <= sender.index.row && $0.index.column < sender.index.column
        }
        selectedIndex = sender.index
    }
    
}
