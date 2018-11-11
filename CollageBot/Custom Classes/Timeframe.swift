//
//  Timeframe.swift
//  CollageBot
//

import Foundation

enum Timeframe: String, CaseIterable {
    case oneWeek = "7day"
    case oneMonth = "1month"
    case threeMonths = "3month"
    case sixMonths = "6month"
    case twelveMonths = "12month"
    case overall
    
    func displayableName() -> String {
        switch self {
        case .oneWeek:
            return "1 week"
        case .oneMonth:
            return "1 month"
        case .threeMonths:
            return "3 months"
        case .sixMonths:
            return "6 months"
        case .twelveMonths:
            return "1 year"
        case .overall:
            return self.rawValue.capitalized
        }
    }
}
