//
//  AppReviewService.swift
//  iOS-Test
//
//  Created by Oleksandr Honcharenko on 17.10.2025.
//

import StoreKit
import Foundation

public protocol AppReviewServiceProtocol {
    func startReviewFlow()
}

public final class AppReviewService: AppReviewServiceProtocol {
    private var userDefaultsService: UserDefaultsServiceProtocol
    
    public init(userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()) {
        self.userDefaultsService = userDefaultsService
    }
    
    public func startReviewFlow() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            userDefaultsService.lastReviewRequestedDate = Date()
        }
    }
}
