//
//  Date+Conversion.swift
//  CollageBot
//

import Foundation

extension Date {
    
    func dateStringBeforeInterval(_ timeframe: Timeframe) -> String {
        // TODO: create result enum
        
        var component: Calendar.Component
        var value = 0
        
        switch timeframe {
        case .oneWeek:
            component = .weekOfYear
            value = -1
        case .oneMonth:
            component = .month
            value = -1
        case .threeMonths:
            component = .month
            value = -3
        case .sixMonths:
            component = .month
            value = -6
        case .twelveMonths:
            component = .year
            value = -1
        default:
            return ""
        }
        
        guard let previousDate = Calendar.current.date(byAdding: component, value: value, to: self) else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: previousDate)
    }
    
}

extension Double {
    
    func dateStringFromUnixTimestamp() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
}
