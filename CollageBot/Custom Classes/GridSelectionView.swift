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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        for row in 0..<5 {
            for column in 0..<5 {
                let squareButton = SquareGridButton(index: ButtonIndex(row: row, column: column))
                squareButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                addSubview(squareButton)
                let size = CGSize(width: (frame.width - 20)/5, height: (frame.width - 20)/5)
                let x = size.width * CGFloat(column) + CGFloat(5 * column)
                let y = size.width * CGFloat(row) + CGFloat(5 * row)
                squareButton.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
                buttons.append(squareButton)
            }
        }
        
        // Select preferred layout
        // TODO: replace with User Defaults
        buttons.forEach {
            if $0.index.row == 2 && $0.index.column == 2 {
                buttonTapped($0)
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: SquareGridButton) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.15) {
                button.isSelected = button.index.row <= sender.index.row && button.index.column <= sender.index.column
            }
        }
        selectedIndex = sender.index
    }
    
}
