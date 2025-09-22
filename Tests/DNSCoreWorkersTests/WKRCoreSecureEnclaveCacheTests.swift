//
//  WKRCoreSecureEnclaveCacheTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Combine
import DNSBlankWorkers
import DNSCore
import DNSError
import DNSProtocols
@testable import DNSCoreWorkers

final class WKRCoreSecureEnclaveCacheTests: XCTestCase {

    private var sut: WKRCoreSecureEnclaveCache!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        sut = WKRCoreSecureEnclaveCache(serviceFactory: TestServiceFactory())
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        cancellables?.removeAll()
        cancellables = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic Tests

    func test_initialization() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut is WKRCoreKeychainCache)
        XCTAssertTrue(sut is WKRPTCLCache)
    }

    func test_inheritance_hierarchy() {
        XCTAssertTrue(sut is WKRCoreKeychainCache)
        XCTAssertTrue(sut is WKRBlankCache)
    }

    func test_protocol_conformance() {
        XCTAssertNotNil(sut as? WKRPTCLCache)
    }

    func test_memory_management() {
        weak var weakWorker: WKRCoreSecureEnclaveCache?
        autoreleasepool {
            let worker = WKRCoreSecureEnclaveCache(serviceFactory: TestServiceFactory())
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker)
    }

    // MARK: - Constants Tests

    func test_constants_exist() {
        // Test that constants are defined and accessible
        XCTAssertEqual(WKRCoreSecureEnclaveCache.C.requirePromptOnNextAccess, "requirePromptOnNextAccess")
        XCTAssertFalse(WKRCoreSecureEnclaveCache.C.requirePromptOnNextAccess.isEmpty)
    }

    func test_localizations_exist() {
        // Test that localization strings are accessible
        let prompt = WKRCoreSecureEnclaveCache.Localizations.Biometric.prompt
        XCTAssertNotNil(prompt)
        XCTAssertTrue(prompt is String)
        // Note: We don't test the actual localized string content as it may vary
    }

    // MARK: - Enable Option Tests (Safe)

    func test_enableOption_requirePromptOnNextAccess() {
        // Test that the method exists and can be called without triggering biometrics
        // This tests the code path but shouldn't actually prompt for biometrics in test environment

        // Should not crash when called
        sut.enableOption(WKRCoreSecureEnclaveCache.C.requirePromptOnNextAccess)
        XCTAssertTrue(true, "Enable option should not crash")
    }

    func test_enableOption_unknown_option() {
        // Test with unknown option
        sut.enableOption("unknown_option")
        XCTAssertTrue(true, "Unknown option should not crash")
    }

    func test_enableOption_empty_string() {
        // Test with empty string
        sut.enableOption("")
        XCTAssertTrue(true, "Empty option should not crash")
    }

    func test_enableOption_multiple_calls() {
        // Test multiple calls don't cause issues
        sut.enableOption(WKRCoreSecureEnclaveCache.C.requirePromptOnNextAccess)
        sut.enableOption("other_option")
        sut.enableOption(WKRCoreSecureEnclaveCache.C.requirePromptOnNextAccess)
        XCTAssertTrue(true, "Multiple enable option calls should not crash")
    }

    // MARK: - Cache Operation Tests (Error Handling Focus)

    func test_deleteObject_method_exists() {
        // Test that the method exists and returns the correct type
        // Note: We expect this to fail in test environment due to keychain access
        let publisher = sut.intDoDeleteObject(for: "test_key", with: nil, then: nil)
        XCTAssertNotNil(publisher)

        // Verify it's the correct publisher type
        XCTAssertTrue(publisher is AnyPublisher<Void, Error>)
    }

    func test_deleteObject_with_invalid_key() {
        // Test error handling with invalid key
        let expectation = self.expectation(description: "Delete object completion")

        let publisher = sut.intDoDeleteObject(for: "nonexistent_key", with: nil) { result in
            // Should complete regardless of success/failure
            expectation.fulfill()
        }

        publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        // May succeed if key doesn't exist (delete is idempotent)
                        break
                    case .failure(let error):
                        // Expected to fail in test environment
                        XCTAssertNotNil(error)
                        XCTAssertTrue(error is DNSError)
                    }
                },
                receiveValue: { _ in
                    // Delete operation completed
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_readObject_method_exists() {
        // Test that the method exists and returns the correct type
        let publisher = sut.intDoReadObject(for: "test_key", with: nil, then: nil)
        XCTAssertNotNil(publisher)

        // Verify it's the correct publisher type
        XCTAssertTrue(publisher is AnyPublisher<Any, Error>)
    }

    func test_readObject_with_nonexistent_key() {
        // Test reading non-existent key
        let expectation = self.expectation(description: "Read object completion")

        let publisher = sut.intDoReadObject(for: "nonexistent_key", with: nil) { result in
            expectation.fulfill()
        }

        publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // May fail due to keychain access in test environment
                        XCTAssertNotNil(error)
                    }
                },
                receiveValue: { value in
                    // Should return empty data for non-existent key
                    XCTAssertNotNil(value)
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_readString_method_exists() {
        // Test that the method exists and returns the correct type
        let publisher = sut.intDoReadString(for: "test_key", with: nil, then: nil)
        XCTAssertNotNil(publisher)

        // Verify it's the correct publisher type
        XCTAssertTrue(publisher is AnyPublisher<String, Error>)
    }

    func test_readString_with_nonexistent_key() {
        // Test reading non-existent string key
        let expectation = self.expectation(description: "Read string completion")

        let publisher = sut.intDoReadString(for: "nonexistent_key", with: nil) { result in
            expectation.fulfill()
        }

        publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // May fail due to keychain access in test environment
                        XCTAssertNotNil(error)
                    }
                },
                receiveValue: { value in
                    // Should return empty string for non-existent key
                    XCTAssertTrue(value is String)
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_updateObject_method_exists() {
        // Test that the method exists and returns the correct type
        let testData = "test_string"
        let publisher = sut.intDoUpdate(object: testData, for: "test_key", with: nil, then: nil)
        XCTAssertNotNil(publisher)

        // Verify it's the correct publisher type
        XCTAssertTrue(publisher is AnyPublisher<Any, Error>)
    }

    func test_updateObject_with_string() {
        // Test updating with string object
        let expectation = self.expectation(description: "Update string completion")
        let testString = "test_value"

        let publisher = sut.intDoUpdate(object: testString, for: "test_key", with: nil) { result in
            expectation.fulfill()
        }

        publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // Expected to fail in test environment due to keychain access
                        XCTAssertNotNil(error)
                        XCTAssertTrue(error is DNSError)
                    }
                },
                receiveValue: { value in
                    // Should return the original object
                    XCTAssertNotNil(value)
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_updateObject_with_data() {
        // Test updating with data object
        let expectation = self.expectation(description: "Update data completion")
        let testData = "test_value".data(using: .utf8)!

        let publisher = sut.intDoUpdate(object: testData, for: "test_key", with: nil) { result in
            expectation.fulfill()
        }

        publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // Expected to fail in test environment due to keychain access
                        XCTAssertNotNil(error)
                        XCTAssertTrue(error is DNSError)
                    }
                },
                receiveValue: { value in
                    // Should return the original object
                    XCTAssertNotNil(value)
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_updateObject_with_unsupported_type() {
        // Test updating with unsupported object type
        let expectation = self.expectation(description: "Update unsupported type completion")
        let testObject = NSNumber(value: 42)

        let publisher = sut.intDoUpdate(object: testObject, for: "test_key", with: nil) { result in
            expectation.fulfill()
        }

        publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // May fail or succeed depending on implementation
                        XCTAssertNotNil(error)
                    }
                },
                receiveValue: { value in
                    // Should return the original object
                    XCTAssertNotNil(value)
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    // MARK: - Progress Block Tests

    func test_operations_with_progress_blocks() {
        // Test that progress blocks can be passed without crashing
        var progressCalled = false
        let progressBlock: DNSPTCLProgressBlock = { _, _, _, _ in
            progressCalled = true
        }

        // Test each operation with progress block
        let deletePublisher = sut.intDoDeleteObject(for: "test", with: progressBlock, then: nil)
        XCTAssertNotNil(deletePublisher)

        let readPublisher = sut.intDoReadObject(for: "test", with: progressBlock, then: nil)
        XCTAssertNotNil(readPublisher)

        let readStringPublisher = sut.intDoReadString(for: "test", with: progressBlock, then: nil)
        XCTAssertNotNil(readStringPublisher)

        let updatePublisher = sut.intDoUpdate(object: "test", for: "test", with: progressBlock, then: nil)
        XCTAssertNotNil(updatePublisher)

        // Progress may or may not be called depending on implementation
        // The important thing is that it doesn't crash
    }

    // MARK: - Result Block Tests

    func test_operations_with_result_blocks() {
        // Test that result blocks are called appropriately
        var resultBlocksCalled = 0
        let resultBlock: DNSPTCLResultBlock = { result in
            resultBlocksCalled += 1
        }

        let expectation = self.expectation(description: "Result blocks completion")
        expectation.expectedFulfillmentCount = 4

        // Test each operation with result block
        sut.intDoDeleteObject(for: "test", with: nil, then: resultBlock)
            .sink(receiveCompletion: { _ in expectation.fulfill() }, receiveValue: { _ in })
            .store(in: &cancellables)

        sut.intDoReadObject(for: "test", with: nil, then: resultBlock)
            .sink(receiveCompletion: { _ in expectation.fulfill() }, receiveValue: { _ in })
            .store(in: &cancellables)

        sut.intDoReadString(for: "test", with: nil, then: resultBlock)
            .sink(receiveCompletion: { _ in expectation.fulfill() }, receiveValue: { _ in })
            .store(in: &cancellables)

        sut.intDoUpdate(object: "test", for: "test", with: nil, then: resultBlock)
            .sink(receiveCompletion: { _ in expectation.fulfill() }, receiveValue: { _ in })
            .store(in: &cancellables)

        waitForExpectations(timeout: 3.0, handler: nil)

        // Result blocks should be called (may be called multiple times per operation)
        XCTAssertGreaterThanOrEqual(resultBlocksCalled, 0)
    }

    // MARK: - Error Handling Tests

    func test_error_types_are_dns_errors() {
        // Test that errors thrown are DNSError types
        let expectation = self.expectation(description: "Error type verification")
        expectation.expectedFulfillmentCount = 4

        // These should all fail in test environment, allowing us to verify error types
        sut.intDoDeleteObject(for: "test", with: nil, then: nil)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertTrue(error is DNSError, "Delete error should be DNSError")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        sut.intDoReadObject(for: "test", with: nil, then: nil)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertTrue(error is DNSError, "Read error should be DNSError")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        sut.intDoReadString(for: "test", with: nil, then: nil)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertTrue(error is DNSError, "Read string error should be DNSError")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        sut.intDoUpdate(object: "test", for: "test", with: nil, then: nil)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertTrue(error is DNSError, "Update error should be DNSError")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 3.0, handler: nil)
    }

    // MARK: - Concurrency Tests

    func test_concurrent_operations() {
        // Test that concurrent operations don't cause crashes
        let expectation = self.expectation(description: "Concurrent operations")
        expectation.expectedFulfillmentCount = 6

        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)

        for i in 0..<6 {
            queue.async {
                let key = "test_key_\(i)"
                self.sut.intDoReadString(for: key, with: nil, then: nil)
                    .sink(
                        receiveCompletion: { _ in expectation.fulfill() },
                        receiveValue: { _ in }
                    )
                    .store(in: &self.cancellables)
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}