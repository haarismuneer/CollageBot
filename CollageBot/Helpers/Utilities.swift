//
//  Utilities.swift
//  CollageBot
//

import Foundation
import UIKit

func createView<T>(_ setup: ((T) -> Void)) -> T where T: UIView {
    let object = T()
    setup(object)
    return object
}
