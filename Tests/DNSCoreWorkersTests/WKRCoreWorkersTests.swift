//
//  WKRCoreWorkersTests.swift
//  DoubleNode Swift Framework (DNSFramework) - WKRCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSCoreWorkers

final class WKRCoreWorkersTests: XCTestCase {

    // MARK: - DNSCoreWorkers Module Tests

    func test_DNSAppConstants_Biometrics_enabled() {
        // Test the enabled constant is properly formatted
        let expected = "\(DNSCore.bundleName)_Biometrics_enabled"
        XCTAssertEqual(DNSAppConstants.Biometrics.enabled, expected)
        XCTAssertFalse(DNSAppConstants.Biometrics.enabled.isEmpty)
    }

    func test_DNSAppConstants_Biometrics_password() {
        // Test the password constant is properly formatted
        let expected = "\(DNSCore.bundleName)_Biometrics_password"
        XCTAssertEqual(DNSAppConstants.Biometrics.password, expected)
        XCTAssertFalse(DNSAppConstants.Biometrics.password.isEmpty)
    }

    func test_DNSAppConstants_Biometrics_username() {
        // Test the username constant is properly formatted
        let expected = "\(DNSCore.bundleName)_Biometrics_username"
        XCTAssertEqual(DNSAppConstants.Biometrics.username, expected)
        XCTAssertFalse(DNSAppConstants.Biometrics.username.isEmpty)
    }

    func test_DNSAppConstants_Biometrics_valet() {
        // Test the valet constant is properly formatted
        let expected = "\(DNSCore.bundleName)_Biometrics_valet"
        XCTAssertEqual(DNSAppConstants.Biometrics.valet, expected)
        XCTAssertFalse(DNSAppConstants.Biometrics.valet.isEmpty)
    }

    func test_DNSAppConstants_Biometrics_uniqueness() {
        // Test that all biometric constants are unique
        let constants = [
            DNSAppConstants.Biometrics.enabled,
            DNSAppConstants.Biometrics.password,
            DNSAppConstants.Biometrics.username,
            DNSAppConstants.Biometrics.valet
        ]

        let uniqueConstants = Set(constants)
        XCTAssertEqual(constants.count, uniqueConstants.count, "All biometric constants should be unique")
    }

    func test_DNSAppConstants_Biometrics_bundleName_dependency() {
        // Test that constants properly depend on bundle name
        let bundleName = DNSCore.bundleName
        XCTAssertFalse(bundleName.isEmpty, "Bundle name should not be empty")

        XCTAssertTrue(DNSAppConstants.Biometrics.enabled.contains(bundleName))
        XCTAssertTrue(DNSAppConstants.Biometrics.password.contains(bundleName))
        XCTAssertTrue(DNSAppConstants.Biometrics.username.contains(bundleName))
        XCTAssertTrue(DNSAppConstants.Biometrics.valet.contains(bundleName))
    }

    func test_DNSAppConstants_requestReviews_loads_from_test_bundle() {
        // Test that requestReviews can be loaded from the test bundle Constants.plist
        // This should not throw an exception and should return false based on the test Constants.plist
        let result = DNSAppConstants.requestReviews
        XCTAssertFalse(result, "requestReviews should be false in test environment")
    }
}
