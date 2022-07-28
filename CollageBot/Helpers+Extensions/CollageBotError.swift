//
//  CollageBotError.swift
//  CollageBot
//

import Foundation
import UIKit

enum CollageBotError: Error {
    case genericError
    case incorrectCount
    case unableToCreateCollage
}

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
