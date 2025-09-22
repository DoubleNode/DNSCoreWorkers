//
//  ServiceFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSAppCore
import Foundation
#if !TESTING
import Valet
#endif

// MARK: - Production Service Factory
public class ProductionServiceFactory: ServiceFactoryProtocol {
    public init() {}

    public func makeLocationService() -> LocationServiceProtocol {
        #if TESTING
        return MockLocationService()
        #else
        return ProductionLocationService()
        #endif
    }

    public func makeCacheService(identifier: String) -> CacheServiceProtocol {
        #if TESTING
        return MockCacheService()
        #else
        return ProductionCacheService(identifier: identifier)
        #endif
    }

    public func makeSecureCacheService(identifier: String) -> SecureCacheServiceProtocol {
        #if TESTING
        return MockSecureCacheService()
        #else
        return ProductionSecureCacheService(identifier: identifier)
        #endif
    }

    public func makePermissionService() -> PermissionServiceProtocol {
        #if TESTING
        return MockPermissionService()
        #else
        return ProductionPermissionService()
        #endif
    }

    public func makeAppReviewService() -> AppReviewServiceProtocol {
        #if TESTING
        return MockAppReviewService()
        #else
        return ProductionAppReviewService()
        #endif
    }
}

// MARK: - Test Service Factory
public class TestServiceFactory: ServiceFactoryProtocol {
    public init() {}

    public func makeLocationService() -> LocationServiceProtocol {
        return MockLocationService()
    }

    public func makeCacheService(identifier: String) -> CacheServiceProtocol {
        return MockCacheService()
    }

    public func makeSecureCacheService(identifier: String) -> SecureCacheServiceProtocol {
        return MockSecureCacheService()
    }

    public func makePermissionService() -> PermissionServiceProtocol {
        return MockPermissionService()
    }

    public func makeAppReviewService() -> AppReviewServiceProtocol {
        return MockAppReviewService()
    }
}

// MARK: - Global Service Factory Access (Simplified)
// Note: Removed DNSAppGlobals.isRunningTest dependency to avoid test runner crashes
// Tests should explicitly pass TestServiceFactory() to constructors