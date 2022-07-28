//
//  SettingsManager.swift
//  CollageBot
//

import Foundation

struct SettingsManager {
    private init() {}

    static func set(_ setting: UserDefaultSettable, to value: Any?) {
        UserDefaults.standard.set(value, forKey: setting.rawValue)
    }

    static func get(_ setting: UserDefaultSettable) -> Any? {
        return UserDefaults.standard.value(forKey: setting.rawValue)
    }
}

enum Setting: String, UserDefaultSettable {
    case preferredTimeframe
    case preferredContentType
    case preferredRowIndex
    case preferredColumnIndex
    case showTitle
    case showArtistName
    case showPlaycount
}

protocol UserDefaultSettable {
    var rawValue: String { get }
}
