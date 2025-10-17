//
//  UserDefaultsServiceProtocol.swift
//  iOS-Test
//
//  Created by Oleksandr Honcharenko on 17.10.2025.
//

import Foundation

public protocol UserDefaultsServiceProtocol {
    var startingSessionDate: Date? { get set }
    var lastReviewRequestedDate: Date? { get set }
}

public final class UserDefaultsService: UserDefaultsServiceProtocol {
    private var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: "some.suit.name")
    }

    public init() {}
    
    public var startingSessionDate: Date? {
        get {
            return getFromUserDefaults(.startingSessionDate) as? Date
        }
        set {
            setToUserDefaults(newValue, key: .startingSessionDate)
        }
    }
    
    public var lastReviewRequestedDate: Date? {
        get {
            return getFromUserDefaults(.lastReviewRequestedDate) as? Date
        }
        set {
            setToUserDefaults(newValue, key: .lastReviewRequestedDate)
        }
    }
}

extension UserDefaultsService {
    fileprivate enum UserDefaultsKey: String {
        case startingSessionDate
        case lastReviewRequestedDate
    }
}

extension UserDefaultsService {
    private func getFromUserDefaults(_ key: UserDefaultsKey) -> Any? {
        return userDefaults?.object(forKey: key.rawValue)
    }
    
    private func setToUserDefaults(_ value: Any?, key: UserDefaultsKey) {
        userDefaults?.set(value, forKey: key.rawValue)
    }
}
