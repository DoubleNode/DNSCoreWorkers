//
//  DNSCoreWorkersCodeLocationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSError
@testable import DNSCoreWorkers

final class DNSCoreWorkersCodeLocationTests: XCTestCase {

    // MARK: - DNSCodeLocation Extension Tests

    func test_codeLocation_typealias_exists() {
        // Test that the typealias extension exists and is accessible
        let location = DNSCodeLocation.coreWorkers(self)
        XCTAssertNotNil(location)
        XCTAssertTrue(location is DNSCoreWorkersCodeLocation)
    }

    func test_codeLocation_typealias_creates_correct_type() {
        // Test that the typealias points to the correct class
        let location = DNSCodeLocation.coreWorkers(self)
        XCTAssertTrue(type(of: location) == DNSCoreWorkersCodeLocation.self)
    }

    // MARK: - DNSCoreWorkersCodeLocation Class Tests

    func test_domainPreface_format() {
        // Test that domainPreface has the expected format
        let domainPreface = DNSCoreWorkersCodeLocation.domainPreface
        XCTAssertEqual(domainPreface, "com.doublenode.coreWorkers.")
        XCTAssertTrue(domainPreface.hasPrefix("com.doublenode."))
        XCTAssertTrue(domainPreface.hasSuffix("."))
    }

    func test_domainPreface_is_string() {
        // Test that domainPreface is a String
        let domainPreface = DNSCoreWorkersCodeLocation.domainPreface
        XCTAssertTrue(domainPreface is String)
        XCTAssertFalse(domainPreface.isEmpty)
    }

    func test_inheritance_hierarchy() {
        // Test that DNSCoreWorkersCodeLocation inherits from DNSCodeLocation
        let location = DNSCoreWorkersCodeLocation(self)
        XCTAssertTrue(location is DNSCodeLocation)
    }

    func test_class_instantiation() {
        // Test that the class can be instantiated
        let location = DNSCoreWorkersCodeLocation(self)
        XCTAssertNotNil(location)
    }

    func test_multiple_instances() {
        // Test that multiple instances can be created independently
        let location1 = DNSCoreWorkersCodeLocation(self)
        let location2 = DNSCoreWorkersCodeLocation(self)
        XCTAssertFalse(location1 === location2)
        XCTAssertNotNil(location1)
        XCTAssertNotNil(location2)
    }

    func test_domainPreface_consistency() {
        // Test that domainPreface is consistent across instances
        let location1 = DNSCoreWorkersCodeLocation(self)
        let location2 = DNSCoreWorkersCodeLocation(self)
        XCTAssertEqual(type(of: location1).domainPreface, type(of: location2).domainPreface)
        XCTAssertEqual(type(of: location1).domainPreface, DNSCoreWorkersCodeLocation.domainPreface)
    }

    func test_memory_management() {
        // Test that instances are properly deallocated
        weak var weakLocation: DNSCoreWorkersCodeLocation?
        autoreleasepool {
            let location = DNSCoreWorkersCodeLocation(self)
            weakLocation = location
            XCTAssertNotNil(weakLocation)
        }
        XCTAssertNil(weakLocation)
    }

    func test_open_class_modifier() {
        // Test that the class can be subclassed (open modifier)
        class TestSubclass: DNSCoreWorkersCodeLocation {
            override class var domainPreface: String { "test.prefix." }
        }

        let subclass = TestSubclass(self)
        XCTAssertNotNil(subclass)
        XCTAssertEqual(TestSubclass.domainPreface, "test.prefix.")
        XCTAssertTrue(subclass is DNSCoreWorkersCodeLocation)
    }

    func test_override_capability() {
        // Test that domainPreface can be overridden
        class CustomCodeLocation: DNSCoreWorkersCodeLocation {
            override class var domainPreface: String { "custom.domain." }
        }

        XCTAssertEqual(CustomCodeLocation.domainPreface, "custom.domain.")
        XCTAssertNotEqual(CustomCodeLocation.domainPreface, DNSCoreWorkersCodeLocation.domainPreface)
    }
}