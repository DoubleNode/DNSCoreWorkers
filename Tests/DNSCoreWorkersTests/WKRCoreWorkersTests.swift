//
//  WKRCoreWorkersTests.swift
//  DoubleNode Swift Framework (DNSFramework) - WKRCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//  Enhanced by AI Assistant.
//

import XCTest
@testable import DNSCoreWorkers
import DNSBlankWorkers

final class WKRCoreWorkersTests: XCTestCase {
    
    func testCoreWorkersIntegration() {
        // Test that core workers can be instantiated
        let appReview = WKRCoreAppReview()
        let passStrength = WKRCorePassStrength()
        let keychainCache = WKRCoreKeychainCache()
        let testGeo = WKRCoreTestGeo()
        let validation = WKRCoreValidation()
        
        XCTAssertNotNil(appReview)
        XCTAssertNotNil(passStrength)
        XCTAssertNotNil(keychainCache)
        XCTAssertNotNil(testGeo)
        XCTAssertNotNil(validation)
    }
    
    func testCoreWorkersInheritance() {
        // Test that workers inherit from their base classes
        let appReview = WKRCoreAppReview()
        let passStrength = WKRCorePassStrength()
        let keychainCache = WKRCoreKeychainCache()
        let testGeo = WKRCoreTestGeo()
        let validation = WKRCoreValidation()
        
        XCTAssertTrue(appReview is WKRBlankAppReview)
        XCTAssertTrue(passStrength is WKRBlankPassStrength)
        XCTAssertTrue(keychainCache is WKRBlankCache)
        XCTAssertTrue(testGeo is WKRBlankGeo)
        XCTAssertTrue(validation is WKRBlankValidation)
    }
    
    func testSendableConformance() {
        // Test that workers conform to Sendable for concurrency safety
        let appReview = WKRCoreAppReview()
        let passStrength = WKRCorePassStrength()
        let keychainCache = WKRCoreKeychainCache()
        
        // Basic test that these can be used in concurrent contexts
        Task {
            XCTAssertNotNil(appReview)
            XCTAssertNotNil(passStrength)
            XCTAssertNotNil(keychainCache)
        }
    }
    
    func testModuleImport() {
        // Verify that the module imports work correctly
        XCTAssertNotNil(DNSCoreWorkersCodeLocation.domainPreface)
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testCoreWorkersIntegration", testCoreWorkersIntegration),
        ("testCoreWorkersInheritance", testCoreWorkersInheritance),
        ("testSendableConformance", testSendableConformance),
        ("testModuleImport", testModuleImport),
    ]
}
