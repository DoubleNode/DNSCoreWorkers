//
//  WKRCoreAppReview.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSAppCore
import DNSBlankWorkers
import DNSCore
import DNSProtocols
#if !TESTING
import StoreKit
#endif

open class WKRCoreAppReview: WKRBaseAppReview {
    public var windowScene: UIWindowScene?

    private let serviceFactory: ServiceFactoryProtocol
    private var appReviewService: AppReviewServiceProtocol?

    // MARK: - Initialization
    public init(serviceFactory: ServiceFactoryProtocol? = nil) {
        self.serviceFactory = serviceFactory ?? ProductionServiceFactory()
        super.init()
    }

    required public init() {
        self.serviceFactory = ProductionServiceFactory()
        super.init()
    }

    // MARK: - Lazy Service Initialization
    private var _appReviewService: AppReviewServiceProtocol {
        if appReviewService == nil {
            appReviewService = serviceFactory.makeAppReviewService()
        }
        return appReviewService!
    }

    // MARK: - Internal Work Methods
    override open func intDoReview(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAppReviewBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {
        return self.intDoReview(using: [:],
                                with: progress,
                                and: block,
                                then: resultBlock)
    }
    override open func intDoReview(using parameters: DNSDataDictionary,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAppReviewBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {

        // Check if we're in test mode (using TestServiceFactory)
        let isTestMode = serviceFactory is TestServiceFactory

        guard utilityShouldRequestReview() else {
            if isTestMode {
                // Async completion for tests to prevent race conditions
                DispatchQueue.main.async {
                    block?(.success)
                    _ = resultBlock?(.completed)
                }
            } else {
                block?(.success)
                _ = resultBlock?(.completed)
            }
            return .success
        }

        if _appReviewService.canRequestReview() {
            _appReviewService.requestReview()

            if isTestMode {
                // Async completion for tests
                DispatchQueue.main.async {
                    block?(.success)
                    _ = resultBlock?(.completed)
                }
            } else {
                block?(.success)
                _ = resultBlock?(.completed)
            }
            return .success
        }

        if isTestMode {
            // Async completion for tests
            DispatchQueue.main.async {
                block?(.success)
                _ = resultBlock?(.completed)
            }
        } else {
            block?(.success)
            _ = resultBlock?(.completed)
        }
        return .success
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
