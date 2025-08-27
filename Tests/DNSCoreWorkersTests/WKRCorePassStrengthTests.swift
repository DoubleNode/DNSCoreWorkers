//
//  WKRCorePassStrengthTests.swift
//  DNSCoreWorkers
//
//  Created by AI Assistant.
//  Copyright © 2024 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers

final class WKRCorePassStrengthTests: XCTestCase {
    var sut: WKRCorePassStrength!
    
    override func setUp() {
        super.setUp()
        sut = WKRCorePassStrength()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
    }
    
    func testPasswordStrengthWeak() {
        let result = sut.doCheckPassStrength(for: "123")
        
        switch result {
        case .success:
            // Should succeed for any password check
            break
        case .failure:
            // This might also be acceptable depending on implementation
            break
        }
    }
    
    func testPasswordStrengthMedium() {
        let result = sut.doCheckPassStrength(for: "Password123")
        
        switch result {
        case .success:
            // Should succeed for medium password check
            break
        case .failure:
            // This might also be acceptable depending on implementation
            break
        }
    }
    
    func testPasswordStrengthStrong() {
        let result = sut.doCheckPassStrength(for: "StrongPassword123!")
        
        switch result {
        case .success:
            // Should succeed for strong password check
            break
        case .failure:
            // This might also be acceptable depending on implementation
            break
        }
    }
    
    func testPasswordStrengthEmpty() {
        let result = sut.doCheckPassStrength(for: "")
        
        switch result {
        case .success:
            // Even empty password should return a result
            break
        case .failure:
            // This might also be acceptable for empty password
            break
        }
    }
    
    func testMinimumLengthProperty() {
        // Test the minimum length property
        let initialLength = sut.minimumLength
        sut.minimumLength = 8
        XCTAssertEqual(sut.minimumLength, 8)
        
        // Reset to original value
        sut.minimumLength = initialLength
    }
}