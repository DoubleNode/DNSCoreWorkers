//
//  ServiceProtocols.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation
#if !TESTING
import CoreLocation
import Valet
#else
// MARK: - Test-only type aliases for missing CoreLocation types
public typealias CLLocationManagerDelegate = AnyObject
public typealias CLLocationAccuracy = Double
public enum CLAuthorizationStatus: Int {
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorizedAlways = 3
    case authorizedWhenInUse = 4
}
public typealias Accessibility = Int
public struct Identifier {
    let value: String
    public init?(nonEmpty: String) {
        guard !nonEmpty.isEmpty else { return nil }
        self.value = nonEmpty
    }
}
#endif

// MARK: - Location Service Abstraction
public protocol LocationServiceProtocol {
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var allowsBackgroundLocationUpdates: Bool { get set }

    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func authorizationStatus() -> CLAuthorizationStatus
    func locationServicesEnabled() -> Bool
}

// MARK: - Cache Service Abstraction
public protocol CacheServiceProtocol {
    func containsObject(forKey key: String) throws -> Bool
    func object(forKey key: String) throws -> Data
    func string(forKey key: String) throws -> String?
    func setString(_ string: String, forKey key: String) throws
    func setObject(_ object: Data, forKey key: String) throws
    func removeObject(forKey key: String) throws
}

// MARK: - Secure Cache Service Abstraction
public protocol SecureCacheServiceProtocol: CacheServiceProtocol {
    func requirePromptOnNextAccess(forKey key: String) throws
}

// MARK: - Permission Service Abstraction
public protocol PermissionServiceProtocol {
    func requestPermission(for type: String, completion: @escaping (Bool) -> Void)
    func permissionStatus(for type: String) -> String
    func openSettings()
}

// MARK: - App Review Service Abstraction
public protocol AppReviewServiceProtocol {
    func requestReview()
    func canRequestReview() -> Bool
}

// MARK: - Service Factory Protocol
public protocol ServiceFactoryProtocol {
    func makeLocationService() -> LocationServiceProtocol
    func makeCacheService(identifier: String) -> CacheServiceProtocol
    func makeSecureCacheService(identifier: String) -> SecureCacheServiceProtocol
    func makePermissionService() -> PermissionServiceProtocol
    func makeAppReviewService() -> AppReviewServiceProtocol
}