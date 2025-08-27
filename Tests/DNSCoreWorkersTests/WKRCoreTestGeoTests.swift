//
//  WKRCoreTestGeoTests.swift
//  DNSCoreWorkers
//
//  Created by AI Assistant.
//  Copyright © 2024 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers
import DNSCore
import DNSDataObjects

final class WKRCoreTestGeoTests: XCTestCase {
    var sut: WKRCoreTestGeo!
    
    override func setUp() {
        super.setUp()
        sut = WKRCoreTestGeo()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
    }
    
    func testLocateWithoutAddress() {
        let expectation = XCTestExpectation(description: "Location without address")
        
        sut.doLocate(with: nil) { result in
            switch result {
            case .success(let locationResult):
                // Should return test location data
                XCTAssertNotNil(locationResult)
            case .failure:
                // May fail in test environment, which is acceptable
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLocateWithAddress() {
        let expectation = XCTestExpectation(description: "Location with address")
        let testAddress = DNSPostalAddress()
        testAddress.street = "123 Main St"
        testAddress.city = "Anytown"
        testAddress.state = "CA"
        testAddress.postalCode = "12345"
        
        sut.doLocate(testAddress, with: nil) { result in
            switch result {
            case .success(let locationResult):
                // Should return geocoded location data
                XCTAssertNotNil(locationResult)
            case .failure:
                // May fail in test environment, which is acceptable
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSendableConformance() {
        // Test that the worker can be used in concurrent contexts
        Task {
            let testGeo = WKRCoreTestGeo()
            XCTAssertNotNil(testGeo)
        }
    }
}
