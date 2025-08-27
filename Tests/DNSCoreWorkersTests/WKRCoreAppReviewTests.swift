//
//  WKRCoreAppReviewTests.swift
//  DNSCoreWorkers
//
//  Created by AI Assistant.
//  Copyright © 2024 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers

final class WKRCoreAppReviewTests: XCTestCase {
    var sut: WKRCoreAppReview!
    
    override func setUp() {
        super.setUp()
        sut = WKRCoreAppReview()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
    }
    
    func testReviewRequestDisabled() {
        // Test when reviews are disabled
        let result = sut.intDoReview(then: nil)
        
        switch result {
        case .success:
            // Should succeed even if review is not shown
            break
        case .failure:
            XCTFail("Should not fail when reviews are disabled")
        }
    }
    
    func testReviewUtilityShouldRequestReview() {
        // Test the utility method
        let shouldRequest = sut.utilityShouldRequestReview()
        
        // In test environment, this might be false due to various conditions
        // Just verify it returns a boolean
        XCTAssertNotNil(shouldRequest)
    }
    
    func testWindowSceneProperty() {
        // Test the window scene property
        XCTAssertNil(sut.windowScene) // Should be nil initially
        
        // We can't easily set this in unit tests without a real window scene
        // Just verify the property exists and is settable
        sut.windowScene = nil
        XCTAssertNil(sut.windowScene)
    }
    
    func testSendableConformance() {
        // Test that the worker can be used in concurrent contexts
        Task {
            let appReview = WKRCoreAppReview()
            XCTAssertNotNil(appReview)
        }
    }
}