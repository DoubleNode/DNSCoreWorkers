//
//  WKRCoreGeoTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSBlankWorkers
import DNSProtocols
@testable import DNSCoreWorkers

final class WKRCoreGeoTests: XCTestCase {

    // MARK: - Basic Tests Only (No System Services)

    func test_initialization() {
        // Test basic instantiation without triggering location services
        let worker = WKRCoreGeo(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker)
        XCTAssertTrue(worker is WKRBaseGeo)
        XCTAssertTrue(worker is WKRPTCLGeo)
    }

    func test_inheritance_hierarchy() {
        let worker = WKRCoreGeo(serviceFactory: TestServiceFactory())
        XCTAssertTrue(worker is WKRBaseGeo)
    }

    func test_protocol_conformance() {
        let worker = WKRCoreGeo(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker as? WKRPTCLGeo)
    }

    func test_multiple_instances() {
        let worker1 = WKRCoreGeo(serviceFactory: TestServiceFactory())
        let worker2 = WKRCoreGeo(serviceFactory: TestServiceFactory())
        XCTAssertFalse(worker1 === worker2)
    }

    func test_memory_management() {
        weak var weakWorker: WKRCoreGeo?
        autoreleasepool {
            let worker = WKRCoreGeo(serviceFactory: TestServiceFactory())
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker)
    }
}
