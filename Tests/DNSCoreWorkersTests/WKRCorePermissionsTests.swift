//
//  WKRCorePermissionsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSBlankWorkers
import DNSProtocols
@testable import DNSCoreWorkers

final class WKRCorePermissionsTests: XCTestCase {

    // MARK: - Basic Tests Only (No System Permission Access)

    func test_initialization() {
        let worker = WKRCorePermissions(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker)
        XCTAssertTrue(worker is WKRBasePermissions)
        XCTAssertTrue(worker is WKRPTCLPermissions)
    }

    func test_inheritance_hierarchy() {
        let worker = WKRCorePermissions(serviceFactory: TestServiceFactory())
        XCTAssertTrue(worker is WKRBasePermissions)
    }

    func test_protocol_conformance() {
        let worker = WKRCorePermissions(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker as? WKRPTCLPermissions)
    }

    func test_multiple_instances() {
        let worker1 = WKRCorePermissions(serviceFactory: TestServiceFactory())
        let worker2 = WKRCorePermissions(serviceFactory: TestServiceFactory())
        XCTAssertFalse(worker1 === worker2)
    }

    func test_memory_management() {
        weak var weakWorker: WKRCorePermissions?
        autoreleasepool {
            let worker = WKRCorePermissions(serviceFactory: TestServiceFactory())
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker)
    }
}
