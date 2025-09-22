//
//  WKRCoreValidationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSBlankWorkers
import DNSCore
import DNSCrashWorkers
import DNSError
import DNSProtocols
@testable import DNSCoreWorkers

final class WKRCoreValidationTests: XCTestCase {

    private var sut: WKRCoreValidation!

    override func setUp() {
        super.setUp()
        sut = WKRCoreValidation(serviceFactory: TestServiceFactory())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic Tests

    func test_initialization() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut is WKRBlankValidation)
        XCTAssertTrue(sut is WKRPTCLValidation)
    }

    func test_inheritance_hierarchy() {
        XCTAssertTrue(sut is WKRBlankValidation)
    }

    func test_protocol_conformance() {
        XCTAssertNotNil(sut as? WKRPTCLValidation)
    }

    func test_pass_strength_worker_property() {
        XCTAssertNotNil(sut.wkrPassStrength)
        XCTAssertTrue(sut.wkrPassStrength is WKRCrashPassStrength)
    }

    func test_memory_management() {
        weak var weakWorker: WKRCoreValidation?
        autoreleasepool {
            let worker = WKRCoreValidation(serviceFactory: TestServiceFactory())
            weakWorker = worker
            XCTAssertNotNil(weakWorker)
        }
        XCTAssertNil(weakWorker)
    }

    // MARK: - Address Validation Tests

    func test_validateAddress_success() {
        let address = DNSPostalAddress()
        address.street = "123 Main St"
        address.subLocality = "Apt 1"
        address.city = "Test City"
        address.state = "CA"
        address.postalCode = "12345"

        let config = WKRPTCLValidation.Config.Address()
        let result = sut.intDoValidateAddress(for: address, with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Address validation should succeed with valid data")
        }
    }

    func test_validateAddress_nil_address() {
        let config = WKRPTCLValidation.Config.Address()
        let result = sut.intDoValidateAddress(for: nil, with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true) // Should succeed with nil address when not required
        } else {
            XCTFail("Address validation should handle nil address")
        }
    }

    // MARK: - Address City Validation Tests

    func test_validateAddressCity_valid() {
        let config = WKRPTCLValidation.Config.Address.City(fieldName: "city")
        let result = sut.intDoValidateAddressCity(for: "San Francisco", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("City validation should succeed with valid city")
        }
    }

    func test_validateAddressCity_nil() {
        let config = WKRPTCLValidation.Config.Address.City(fieldName: "city")
        let result = sut.intDoValidateAddressCity(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("City validation should fail with nil value")
        }
    }

    func test_validateAddressCity_empty_required() {
        var config = WKRPTCLValidation.Config.Address.City(fieldName: "city")
        config.required = true
        let result = sut.intDoValidateAddressCity(for: "", with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("City validation should fail with empty required field")
        }
    }

    func test_validateAddressCity_length_validation() {
        var config = WKRPTCLValidation.Config.Address.City(fieldName: "city")
        config.minimumLength = 5
        config.maximumLength = 10

        // Test too short
        let shortResult = sut.intDoValidateAddressCity(for: "SF", with: config, then: nil)
        if case .failure = shortResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for too short city")
        }

        // Test too long
        let longResult = sut.intDoValidateAddressCity(for: "Very Long City Name", with: config, then: nil)
        if case .failure = longResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for too long city")
        }

        // Test valid length
        let validResult = sut.intDoValidateAddressCity(for: "Boston", with: config, then: nil)
        if case .success = validResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should succeed for valid length city")
        }
    }

    // MARK: - Email Validation Tests

    func test_validateEmail_valid() {
        let config = WKRPTCLValidation.Config.Email(fieldName: "email")
        let result = sut.intDoValidateEmail(for: "test@example.com", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Email validation should succeed with valid email")
        }
    }

    func test_validateEmail_nil() {
        let config = WKRPTCLValidation.Config.Email(fieldName: "email")
        let result = sut.intDoValidateEmail(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Email validation should fail with nil value")
        }
    }

    func test_validateEmail_empty_required() {
        var config = WKRPTCLValidation.Config.Email(fieldName: "email")
        config.required = true
        let result = sut.intDoValidateEmail(for: "", with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Email validation should fail with empty required field")
        }
    }

    // MARK: - Password Validation Tests

    func test_validatePassword_valid() {
        let config = WKRPTCLValidation.Config.Password(fieldName: "password")
        let result = sut.intDoValidatePassword(for: "ValidPass123!", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Password validation should succeed with valid password")
        }
    }

    func test_validatePassword_nil() {
        let config = WKRPTCLValidation.Config.Password(fieldName: "password")
        let result = sut.intDoValidatePassword(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Password validation should fail with nil value")
        }
    }

    func test_validatePassword_empty_required() {
        var config = WKRPTCLValidation.Config.Password(fieldName: "password")
        config.required = true
        let result = sut.intDoValidatePassword(for: "", with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Password validation should fail with empty required field")
        }
    }

    func test_validatePassword_length_validation() {
        var config = WKRPTCLValidation.Config.Password(fieldName: "password")
        config.minimumLength = 8
        config.maximumLength = 20

        // Test too short
        let shortResult = sut.intDoValidatePassword(for: "123", with: config, then: nil)
        if case .failure = shortResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for too short password")
        }

        // Test too long
        let longPassword = String(repeating: "a", count: 25)
        let longResult = sut.intDoValidatePassword(for: longPassword, with: config, then: nil)
        if case .failure = longResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for too long password")
        }
    }

    // MARK: - Number Validation Tests

    func test_validateNumber_valid() {
        let config = WKRPTCLValidation.Config.Number(fieldName: "number")
        let result = sut.intDoValidateNumber(for: "42", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Number validation should succeed with valid number")
        }
    }

    func test_validateNumber_invalid() {
        let config = WKRPTCLValidation.Config.Number(fieldName: "number")
        let result = sut.intDoValidateNumber(for: "not_a_number", with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Number validation should fail with invalid number")
        }
    }

    func test_validateNumber_range_validation() {
        var config = WKRPTCLValidation.Config.Number(fieldName: "number")
        config.minimum = 10
        config.maximum = 100

        // Test too low
        let lowResult = sut.intDoValidateNumber(for: "5", with: config, then: nil)
        if case .failure = lowResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for number below minimum")
        }

        // Test too high
        let highResult = sut.intDoValidateNumber(for: "150", with: config, then: nil)
        if case .failure = highResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for number above maximum")
        }

        // Test valid range
        let validResult = sut.intDoValidateNumber(for: "50", with: config, then: nil)
        if case .success = validResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should succeed for number in valid range")
        }
    }

    // MARK: - Percentage Validation Tests

    func test_validatePercentage_valid() {
        let config = WKRPTCLValidation.Config.Percentage(fieldName: "percentage")
        let result = sut.intDoValidatePercentage(for: "75.5", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Percentage validation should succeed with valid percentage")
        }
    }

    func test_validatePercentage_invalid() {
        let config = WKRPTCLValidation.Config.Percentage(fieldName: "percentage")
        let result = sut.intDoValidatePercentage(for: "not_a_percentage", with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Percentage validation should fail with invalid percentage")
        }
    }

    // MARK: - Phone Validation Tests

    func test_validatePhone_valid() {
        let config = WKRPTCLValidation.Config.Phone(fieldName: "phone")
        let result = sut.intDoValidatePhone(for: "+1234567890", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Phone validation should succeed with valid phone")
        }
    }

    func test_validatePhone_nil() {
        let config = WKRPTCLValidation.Config.Phone(fieldName: "phone")
        let result = sut.intDoValidatePhone(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Phone validation should fail with nil value")
        }
    }

    // MARK: - Birthdate Validation Tests

    func test_validateBirthdate_valid() {
        let config = WKRPTCLValidation.Config.Birthdate(fieldName: "birthdate")
        let birthdate = Calendar.current.date(byAdding: .year, value: -25, to: Date())
        let result = sut.intDoValidateBirthdate(for: birthdate, with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Birthdate validation should succeed with valid date")
        }
    }

    func test_validateBirthdate_nil() {
        let config = WKRPTCLValidation.Config.Birthdate(fieldName: "birthdate")
        let result = sut.intDoValidateBirthdate(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Birthdate validation should fail with nil value")
        }
    }

    func test_validateBirthdate_age_validation() {
        var config = WKRPTCLValidation.Config.Birthdate(fieldName: "birthdate")
        config.minimumAge = 18
        config.maximumAge = 65

        // Test too young
        let youngDate = Calendar.current.date(byAdding: .year, value: -15, to: Date())
        let youngResult = sut.intDoValidateBirthdate(for: youngDate, with: config, then: nil)
        if case .failure = youngResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for age below minimum")
        }

        // Test too old
        let oldDate = Calendar.current.date(byAdding: .year, value: -70, to: Date())
        let oldResult = sut.intDoValidateBirthdate(for: oldDate, with: config, then: nil)
        if case .failure = oldResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should fail for age above maximum")
        }

        // Test valid age
        let validDate = Calendar.current.date(byAdding: .year, value: -30, to: Date())
        let validResult = sut.intDoValidateBirthdate(for: validDate, with: config, then: nil)
        if case .success = validResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Should succeed for valid age")
        }
    }

    // MARK: - Calendar Date Validation Tests

    func test_validateCalendarDate_valid() {
        let config = WKRPTCLValidation.Config.CalendarDate(fieldName: "date")
        let result = sut.intDoValidateCalendarDate(for: Date(), with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Calendar date validation should succeed with valid date")
        }
    }

    func test_validateCalendarDate_nil() {
        let config = WKRPTCLValidation.Config.CalendarDate(fieldName: "date")
        let result = sut.intDoValidateCalendarDate(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Calendar date validation should fail with nil value")
        }
    }

    // MARK: - Handle Validation Tests

    func test_validateHandle_valid() {
        let config = WKRPTCLValidation.Config.Handle(fieldName: "handle")
        let result = sut.intDoValidateHandle(for: "user123", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Handle validation should succeed with valid handle")
        }
    }

    func test_validateHandle_nil() {
        let config = WKRPTCLValidation.Config.Handle(fieldName: "handle")
        let result = sut.intDoValidateHandle(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Handle validation should fail with nil value")
        }
    }

    // MARK: - Name Validation Tests

    func test_validateName_valid() {
        let config = WKRPTCLValidation.Config.Name(fieldName: "name")
        let result = sut.intDoValidateName(for: "John Doe", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Name validation should succeed with valid name")
        }
    }

    func test_validateName_nil() {
        let config = WKRPTCLValidation.Config.Name(fieldName: "name")
        let result = sut.intDoValidateName(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Name validation should fail with nil value")
        }
    }

    // MARK: - Search Validation Tests

    func test_validateSearch_valid() {
        let config = WKRPTCLValidation.Config.Search(fieldName: "search")
        let result = sut.intDoValidateSearch(for: "search term", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Search validation should succeed with valid search term")
        }
    }

    func test_validateSearch_nil() {
        let config = WKRPTCLValidation.Config.Search(fieldName: "search")
        let result = sut.intDoValidateSearch(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Search validation should fail with nil value")
        }
    }

    // MARK: - State Validation Tests

    func test_validateState_valid() {
        let config = WKRPTCLValidation.Config.State(fieldName: "state")
        let result = sut.intDoValidateState(for: "CA", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("State validation should succeed with valid state")
        }
    }

    func test_validateState_nil() {
        let config = WKRPTCLValidation.Config.State(fieldName: "state")
        let result = sut.intDoValidateState(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("State validation should fail with nil value")
        }
    }

    // MARK: - Unsigned Number Validation Tests

    func test_validateUnsignedNumber_valid() {
        let config = WKRPTCLValidation.Config.UnsignedNumber(fieldName: "number")
        let result = sut.intDoValidateUnsignedNumber(for: "42", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Unsigned number validation should succeed with valid number")
        }
    }

    func test_validateUnsignedNumber_invalid() {
        let config = WKRPTCLValidation.Config.UnsignedNumber(fieldName: "number")
        let result = sut.intDoValidateUnsignedNumber(for: "not_a_number", with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Unsigned number validation should fail with invalid number")
        }
    }

    func test_validateUnsignedNumber_negative() {
        let config = WKRPTCLValidation.Config.UnsignedNumber(fieldName: "number")
        let result = sut.intDoValidateUnsignedNumber(for: "-5", with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Unsigned number validation should fail with negative number")
        }
    }

    // MARK: - Postal Code Validation Tests

    func test_validateAddressPostalCode_valid() {
        let config = WKRPTCLValidation.Config.Address.PostalCode(fieldName: "postalCode")
        let result = sut.intDoValidateAddressPostalCode(for: "12345", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Postal code validation should succeed with valid code")
        }
    }

    func test_validateAddressPostalCode_nil() {
        let config = WKRPTCLValidation.Config.Address.PostalCode(fieldName: "postalCode")
        let result = sut.intDoValidateAddressPostalCode(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Postal code validation should fail with nil value")
        }
    }

    // MARK: - Street Validation Tests

    func test_validateAddressStreet_valid() {
        let config = WKRPTCLValidation.Config.Address.Street(fieldName: "street")
        let result = sut.intDoValidateAddressStreet(for: "123 Main St", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Street validation should succeed with valid street")
        }
    }

    func test_validateAddressStreet_nil() {
        let config = WKRPTCLValidation.Config.Address.Street(fieldName: "street")
        let result = sut.intDoValidateAddressStreet(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Street validation should fail with nil value")
        }
    }

    // MARK: - Street2 Validation Tests

    func test_validateAddressStreet2_valid() {
        let config = WKRPTCLValidation.Config.Address.Street2(fieldName: "street2")
        let result = sut.intDoValidateAddressStreet2(for: "Apt 1", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Street2 validation should succeed with valid street2")
        }
    }

    func test_validateAddressStreet2_nil() {
        let config = WKRPTCLValidation.Config.Address.Street2(fieldName: "street2")
        let result = sut.intDoValidateAddressStreet2(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Street2 validation should fail with nil value")
        }
    }

    // MARK: - State Address Validation Tests

    func test_validateAddressState_valid() {
        let config = WKRPTCLValidation.Config.Address.State(fieldName: "state")
        let result = sut.intDoValidateAddressState(for: "CA", with: config, then: nil)

        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail("Address state validation should succeed with valid state")
        }
    }

    func test_validateAddressState_nil() {
        let config = WKRPTCLValidation.Config.Address.State(fieldName: "state")
        let result = sut.intDoValidateAddressState(for: nil, with: config, then: nil)

        if case .failure(let error) = result {
            XCTAssertTrue(error is DNSError)
        } else {
            XCTFail("Address state validation should fail with nil value")
        }
    }
}