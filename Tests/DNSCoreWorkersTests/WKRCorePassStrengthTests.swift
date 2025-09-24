//
//  WKRCorePassStrengthTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSBlankWorkers
import DNSProtocols
@testable import DNSCoreWorkers

final class WKRCorePassStrengthTests: XCTestCase {

    private var sut: WKRCorePassStrength!

    override func setUp() {
        super.setUp()
        sut = WKRCorePassStrength(serviceFactory: TestServiceFactory())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic Tests

    func test_initialization() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut is WKRBasePassStrength)
        XCTAssertTrue(sut is WKRPTCLPassStrength)
    }

    func test_inheritance_hierarchy() {
        XCTAssertTrue(sut is WKRBasePassStrength)
    }

    func test_protocol_conformance() {
        XCTAssertNotNil(sut as? WKRPTCLPassStrength)
    }

    func test_memory_management() {
        weak var weakWorker: WKRCorePassStrength?
        autoreleasepool {
            let worker = WKRCorePassStrength()
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker)
    }

    // MARK: - Property Tests

    func test_minimum_length_default() {
        XCTAssertEqual(sut.minimunLength, 8)
    }

    func test_minimum_length_can_be_modified() {
        sut.minimunLength = 12
        XCTAssertEqual(sut.minimunLength, 12)
    }

    func test_regex_patterns_exist() {
        // Test that regex patterns are defined as expected
        XCTAssertEqual(sut.regexOneUppercase, "^(?=.*[A-Z]).*$")
        XCTAssertEqual(sut.regexOneLowercase, "^(?=.*[a-z]).*$")
        XCTAssertEqual(sut.regexOneNumber, "^(?=.*[0-9]).*$")
        XCTAssertEqual(sut.regexOneSymbol, "^(?=.*[!@#$%&_]).*$")
    }

    func test_regex_patterns_not_empty() {
        XCTAssertFalse(sut.regexOneUppercase.isEmpty)
        XCTAssertFalse(sut.regexOneLowercase.isEmpty)
        XCTAssertFalse(sut.regexOneNumber.isEmpty)
        XCTAssertFalse(sut.regexOneSymbol.isEmpty)
    }

    // MARK: - Password Strength Tests - Empty and Basic

    func test_empty_password_is_weak() {
        let result = sut.intDoCheckPassStrength(for: "", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.weak)
        } else {
            XCTFail("Empty password should return weak strength")
        }
    }

    func test_very_short_password_is_weak() {
        let result = sut.intDoCheckPassStrength(for: "a", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.weak)
        } else {
            XCTFail("Very short password should return weak strength")
        }
    }

    func test_short_simple_password_is_weak() {
        let result = sut.intDoCheckPassStrength(for: "abc", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.weak)
        } else {
            XCTFail("Short simple password should return weak strength")
        }
    }

    // MARK: - Password Strength Tests - Weak Passwords

    func test_lowercase_only_password_is_weak() {
        let result = sut.intDoCheckPassStrength(for: "password", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.weak)
        } else {
            XCTFail("Lowercase only password should return weak strength")
        }
    }

    func test_uppercase_only_password_is_weak() {
        let result = sut.intDoCheckPassStrength(for: "PASSWORD", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.weak)
        } else {
            XCTFail("Uppercase only password should return weak strength")
        }
    }

    func test_numbers_only_password_is_weak() {
        let result = sut.intDoCheckPassStrength(for: "12345678", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.weak)
        } else {
            XCTFail("Numbers only password should return weak strength")
        }
    }

    // MARK: - Password Strength Tests - Moderate Passwords

    func test_mixed_case_password_is_moderate() {
        let result = sut.intDoCheckPassStrength(for: "Password", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.moderate)
        } else {
            XCTFail("Mixed case password should return moderate strength")
        }
    }

    func test_letters_and_numbers_password_is_moderate() {
        let result = sut.intDoCheckPassStrength(for: "password123", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.moderate)
        } else {
            XCTFail("Letters and numbers password should return moderate strength")
        }
    }

    func test_mixed_case_and_numbers_password_is_moderate() {
        let result = sut.intDoCheckPassStrength(for: "Password123", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.moderate)
        } else {
            XCTFail("Mixed case and numbers password should return moderate strength")
        }
    }

    // MARK: - Password Strength Tests - Strong Passwords

    func test_full_complexity_password_is_strong() {
        let result = sut.intDoCheckPassStrength(for: "Password123!", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.strong)
        } else {
            XCTFail("Full complexity password should return strong strength")
        }
    }

    func test_long_complex_password_is_strong() {
        let result = sut.intDoCheckPassStrength(for: "MyVerySecurePassword123!", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.strong)
        } else {
            XCTFail("Long complex password should return strong strength")
        }
    }

    func test_strong_password_with_different_symbols() {
        let passwords = [
            "Password123@",
            "Password123#",
            "Password123$",
            "Password123%",
            "Password123&",
            "Password123_"
        ]

        for password in passwords {
            let result = sut.intDoCheckPassStrength(for: password, then: nil)

            if case .success(let strength) = result {
                XCTAssertEqual(strength, .strong, "Password \(password) should be strong")
            } else {
                XCTFail("Password \(password) should return strong strength")
            }
        }
    }

    // MARK: - Length-based Strength Tests

    func test_minimum_length_affects_strength() {
        sut.minimunLength = 10

        // Password shorter than minimum length (but has other complexity)
        let shortResult = sut.intDoCheckPassStrength(for: "Pass123!", then: nil)
        if case .success(let shortStrength) = shortResult {
            XCTAssertNotEqual(shortStrength, WKRPTCLPassStrengthLevel.strong, "Short password should not be strongest when below minimum")
        }

        // Password meeting minimum length
        let longResult = sut.intDoCheckPassStrength(for: "Password123!", then: nil)
        if case .success(let longStrength) = longResult {
            XCTAssertEqual(longStrength, WKRPTCLPassStrengthLevel.strong, "Long password should be strong when meeting minimum")
        }
    }

    func test_very_long_password_gets_bonus() {
        // Password over 10 characters gets extra point
        let result = sut.intDoCheckPassStrength(for: "VeryLongPassword123!", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.strong)
        } else {
            XCTFail("Very long password should return strong strength")
        }
    }

    // MARK: - Edge Case Tests

    func test_password_with_unsupported_symbols() {
        // Symbols not in the regex pattern
        let result = sut.intDoCheckPassStrength(for: "Password123+", then: nil)

        if case .success(let strength) = result {
            // Should not get the symbol bonus
            XCTAssertNotEqual(strength, .strong)
        } else {
            XCTFail("Password with unsupported symbols should still be evaluated")
        }
    }

    func test_password_with_spaces() {
        let result = sut.intDoCheckPassStrength(for: "Pass Word 123!", then: nil)

        if case .success(let strength) = result {
            XCTAssertEqual(strength, WKRPTCLPassStrengthLevel.strong)
        } else {
            XCTFail("Password with spaces should be evaluated normally")
        }
    }

    func test_unicode_password() {
        let result = sut.intDoCheckPassStrength(for: "Pässwörd123!", then: nil)

        if case .success(let strength) = result {
            // Should handle unicode characters
            XCTAssertNotNil(strength)
        } else {
            XCTFail("Unicode password should be evaluated")
        }
    }

    // MARK: - Utility Method Tests

    func test_utility_validate_uppercase() {
        let count = sut.utilityValidate(string: "Password", with: sut.regexOneUppercase, caseSensitive: true)
        XCTAssertEqual(count, 1)
    }

    func test_utility_validate_lowercase() {
        let count = sut.utilityValidate(string: "Password", with: sut.regexOneLowercase, caseSensitive: true)
        XCTAssertEqual(count, 1)
    }

    func test_utility_validate_numbers() {
        let count = sut.utilityValidate(string: "Password123", with: sut.regexOneNumber, caseSensitive: true)
        XCTAssertEqual(count, 1)
    }

    func test_utility_validate_symbols() {
        let count = sut.utilityValidate(string: "Password!", with: sut.regexOneSymbol, caseSensitive: true)
        XCTAssertEqual(count, 1)
    }

    func test_utility_validate_no_match() {
        let count = sut.utilityValidate(string: "password", with: sut.regexOneUppercase, caseSensitive: true)
        XCTAssertEqual(count, 0)
    }

    func test_utility_validate_case_insensitive() {
        let count = sut.utilityValidate(string: "password", with: sut.regexOneUppercase, caseSensitive: false)
        XCTAssertEqual(count, 1)
    }

    func test_utility_validate_invalid_regex() {
        // Test with invalid regex pattern
        let count = sut.utilityValidate(string: "test", with: "[invalid", caseSensitive: true)
        XCTAssertEqual(count, 0, "Invalid regex should return 0 matches")
    }

    func test_utility_validate_empty_string() {
        let count = sut.utilityValidate(string: "", with: sut.regexOneUppercase, caseSensitive: true)
        XCTAssertEqual(count, 0)
    }

    func test_utility_validate_empty_pattern() {
        let count = sut.utilityValidate(string: "test", with: "", caseSensitive: true)
        XCTAssertEqual(count, 0)
    }

    // MARK: - Result Block Tests

    func test_result_block_called() {
        var resultBlockCalled = false

        let result = sut.intDoCheckPassStrength(for: "Password123!") { result in
            resultBlockCalled = true
        }

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Password strength check should succeed")
        }

        XCTAssertTrue(resultBlockCalled, "Result block should be called")
    }

    func test_result_block_nil() {
        // Should not crash with nil result block
        let result = sut.intDoCheckPassStrength(for: "Password123!", then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Password strength check should succeed with nil result block")
        }
    }

    // MARK: - Comprehensive Strength Analysis Tests

    func test_strength_progression() {
        let passwords = [
            ("", WKRPTCLPassStrengthLevel.weak),
            ("a", WKRPTCLPassStrengthLevel.weak),
            ("password", WKRPTCLPassStrengthLevel.weak),
            ("Password", WKRPTCLPassStrengthLevel.moderate),
            ("password123", WKRPTCLPassStrengthLevel.moderate),
            ("Password123", WKRPTCLPassStrengthLevel.moderate),
            ("Password123!", WKRPTCLPassStrengthLevel.strong)
        ]

        for (password, expectedStrength) in passwords {
            let result = sut.intDoCheckPassStrength(for: password, then: nil)

            if case .success(let strength) = result {
                XCTAssertEqual(strength, expectedStrength,
                             "Password '\(password)' should have strength \(expectedStrength), got \(strength)")
            } else {
                XCTFail("Password strength check should succeed for '\(password)'")
            }
        }
    }

    func test_multiple_instances_independent() {
        let worker1 = WKRCorePassStrength()
        let worker2 = WKRCorePassStrength()

        worker1.minimunLength = 6
        worker2.minimunLength = 10

        XCTAssertNotEqual(worker1.minimunLength, worker2.minimunLength)
        XCTAssertFalse(worker1 === worker2)
    }
}
