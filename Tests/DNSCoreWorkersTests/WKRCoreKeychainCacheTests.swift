//
//  WKRCoreKeychainCacheTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSBlankWorkers
import DNSProtocols
@testable import DNSCoreWorkers

final class WKRCoreKeychainCacheTests: XCTestCase {

    // MARK: - Basic Tests Only (No Keychain Access)

    func test_initialization() {
        let worker = WKRCoreKeychainCache(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker)
        XCTAssertTrue(worker is WKRBaseCache)
        XCTAssertTrue(worker is WKRPTCLCache)
    }

    func test_inheritance_hierarchy() {
        let worker = WKRCoreKeychainCache(serviceFactory: TestServiceFactory())
        XCTAssertTrue(worker is WKRBaseCache)
    }

    func test_protocol_conformance() {
        let worker = WKRCoreKeychainCache(serviceFactory: TestServiceFactory())
        XCTAssertNotNil(worker as? WKRPTCLCache)
    }

    func test_constants() {
        XCTAssertEqual(WKRCoreKeychainCache.C.valetId, "WKRCoreKeychainCache")
        XCTAssertFalse(WKRCoreKeychainCache.C.valetId.isEmpty)
    }

    func test_multiple_instances() {
        let worker1 = WKRCoreKeychainCache()
        let worker2 = WKRCoreKeychainCache()
        XCTAssertFalse(worker1 === worker2)
    }

    func test_memory_management() {
        weak var weakWorker: WKRCoreKeychainCache?
        autoreleasepool {
            let worker = WKRCoreKeychainCache(serviceFactory: TestServiceFactory())
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker)
    }
}
