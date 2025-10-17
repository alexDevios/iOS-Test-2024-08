//
//  AppReviewDurationService.swift
//  iOS-Test
//
//  Created by Oleksandr Honcharenko on 17.10.2025.
//

import Foundation

public protocol AppReviewDurationServiceProtocol {
    var isAppReviewDurationExpired: Bool { get }
    func startObservingUsage(_ action: @escaping () async -> Void)
    func stopObservingUsage()
}

public final class AppReviewDurationService: AppReviewDurationServiceProtocol {
    private var userDefaultsService: UserDefaultsServiceProtocol
    private let sessionTimeoutInSeconds: TimeInterval
    private let usageDurationInSeconds: TimeInterval
    private let reviewDay: Int
    private var observeredUsageTask: Task<Void, Never>?
    
    private var reviewDayInSeconds: TimeInterval {
        TimeInterval(reviewDay * 24 * 3600)
    }
    
    public init(
        userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService(),
        sessionTimeoutInSeconds: TimeInterval = 3600,
        usageDurationInSeconds: TimeInterval = 600, reviewDay: Int = 3
    ) {
        self.userDefaultsService = userDefaultsService
        self.sessionTimeoutInSeconds = sessionTimeoutInSeconds
        self.usageDurationInSeconds = usageDurationInSeconds
        self.reviewDay = reviewDay
    }
    
    public var isAppReviewDurationExpired: Bool {
        return checkActiveSession()
        || checkLastReviewDate()
    }
    
    public func startObservingUsage(_ action: @escaping () async -> Void) {
        observeredUsageTask?.cancel()
        observeredUsageTask = Task {
            debugPrint("Waiting \(usageDurationInSeconds) seconds")
            try? await Task.sleep(nanoseconds: UInt64(usageDurationInSeconds * 1_000_000_000))
            guard !Task.isCancelled else {
                debugPrint("Observation cancelled")
                return
            }
            debugPrint("Should review")
            await action()
        }
    }
    
    public func stopObservingUsage() {
        debugPrint("Cancelling observation")
        observeredUsageTask?.cancel()
        observeredUsageTask = nil
    }
    
    private func checkActiveSession() -> Bool {
        let currentTime = Date()
        if let startingSessionDate = userDefaultsService.startingSessionDate {
            userDefaultsService.startingSessionDate = currentTime
            let isSessionCompleted = currentTime.timeIntervalSince(startingSessionDate) > sessionTimeoutInSeconds
            debugPrint("Should reviewed?", isSessionCompleted)
            return isSessionCompleted
        } else {
            debugPrint("Should reviewed!")
            userDefaultsService.startingSessionDate = currentTime
            return true
        }
    }
    
    private func checkLastReviewDate() -> Bool {
        guard let lastReviewDate = userDefaultsService.lastReviewRequestedDate else {
            debugPrint("Should reviewed!")
            return true
        }
        
        let isMoreThanReviewDay = Date().timeIntervalSince(lastReviewDate) >= reviewDayInSeconds
        debugPrint("Should reviewed?", isMoreThanReviewDay)
        return isMoreThanReviewDay
    }
}

