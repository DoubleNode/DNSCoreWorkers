//
//  WKRCoreAppReview.swift
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

open class WKRCoreAppReview: WKRBlankAppReview, @unchecked Sendable {
    public var windowScene: UIWindowScene?

    // MARK: - Internal Work Methods
    override open func intDoReview(then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {
        guard utilityShouldRequestReview() else {
            _ = resultBlock?(.completed)
            return .success
        }
        
        Task { @MainActor in
            if #available(iOS 18.0, *) {
                // Use the new StoreKit AppStore API for iOS 18.0+
                if let windowScene = self.windowScene {
                    do {
                        try await StoreKit.AppStore.requestReview(in: windowScene)
                    } catch {
                        // If the new API fails, fall back to the old API
                        await self.legacyRequestReview()
                    }
                } else {
                    // No window scene available, fall back to legacy method
                    await self.legacyRequestReview()
                }
            } else {
                // Use legacy API for iOS versions below 18.0
                await self.legacyRequestReview()
            }
        }
        _ = resultBlock?(.completed)
        return .success
    }

    // MARK: - Private Methods -
    @MainActor
    private func legacyRequestReview() async {
        if let windowScene = self.windowScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: windowScene)
            } else {
                // For iOS versions below 14.0, use the global method
                SKStoreReviewController.requestReview()
            }
        } else {
            // Use the extension method if no window scene is available
            SKStoreReviewController.dnsRequestReviewInCurrentScene()
        }
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
