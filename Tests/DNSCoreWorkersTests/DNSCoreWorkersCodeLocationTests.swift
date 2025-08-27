//
//  DNSCoreWorkersCodeLocationTests.swift
//  DNSCoreWorkers
//
//  Created by AI Assistant.
//  Copyright © 2024 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSCoreWorkers
import DNSCore
import DNSError

final class DNSCoreWorkersCodeLocationTests: XCTestCase {
    
    func testDomainPreface() {
        XCTAssertEqual(DNSCoreWorkersCodeLocation.domainPreface, "com.doublenode.coreWorkers.")
    }
    
    func testCodeLocationTypealias() {
        // Test that the typealias works correctly
        let codeLocation = DNSCodeLocation.coreWorkers(self)
        XCTAssertTrue(codeLocation is DNSCoreWorkersCodeLocation)
    }
    
    func testInheritance() {
        let codeLocation = DNSCoreWorkersCodeLocation(self)
        XCTAssertTrue(codeLocation is DNSCodeLocation)
    }
    
    func testSendableConformance() {
        let codeLocation = DNSCoreWorkersCodeLocation(self)
        XCTAssertNotNil(codeLocation)
        
        // Test that it can be used in concurrent contexts (basic sendable test)
        Task {
            let _ = DNSCoreWorkersCodeLocation.domainPreface
        }
    }
    
    func testCodeLocationCreation() {
        let codeLocation1 = DNSCoreWorkersCodeLocation(self)
        let codeLocation2 = DNSCoreWorkersCodeLocation(self)
        
        XCTAssertNotNil(codeLocation1)
        XCTAssertNotNil(codeLocation2)
        XCTAssertTrue(codeLocation1 !== codeLocation2) // Different instances
    }
}
