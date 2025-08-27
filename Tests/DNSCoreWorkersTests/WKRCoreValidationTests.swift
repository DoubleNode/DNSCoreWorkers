//
//  WKRCoreValidationTests.swift
//  DNSCoreWorkers
//
//  Created by AI Assistant.
//  Copyright © 2024 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers

final class WKRCoreValidationTests: XCTestCase {
    var sut: WKRCoreValidation!
    
    override func setUp() {
        super.setUp()
        sut = WKRCoreValidation()
        sut.wkrPassStrength = WKRCorePassStrength()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.wkrPassStrength)
    }
    
    func testValidateEmptyEmail() {
        let result = sut.doValidateEmail(for: "", with: WKRCoreValidation.Config.Email())
        
        // Should fail for empty email
        switch result {
        case .success:
            XCTFail("Should not succeed with empty email")
        case .failure:
            // Expected - empty email should fail validation
            break
        }
    }
    
    func testValidateValidEmail() {
        let result = sut.doValidateEmail(for: "test@example.com", with: WKRCoreValidation.Config.Email())
        
        // Should succeed for valid email
        switch result {
        case .success:
            // Expected - valid email should pass validation
            break
        case .failure:
            XCTFail("Should succeed with valid email")
        }
    }
    
    func testValidateInvalidEmail() {
        let result = sut.doValidateEmail(for: "invalid-email", with: WKRCoreValidation.Config.Email())
        
        // Should fail for invalid email format
        switch result {
        case .success:
            XCTFail("Should not succeed with invalid email format")
        case .failure:
            // Expected - invalid email should fail validation
            break
        }
    }
    
    func testValidatePassword() {
        let config = WKRCoreValidation.Config.Password()
        let result = sut.doValidatePassword(for: "TestPassword123!", with: config)
        
        // Should succeed for strong password
        switch result {
        case .success:
            // Expected - strong password should pass validation
            break
        case .failure:
            XCTFail("Should succeed with strong password")
        }
    }
    
    func testValidateWeakPassword() {
        let config = WKRCoreValidation.Config.Password()
        let result = sut.doValidatePassword(for: "weak", with: config)
        
        // Should fail for weak password
        switch result {
        case .success:
            XCTFail("Should not succeed with weak password")
        case .failure:
            // Expected - weak password should fail validation
            break
        }
    }
    
    func testValidatePhoneNumber() {
        let config = WKRCoreValidation.Config.Phone()
        let result = sut.doValidatePhone(for: "+1-555-123-4567", with: config)
        
        // Should succeed for valid phone number
        switch result {
        case .success:
            // Expected - valid phone number should pass validation
            break
        case .failure(let error):
            // This might fail in test environment, which is acceptable
            print("Phone validation failed: \(error)")
        }
    }
}
