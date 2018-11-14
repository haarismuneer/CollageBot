//
//  GridSelectionView.swift
//  CollageBot
//

import UIKit

class GridSelectionView: UIView {
    
    var buttons = [SquareGridButton]()
    
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
                let squareButton = SquareGridButton(index: (row, column))
                squareButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
                addSubview(squareButton)
                buttons.append(squareButton)
            }
        }
    }
    
    @objc private func buttonTapped(sender: SquareGridButton) {
        
    }
    
}
