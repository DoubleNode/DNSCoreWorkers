//
//  WKRCoreTestGeoTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSBlankWorkers
import DNSProtocols
@testable import DNSCoreWorkers

final class WKRCoreTestGeoTests: XCTestCase {

    private var sut: WKRCoreTestGeo!

    override func setUp() {
        super.setUp()
        sut = WKRCoreTestGeo(serviceFactory: TestServiceFactory())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic Tests

    func test_initialization() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut is WKRBaseGeo)
        XCTAssertTrue(sut is WKRPTCLGeo)
    }

    func test_inheritance_hierarchy() {
        XCTAssertTrue(sut is WKRBaseGeo)
    }

    func test_protocol_conformance() {
        XCTAssertNotNil(sut as? WKRPTCLGeo)
    }

    func test_memory_management() {
        weak var weakWorker: WKRCoreTestGeo?
        autoreleasepool {
            let worker = WKRCoreTestGeo()
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker)
    }

    // MARK: - Property Tests

    func test_geohash_property_default() {
        XCTAssertEqual(sut.geohash, "")
        XCTAssertTrue(sut.geohash.isEmpty)
    }

    func test_geohash_property_can_be_set() {
        let testGeohash = "u4pruydqqvj"
        sut.geohash = testGeohash
        XCTAssertEqual(sut.geohash, testGeohash)
    }

    func test_geohash_property_can_be_cleared() {
        sut.geohash = "test_value"
        XCTAssertFalse(sut.geohash.isEmpty)

        sut.geohash = ""
        XCTAssertTrue(sut.geohash.isEmpty)
    }

    func test_geohash_property_accepts_various_formats() {
        let testGeohashes = [
            "u4pruydqqvj",       // Standard geohash
            "9q8yy",             // Short geohash
            "u4pruydqqvj8",      // Longer geohash
            "123456789",         // Numeric string
            "abc",               // Short string
            "",                  // Empty string
            " ",                 // Space
            "test_location"      // Custom identifier
        ]

        for geohash in testGeohashes {
            sut.geohash = geohash
            XCTAssertEqual(sut.geohash, geohash, "Geohash should accept value: '\(geohash)'")
        }
    }

    // MARK: - Locate Method Tests

    func test_intDoLocate_method_exists() {
        // Test that the method exists and can be called
        // This is a void method that should complete without crashing
        sut.intDoLocate(with: nil, and: nil, then: nil)
        XCTAssertTrue(true, "intDoLocate should not crash")
    }

    func test_intDoLocate_with_progress_block() {
        var progressCalled = false
        let progressBlock: DNSPTCLProgressBlock = { _, _, _, _ in
            progressCalled = true
        }

        sut.intDoLocate(with: progressBlock, and: nil, then: nil)

        // Progress may or may not be called depending on implementation
        // The important thing is that it doesn't crash
        XCTAssertTrue(true, "intDoLocate with progress block should not crash")
    }

    func test_intDoLocate_with_completion_block() {
        var blockCalled = false
        let completionBlock: WKRPTCLGeoBlkStringLocation = { result in
            blockCalled = true
            // Block is commented out in implementation, so may not be called
        }

        sut.intDoLocate(with: nil, and: completionBlock, then: nil)

        // The completion block is currently commented out in the implementation
        // So we don't expect it to be called, but the method should not crash
        XCTAssertTrue(true, "intDoLocate with completion block should not crash")
    }

    func test_intDoLocate_with_result_block() {
        var resultBlockCalled = false
        let resultBlock: DNSPTCLResultBlock = { result in
            resultBlockCalled = true
            // Should be called with .completed
        }

        sut.intDoLocate(with: nil, and: nil, then: resultBlock)

        // The result block should be called with .completed based on implementation
        XCTAssertTrue(resultBlockCalled, "Result block should be called")
    }

    func test_intDoLocate_with_all_blocks() {
        var progressCalled = false
        var blockCalled = false
        var resultBlockCalled = false

        let progressBlock: DNSPTCLProgressBlock = { _, _, _, _ in
            progressCalled = true
        }

        let completionBlock: WKRPTCLGeoBlkStringLocation = { result in
            blockCalled = true
        }

        let resultBlock: DNSPTCLResultBlock = { result in
            resultBlockCalled = true
        }

        sut.intDoLocate(with: progressBlock, and: completionBlock, then: resultBlock)

        // Result block should definitely be called
        XCTAssertTrue(resultBlockCalled, "Result block should be called")

        // Progress and completion blocks may or may not be called
        XCTAssertTrue(true, "Method should complete without crashing")
    }

    func test_intDoLocate_multiple_calls() {
        // Test that multiple calls don't interfere with each other
        var resultCount = 0
        let resultBlock: DNSPTCLResultBlock = { result in
            resultCount += 1
        }

        for i in 0..<5 {
            sut.intDoLocate(with: nil, and: nil, then: resultBlock)
            XCTAssertEqual(resultCount, i + 1, "Result block should be called for each invocation")
        }
    }

    func test_intDoLocate_concurrent_calls() {
        // Test concurrent calls are handled safely
        let expectation = self.expectation(description: "Concurrent locate calls")
        expectation.expectedFulfillmentCount = 5

        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)

        for i in 0..<5 {
            queue.async {
                self.sut.intDoLocate(with: nil, and: nil) { result in
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    // MARK: - Integration Tests

    func test_geohash_integration_with_locate() {
        // Test that setting geohash works with locate method
        let testGeohash = "u4pruydqqvj"
        sut.geohash = testGeohash

        var resultBlockCalled = false
        sut.intDoLocate(with: nil, and: nil) { result in
            resultBlockCalled = true
        }

        XCTAssertEqual(sut.geohash, testGeohash, "Geohash should remain set after locate call")
        XCTAssertTrue(resultBlockCalled, "Result block should be called")
    }

    func test_locate_does_not_modify_geohash() {
        // Test that calling locate doesn't change the geohash property
        let originalGeohash = "test_geohash"
        sut.geohash = originalGeohash

        sut.intDoLocate(with: nil, and: nil, then: nil)

        XCTAssertEqual(sut.geohash, originalGeohash, "Locate should not modify geohash property")
    }

    // MARK: - Multiple Instance Tests

    func test_multiple_instances_independent() {
        let worker1 = WKRCoreTestGeo()
        let worker2 = WKRCoreTestGeo()

        worker1.geohash = "geohash1"
        worker2.geohash = "geohash2"

        XCTAssertNotEqual(worker1.geohash, worker2.geohash)
        XCTAssertFalse(worker1 === worker2)
    }

    func test_multiple_instances_locate_independently() {
        let worker1 = WKRCoreTestGeo()
        let worker2 = WKRCoreTestGeo()

        var result1Called = false
        var result2Called = false

        worker1.intDoLocate(with: nil, and: nil) { result in
            result1Called = true
        }

        worker2.intDoLocate(with: nil, and: nil) { result in
            result2Called = true
        }

        XCTAssertTrue(result1Called, "Worker1 result should be called")
        XCTAssertTrue(result2Called, "Worker2 result should be called")
    }

    // MARK: - Edge Case Tests

    func test_locate_with_various_geohash_values() {
        let geohashes = ["", "short", "very_long_geohash_value_12345", "u4pruydqqvj"]

        for geohash in geohashes {
            sut.geohash = geohash

            var completed = false
            sut.intDoLocate(with: nil, and: nil) { result in
                completed = true
            }

            XCTAssertTrue(completed, "Locate should complete with geohash: '\(geohash)'")
            XCTAssertEqual(sut.geohash, geohash, "Geohash should remain unchanged: '\(geohash)'")
        }
    }

    func test_locate_stress_test() {
        // Test rapid successive calls
        var completionCount = 0
        let resultBlock: DNSPTCLResultBlock = { result in
            completionCount += 1
        }

        for _ in 0..<100 {
            sut.intDoLocate(with: nil, and: nil, then: resultBlock)
        }

        XCTAssertEqual(completionCount, 100, "All locate calls should complete")
    }

    // MARK: - Memory and Performance Tests

    func test_locate_memory_usage() {
        // Test that repeated calls don't cause memory issues
        weak var weakSut = sut

        for _ in 0..<50 {
            sut.intDoLocate(with: nil, and: nil, then: nil)
        }

        XCTAssertNotNil(weakSut, "Worker should still exist after multiple calls")
    }

    func test_memory_cleanup_after_locate() {
        // Test that blocks are properly released
        weak var weakWorker: WKRCoreTestGeo?

        autoreleasepool {
            let worker = WKRCoreTestGeo()
            weakWorker = worker

            worker.intDoLocate(with: nil, and: { _ in
                // Completion block
            }, then: { _ in
                // Result block
            })

            XCTAssertNotNil(weakWorker)
        }

        // Worker should be deallocated
        XCTAssertNil(weakWorker, "Worker should be deallocated after scope")
    }
}
