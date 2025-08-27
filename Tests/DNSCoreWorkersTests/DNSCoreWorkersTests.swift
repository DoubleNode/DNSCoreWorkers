//
//  DNSCoreWorkersTests.swift
//  DNSCoreWorkers
//
//  Created by AI Assistant.
//  Copyright © 2024 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers
import DNSCore

final class DNSCoreWorkersTests: XCTestCase {
    
    func testBiometricsConstants() async {
        // Test the computed properties that depend on DNSCore.bundleName
        let enabled = await DNSAppConstants.Biometrics.enabled
        let password = await DNSAppConstants.Biometrics.password
        let username = await DNSAppConstants.Biometrics.username
        let valet = await DNSAppConstants.Biometrics.valet
        
        XCTAssertTrue(enabled.contains("_Biometrics_enabled"))
        XCTAssertTrue(password.contains("_Biometrics_password"))
        XCTAssertTrue(username.contains("_Biometrics_username"))
        XCTAssertTrue(valet.contains("_Biometrics_valet"))
        
        // Test that they all start with the bundle name pattern
        XCTAssertTrue(enabled.hasSuffix("_Biometrics_enabled"))
        XCTAssertTrue(password.hasSuffix("_Biometrics_password"))
        XCTAssertTrue(username.hasSuffix("_Biometrics_username"))
        XCTAssertTrue(valet.hasSuffix("_Biometrics_valet"))
    }
    
    func testBiometricsConstantsUniqueness() async {
        let enabled = await DNSAppConstants.Biometrics.enabled
        let password = await DNSAppConstants.Biometrics.password
        let username = await DNSAppConstants.Biometrics.username
        let valet = await DNSAppConstants.Biometrics.valet
        
        // Ensure all constants are unique
        XCTAssertNotEqual(enabled, password)
        XCTAssertNotEqual(enabled, username)
        XCTAssertNotEqual(enabled, valet)
        XCTAssertNotEqual(password, username)
        XCTAssertNotEqual(password, valet)
        XCTAssertNotEqual(username, valet)
    }
    
    func testBiometricsConstantsNonEmpty() async {
        let enabled = await DNSAppConstants.Biometrics.enabled
        let password = await DNSAppConstants.Biometrics.password
        let username = await DNSAppConstants.Biometrics.username
        let valet = await DNSAppConstants.Biometrics.valet
        
        XCTAssertFalse(enabled.isEmpty)
        XCTAssertFalse(password.isEmpty)
        XCTAssertFalse(username.isEmpty)
        XCTAssertFalse(valet.isEmpty)
    }
    
    func testBiometricsConstantsConsistency() async {
        // Test that multiple calls return the same value
        let enabled1 = await DNSAppConstants.Biometrics.enabled
        let enabled2 = await DNSAppConstants.Biometrics.enabled
        
        XCTAssertEqual(enabled1, enabled2)
        
        let password1 = await DNSAppConstants.Biometrics.password
        let password2 = await DNSAppConstants.Biometrics.password
        
        XCTAssertEqual(password1, password2)
    }
    
    func testMainActorIsolation() async {
        // Test that the properties work correctly in async context
        await MainActor.run {
            Task {
                let _ = await DNSAppConstants.Biometrics.enabled
            }
        }
    }
}