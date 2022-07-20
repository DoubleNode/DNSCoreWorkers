//
//  WKRCoreAppReviewWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSAppCore
import DNSBlankWorkers
import DNSCore
import DNSProtocols
import StoreKit

open class WKRCoreAppReviewWorker: WKRBlankAppReviewWorker {
    public var windowScene: UIWindowScene?

    // MARK: - Internal Work Methods
    override open func intDoReview(then resultBlock: DNSPTCLResultBlock?) throws -> Bool {
        guard utilityShouldRequestReview() else {
            _ = resultBlock?(.completed)
            return false
        }
        if self.windowScene != nil {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: self.windowScene!)
                _ = resultBlock?(.completed)
                return true
            }
        }
        SKStoreReviewController.requestReview()
        _ = resultBlock?(.completed)
        return true
    }

    // MARK: - Utility methods -
    func utilityShouldRequestReview() -> Bool {
        // If enabled...
        if !DNSAppConstants.requestReviews {
            return false
        }
        // ...and not crashed last time...
        if self.appDidCrashLastRun {
            return false
        }
        // ...and launched at least usesUntilPrompt times...
        if self.launchedCount < self.usesUntilPrompt {
            return false
        }
        // ...and first launch at least daysUntilPrompt ago...
        let secondsUntilPrompt = Date.Seconds.deltaOneDay * Double(self.daysUntilPrompt)
        if Date().timeIntervalSince(self.launchedFirstTime) < secondsUntilPrompt {
            return false
        }
        // ...and last launch at least hoursSinceLastLaunch ago...
        let secondsSinceLastLaunch = Date.Seconds.deltaOneHour * Double(self.hoursSinceLastLaunch)
        if Date().timeIntervalSince(self.launchedLastTime ?? Date()) < secondsSinceLastLaunch {
            return false
        }
        // ...and total launches less than usesSinceFirstLaunch times...
        if self.launchedCount > self.usesSinceFirstLaunch {
            // ... or total launches is once every usesFrequency...
            if self.launchedCount == 0 || self.usesFrequency == 0 {
                return false
            }
            if (self.launchedCount % self.usesFrequency) != 0 {
                return false
            }
        }
        // ...and not previously reviewed...
        if self.reviewRequestLastTime != nil {
            // ...or previously reviewed at least daysBeforeReminding ago...
            let secondsBeforeReminding = Date.Seconds.deltaOneDay * Double(self.daysBeforeReminding)
            if Date().timeIntervalSince(self.reviewRequestLastTime ?? Date()) < secondsBeforeReminding {
                return false
            }
        }
        return true
    }
}
