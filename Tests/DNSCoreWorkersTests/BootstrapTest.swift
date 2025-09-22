//
//  BootstrapTest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers

final class BootstrapTest: XCTestCase {

    func test_module_loads() {
        // Minimal test to verify module can be loaded
        XCTAssertTrue(true, "Module loaded successfully")
    }

    func test_test_service_factory() {
        // Test that TestServiceFactory can be created
        let factory = TestServiceFactory()
        XCTAssertNotNil(factory)
    }

    func test_mock_services() {
        // Test that mock services can be created without crashes
        let factory = TestServiceFactory()

        let locationService = factory.makeLocationService()
        XCTAssertNotNil(locationService)

        let cacheService = factory.makeCacheService(identifier: "test")
        XCTAssertNotNil(cacheService)

        let permissionService = factory.makePermissionService()
        XCTAssertNotNil(permissionService)

        let appReviewService = factory.makeAppReviewService()
        XCTAssertNotNil(appReviewService)
    }
}