//
//  CollageBotError.swift
//  CollageBot
//

import Foundation
import UIKit
import SCLAlertView

enum CollageBotError: Error {
    
    case genericError
    case incorrectCount
    case unableToCreateCollage
    
}

extension UIViewController {

    func showGenericErrorAlert(title: String, subtitle: String) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK") {}
        alertView.showError(title, subTitle: subtitle)
    }

}
