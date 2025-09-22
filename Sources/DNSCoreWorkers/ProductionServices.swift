//
//  ProductionServices.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation
#if !TESTING
import CoreLocation
import StoreKit
import UIKit
import Valet
#endif

#if !TESTING
// MARK: - Production Location Service
public class ProductionLocationService: LocationServiceProtocol {
    private let locationManager = CLLocationManager()

    public var delegate: CLLocationManagerDelegate? {
        get { locationManager.delegate }
        set { locationManager.delegate = newValue }
    }

    public var desiredAccuracy: CLLocationAccuracy {
        get { locationManager.desiredAccuracy }
        set { locationManager.desiredAccuracy = newValue }
    }

    public var allowsBackgroundLocationUpdates: Bool {
        get { locationManager.allowsBackgroundLocationUpdates }
        set { locationManager.allowsBackgroundLocationUpdates = newValue }
    }

    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    public func authorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }

    public func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}
#endif

#if !TESTING
// MARK: - Production Cache Service (Valet)
public class ProductionCacheService: CacheServiceProtocol {
    private let valet: Valet

    public init(identifier: String, accessibility: Accessibility = .whenUnlocked) {
        self.valet = Valet.valet(with: Identifier(nonEmpty: identifier)!,
                                accessibility: accessibility)
    }

    public func containsObject(forKey key: String) throws -> Bool {
        return try valet.containsObject(forKey: key)
    }

    public func object(forKey key: String) throws -> Data {
        return try valet.object(forKey: key)
    }

    public func string(forKey key: String) throws -> String? {
        return try valet.string(forKey: key)
    }

    public func setString(_ string: String, forKey key: String) throws {
        try valet.setString(string, forKey: key)
    }

    public func setObject(_ object: Data, forKey key: String) throws {
        try valet.setObject(object, forKey: key)
    }

    public func removeObject(forKey key: String) throws {
        try valet.removeObject(forKey: key)
    }
}
#endif

#if !TESTING
// MARK: - Production Secure Cache Service (Secure Enclave)
public class ProductionSecureCacheService: SecureCacheServiceProtocol {
    private let secureValet: SinglePromptSecureEnclaveValet

    public init(identifier: String) {
        self.secureValet = SinglePromptSecureEnclaveValet
            .valet(with: Identifier(nonEmpty: identifier)!,
                   accessControl: .userPresence)
    }

    public func containsObject(forKey key: String) throws -> Bool {
        return try secureValet.containsObject(forKey: key)
    }

    public func object(forKey key: String) throws -> Data {
        return try secureValet.object(forKey: key, withPrompt: "Authenticate to access data")
    }

    public func string(forKey key: String) throws -> String? {
        return try secureValet.string(forKey: key, withPrompt: "Authenticate to access data")
    }

    public func setString(_ string: String, forKey key: String) throws {
        try secureValet.setString(string, forKey: key)
    }

    public func setObject(_ object: Data, forKey key: String) throws {
        try secureValet.setObject(object, forKey: key)
    }

    public func removeObject(forKey key: String) throws {
        try secureValet.removeObject(forKey: key)
    }

    public func requirePromptOnNextAccess(forKey key: String) throws {
        try secureValet.requirePromptOnNextAccess()
    }
}
#endif

#if !TESTING
// MARK: - Production Permission Service
public class ProductionPermissionService: PermissionServiceProtocol {
    public func requestPermission(for type: String, completion: @escaping (Bool) -> Void) {
        // Implementation would use PermissionsKit here
        // This is a simplified version to avoid immediate system calls
        DispatchQueue.main.async {
            completion(false)
        }
    }

    public func permissionStatus(for type: String) -> String {
        return "notDetermined"
    }

    public func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
}

// MARK: - Production App Review Service
public class ProductionAppReviewService: AppReviewServiceProtocol {
    public func requestReview() {
        if #available(iOS 14.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }

    public func canRequestReview() -> Bool {
        return true
    }
}
#endif