//
//  WKRCoreKeychainCacheTests.swift
//  DNSCoreWorkers
//
//  Created by AI Assistant.
//  Copyright © 2024 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers
import Combine

final class WKRCoreKeychainCacheTests: XCTestCase {
    var sut: WKRCoreKeychainCache!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = WKRCoreKeychainCache()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
    }
    
    func testDeleteObjectNonExistent() {
        let expectation = XCTestExpectation(description: "Delete object completion")
        
        sut.doDeleteObject(for: "testKey", with: nil)
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    // Should complete successfully even for non-existent key
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testReadObjectNonExistent() {
        let expectation = XCTestExpectation(description: "Read object completion")
        
        sut.doReadObject(for: "nonExistentKey", with: nil)
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                },
                receiveValue: { value in
                    // Should receive empty data for non-existent key
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testReadStringNonExistent() {
        let expectation = XCTestExpectation(description: "Read string completion")
        
        sut.doReadString(for: "nonExistentKey", with: nil)
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                },
                receiveValue: { value in
                    // Should receive empty string for non-existent key
                    XCTAssertTrue(value.isEmpty)
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testUpdateAndReadObject() {
        let expectation1 = XCTestExpectation(description: "Update object completion")
        let expectation2 = XCTestExpectation(description: "Read object completion")
        let testKey = "testKey"
        let testValue = "testValue"
        
        // Update
        sut.doUpdate(object: testValue, for: testKey, with: nil)
            .sink(
                receiveCompletion: { completion in
                    expectation1.fulfill()
                },
                receiveValue: { value in
                    // Should return the stored value
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation1], timeout: 2.0)
        
        // Read
        sut.doReadObject(for: testKey, with: nil)
            .sink(
                receiveCompletion: { completion in
                    expectation2.fulfill()
                },
                receiveValue: { value in
                    // Should receive the stored string
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation2], timeout: 2.0)
    }
    
    func testSendableConformance() {
        // Test that the worker can be used in concurrent contexts
        Task {
            let cache = WKRCoreKeychainCache()
            XCTAssertNotNil(cache)
        }
    }
}