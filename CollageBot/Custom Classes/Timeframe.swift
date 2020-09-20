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
            return "the last week"
        case .oneMonth:
            return "the last month"
        case .threeMonths:
            return "the last 3 months"
        case .sixMonths:
            return "the last 6 months"
        case .twelveMonths:
            return "the last year"
        case .overall:
            return "all time"
        }
    }
}
