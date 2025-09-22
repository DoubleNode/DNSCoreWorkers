//
//  DNSCoreWorkersBasicTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSCoreWorkers

final class DNSCoreWorkersBasicTests: XCTestCase {

    // MARK: - Module Constants Tests (No Worker Instantiation)

    func test_biometrics_constants_exist() {
        // Test that constants are accessible and properly formatted
        XCTAssertFalse(DNSAppConstants.Biometrics.enabled.isEmpty)
        XCTAssertFalse(DNSAppConstants.Biometrics.password.isEmpty)
        XCTAssertFalse(DNSAppConstants.Biometrics.username.isEmpty)
        XCTAssertFalse(DNSAppConstants.Biometrics.valet.isEmpty)
    }

    func test_biometrics_constants_format() {
        // Test that constants have expected format
        let bundleName = DNSCore.bundleName
        XCTAssertTrue(DNSAppConstants.Biometrics.enabled.contains(bundleName))
        XCTAssertTrue(DNSAppConstants.Biometrics.enabled.contains("Biometrics"))
        XCTAssertTrue(DNSAppConstants.Biometrics.enabled.contains("enabled"))
    }

    func test_biometrics_constants_uniqueness() {
        // Test that all constants are unique
        let constants = [
            DNSAppConstants.Biometrics.enabled,
            DNSAppConstants.Biometrics.password,
            DNSAppConstants.Biometrics.username,
            DNSAppConstants.Biometrics.valet
        ]

        let uniqueConstants = Set(constants)
        XCTAssertEqual(constants.count, uniqueConstants.count)
    }

    func test_module_compilation() {
        // Basic test that the module compiled successfully
        XCTAssertTrue(true, "DNSCoreWorkers module compiled successfully")
    }
}