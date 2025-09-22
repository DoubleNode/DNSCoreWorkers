//
//  IsolatedTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import CoreLocation
@testable import DNSCoreWorkers

// MARK: - Isolated Test Suite (No System Dependencies)
final class IsolatedTests: XCTestCase {

    // MARK: - Module Level Tests
    func test_module_loads() {
        XCTAssertTrue(true, "Module loaded successfully")
    }

    // MARK: - Service Factory Tests (Mock Only)
    func test_test_service_factory_creation() {
        let factory = TestServiceFactory()
        XCTAssertNotNil(factory)
    }

    func test_mock_location_service() {
        let factory = TestServiceFactory()
        let service = factory.makeLocationService()

        XCTAssertNotNil(service)
        XCTAssertTrue(service is MockLocationService)

        let mockService = service as! MockLocationService
        XCTAssertEqual(mockService.desiredAccuracy, kCLLocationAccuracyBest)
        XCTAssertFalse(mockService.allowsBackgroundLocationUpdates)
        XCTAssertTrue(mockService.mockLocationServicesEnabled)
    }

    func test_mock_cache_service() {
        let factory = TestServiceFactory()
        let service = factory.makeCacheService(identifier: "test-cache")

        XCTAssertNotNil(service)
        XCTAssertTrue(service is MockCacheService)

        // Test basic cache operations
        do {
            try service.setString("test-value", forKey: "test-key")
            let retrievedValue = try service.string(forKey: "test-key")
            XCTAssertEqual(retrievedValue, "test-value")

            let exists = try service.containsObject(forKey: "test-key")
            XCTAssertTrue(exists)

            try service.removeObject(forKey: "test-key")
            let existsAfterRemoval = try service.containsObject(forKey: "test-key")
            XCTAssertFalse(existsAfterRemoval)
        } catch {
            XCTFail("Cache operations should not throw errors: \(error)")
        }
    }

    func test_mock_secure_cache_service() {
        let factory = TestServiceFactory()
        let service = factory.makeSecureCacheService(identifier: "test-secure-cache")

        XCTAssertNotNil(service)
        XCTAssertTrue(service is MockSecureCacheService)

        // Test secure cache operations
        do {
            try service.setString("secure-value", forKey: "secure-key")
            let retrievedValue = try service.string(forKey: "secure-key")
            XCTAssertEqual(retrievedValue, "secure-value")

            // Test prompt requirement
            try service.requirePromptOnNextAccess(forKey: "secure-key")
            let valueAfterPrompt = try service.string(forKey: "secure-key")
            XCTAssertEqual(valueAfterPrompt, "secure-value")
        } catch {
            XCTFail("Secure cache operations should not throw errors: \(error)")
        }
    }

    func test_mock_permission_service() {
        let factory = TestServiceFactory()
        let service = factory.makePermissionService()

        XCTAssertNotNil(service)
        XCTAssertTrue(service is MockPermissionService)

        let mockService = service as! MockPermissionService

        // Test initial state
        XCTAssertEqual(mockService.permissionStatus(for: "camera"), "notDetermined")

        // Test permission request
        let expectation = self.expectation(description: "Permission request")
        service.requestPermission(for: "camera") { granted in
            XCTAssertTrue(granted) // Default mock behavior grants permissions
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // Test permission status after request
        XCTAssertEqual(mockService.permissionStatus(for: "camera"), "authorized")
    }

    func test_mock_app_review_service() {
        let factory = TestServiceFactory()
        let service = factory.makeAppReviewService()

        XCTAssertNotNil(service)
        XCTAssertTrue(service is MockAppReviewService)

        let mockService = service as! MockAppReviewService

        // Test initial state
        XCTAssertEqual(mockService.reviewRequestCount, 0)
        XCTAssertTrue(mockService.canRequestReview())

        // Test review request
        service.requestReview()
        XCTAssertEqual(mockService.reviewRequestCount, 1)

        // Test multiple requests
        service.requestReview()
        XCTAssertEqual(mockService.reviewRequestCount, 2)
    }

    // MARK: - Worker Initialization Tests (Safe Workers Only)
    func test_keychain_cache_worker_with_test_factory() {
        let worker = WKRCoreKeychainCache(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker)
        XCTAssertTrue(worker is WKRCoreKeychainCache)
    }

    func test_secure_enclave_cache_worker_with_test_factory() {
        let worker = WKRCoreSecureEnclaveCache(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker)
        XCTAssertTrue(worker is WKRCoreSecureEnclaveCache)
    }

    func test_validation_worker_with_test_factory() {
        let worker = WKRCoreValidation()
        XCTAssertNotNil(worker)
        XCTAssertTrue(worker is WKRCoreValidation)
    }

    func test_pass_strength_worker_with_test_factory() {
        let worker = WKRCorePassStrength()
        XCTAssertNotNil(worker)
        XCTAssertTrue(worker is WKRCorePassStrength)
    }

    // MARK: - Constants and Static Properties Tests
    func test_keychain_cache_constants() {
        XCTAssertEqual(WKRCoreKeychainCache.C.valetId, "WKRCoreKeychainCache")
        XCTAssertFalse(WKRCoreKeychainCache.C.valetId.isEmpty)
    }

    func test_secure_enclave_constants() {
        XCTAssertEqual(WKRCoreSecureEnclaveCache.C.requirePromptOnNextAccess, "requirePromptOnNextAccess")
        XCTAssertFalse(WKRCoreSecureEnclaveCache.C.requirePromptOnNextAccess.isEmpty)
    }

    // MARK: - Memory Management Tests
    func test_worker_memory_management() {
        weak var weakWorker: WKRCoreKeychainCache?
        autoreleasepool {
            let worker = WKRCoreKeychainCache(serviceFactory: TestServiceFactory())
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker, "Worker should be deallocated")
    }

    func test_service_factory_memory_management() {
        weak var weakFactory: TestServiceFactory?
        autoreleasepool {
            let factory = TestServiceFactory()
            weakFactory = factory
            XCTAssertNotNil(weakFactory)
        }
        XCTAssertNil(weakFactory, "Service factory should be deallocated")
    }
}

// MARK: - Protocol Conformance Tests
final class ProtocolConformanceTests: XCTestCase {

    func test_service_factory_protocol_conformance() {
        let factory = TestServiceFactory()
        XCTAssertTrue(factory is ServiceFactoryProtocol)

        // Test all required methods are available
        let _ = factory.makeLocationService()
        let _ = factory.makeCacheService(identifier: "test")
        let _ = factory.makeSecureCacheService(identifier: "test")
        let _ = factory.makePermissionService()
        let _ = factory.makeAppReviewService()
    }

    func test_mock_services_protocol_conformance() {
        let factory = TestServiceFactory()

        // Test all services conform to their protocols
        XCTAssertTrue(factory.makeLocationService() is LocationServiceProtocol)
        XCTAssertTrue(factory.makeCacheService(identifier: "test") is CacheServiceProtocol)
        XCTAssertTrue(factory.makeSecureCacheService(identifier: "test") is SecureCacheServiceProtocol)
        XCTAssertTrue(factory.makePermissionService() is PermissionServiceProtocol)
        XCTAssertTrue(factory.makeAppReviewService() is AppReviewServiceProtocol)
    }
}