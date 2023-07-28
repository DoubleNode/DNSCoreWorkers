//
//  WKRCoreValidation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSBlankWorkers
import DNSCore
import DNSCrashWorkers
import DNSError
import DNSProtocols
import Foundation

open class WKRCoreValidation: WKRBlankValidation {
    public var wkrPassStrength: WKRPTCLPassStrength = WKRCrashPassStrength()

    // MARK: - Internal Work Methods
    override open func intDoValidateAddress(for address: DNSPostalAddress?,
                                            with config: Config.Address,
                                            then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        let streetResult = self.intDoValidateAddressStreet(for: address?.street ?? "", with: config.street, then: nil)
        guard case .success = streetResult else { return streetResult }
        let street2Result = self.intDoValidateAddressStreet2(for: address?.subLocality ?? "", with: config.street2, then: nil)
        guard case .success = street2Result else { return street2Result }
        let cityResult = self.intDoValidateAddressCity(for: address?.city ?? "", with: config.city, then: nil)
        guard case .success = cityResult else { return cityResult }
        let stateResult = self.intDoValidateAddressState(for: address?.state ?? "", with: config.state, then: nil)
        guard case .success = stateResult else { return stateResult }
        let postalCodeResult = self.intDoValidateAddressPostalCode(for: address?.postalCode ?? "", with: config.postalCode, then: nil)
        guard case .success = postalCodeResult else { return postalCodeResult }
        return .success
    }
    override open func intDoValidateAddressCity(for city: String?,
                                                with config: Config.Address.City,
                                                then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let city = city else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !city.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || city.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || city.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || city.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateAddressPostalCode(for postalCode: String?,
                                                      with config: Config.Address.PostalCode,
                                                      then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let postalCode = postalCode else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !postalCode.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || postalCode.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || postalCode.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || postalCode.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateAddressState(for state: String?,
                                                 with config: Config.Address.State,
                                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let state = state else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !state.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || state.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || state.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || state.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateAddressStreet(for street: String?,
                                                  with config: Config.Address.Street,
                                                  then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let street = street else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !street.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || street.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || street.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || street.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateAddressStreet2(for street2: String?,
                                                   with config: Config.Address.Street2,
                                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let street2 = street2 else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !street2.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || street2.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || street2.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || street2.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateBirthdate(for birthdate: Date?,
                                              with config: Config.Birthdate,
                                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let birthdate = birthdate else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        let age = birthdate.dnsAge()
        guard config.minimumAge == nil || age.year >= config.minimumAge! else {
            return .failure(DNSError.Validation
                .tooLow(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumAge == nil || age.year <= config.maximumAge! else {
            return .failure(DNSError.Validation
                .tooHigh(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateCalendarDate(for calendarDate: Date?,
                                                 with config: Config.CalendarDate,
                                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let calendarDate = calendarDate else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimum == nil || calendarDate >= config.minimum! else {
            return .failure(DNSError.Validation
                .tooLow(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximum == nil || calendarDate <= config.maximum! else {
            return .failure(DNSError.Validation
                .tooHigh(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateEmail(for email: String?,
                                          with config: Config.Email,
                                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let email = email else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !email.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || email.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateHandle(for handle: String?,
                                           with config: Config.Handle,
                                           then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let handle = handle else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !handle.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || handle.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || handle.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || handle.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateName(for name: String?,
                                         with config: Config.Name,
                                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let name = name else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !name.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || name.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || name.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || name.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateNumber(for numberString: String?,
                                           with config: Config.Number,
                                           then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let number = Int64(numberString ?? "") else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimum == nil || number >= config.minimum! else {
            return .failure(DNSError.Validation
                .tooLow(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximum == nil || number <= config.maximum! else {
            return .failure(DNSError.Validation
                .tooHigh(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidatePassword(for password: String?,
                                             with config: Config.Password,
                                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let password = password else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !password.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || password.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || password.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        let result = self.wkrPassStrength.doCheckPassStrength(for: password)
        if case .failure(let error) = result {
            return .failure(error)
        }
        if case .success(let strength) = result {
            guard strength.rawValue >= config.strength.rawValue else {
                return .failure(DNSError.Validation
                    .tooWeak(fieldName: config.fieldName, .coreWorkers(self)))
            }
        }
        return .success
    }
    override open func intDoValidatePercentage(for percentageString: String?,
                                               with config: Config.Percentage,
                                               then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let percentage = Float(percentageString ?? "") else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimum == nil || percentage >= config.minimum! else {
            return .failure(DNSError.Validation
                .tooLow(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximum == nil || percentage <= config.maximum! else {
            return .failure(DNSError.Validation
                .tooHigh(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidatePhone(for phone: String?,
                                          with config: Config.Phone,
                                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let phone = phone else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !phone.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || phone.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || phone.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || phone.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateSearch(for search: String?,
                                           with config: Config.Search,
                                           then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let search = search else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !search.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || search.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || search.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || search.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateState(for state: String?,
                                          with config: Config.State,
                                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let state = state else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard !config.required || !state.isEmpty else {
            return .failure(DNSError.Validation
                .required(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimumLength == nil || state.count >= config.minimumLength! else {
            return .failure(DNSError.Validation
                .tooShort(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximumLength == nil || state.count <= config.maximumLength! else {
            return .failure(DNSError.Validation
                .tooLong(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.regex == nil || state.dnsCheck(regEx: config.regex!) else {
            return .failure(DNSError.Validation
                .invalid(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
    override open func intDoValidateUnsignedNumber(for numberString: String?,
                                                   with config: Config.UnsignedNumber,
                                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        guard let number = UInt64(numberString ?? "") else {
            return .failure(DNSError.Validation
                .noValue(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.minimum == nil || number >= config.minimum! else {
            return .failure(DNSError.Validation
                .tooLow(fieldName: config.fieldName, .coreWorkers(self)))
        }
        guard config.maximum == nil || number <= config.maximum! else {
            return .failure(DNSError.Validation
                .tooHigh(fieldName: config.fieldName, .coreWorkers(self)))
        }
        return .success
    }
}
