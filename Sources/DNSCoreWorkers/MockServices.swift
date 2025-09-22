//
//  MockServices.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import Foundation

// MARK: - Mock Location Service
public class MockLocationService: LocationServiceProtocol {
    public var delegate: CLLocationManagerDelegate?
    public var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    public var allowsBackgroundLocationUpdates: Bool = false

    // Mock properties for testing
    public var mockAuthorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    public var mockLocationServicesEnabled: Bool = true
    public var mockLocations: [CLLocation] = []

    public init() {}

    public func requestWhenInUseAuthorization() {
        // Mock implementation - simulate authorization granted
        DispatchQueue.main.async {
            self.delegate?.locationManager?(CLLocationManager(), didChangeAuthorization: self.mockAuthorizationStatus)
        }
    }

    public func startUpdatingLocation() {
        // Mock implementation - simulate location updates
        DispatchQueue.main.async {
            let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
            self.mockLocations.append(mockLocation)
            self.delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [mockLocation])
        }
    }

    public func stopUpdatingLocation() {
        // Mock implementation - no action needed
    }

    public func authorizationStatus() -> CLAuthorizationStatus {
        return mockAuthorizationStatus
    }

    public func locationServicesEnabled() -> Bool {
        return mockLocationServicesEnabled
    }
}

// MARK: - Mock Cache Service
public class MockCacheService: CacheServiceProtocol {
    private var storage: [String: Any] = [:]

    public init() {}

    public func containsObject(forKey key: String) throws -> Bool {
        return storage[key] != nil
    }

    public func object(forKey key: String) throws -> Data {
        guard let data = storage[key] as? Data else {
            throw NSError(domain: "MockCache", code: 1, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
        }
        return data
    }

    public func string(forKey key: String) throws -> String? {
        return storage[key] as? String
    }

    public func setString(_ string: String, forKey key: String) throws {
        storage[key] = string
    }

    public func setObject(_ object: Data, forKey key: String) throws {
        storage[key] = object
    }

    public func removeObject(forKey key: String) throws {
        storage.removeValue(forKey: key)
    }
}

// MARK: - Mock Secure Cache Service
public class MockSecureCacheService: SecureCacheServiceProtocol {
    private var storage: [String: Any] = [:]
    private var promptRequired: Set<String> = []

    public init() {}

    public func containsObject(forKey key: String) throws -> Bool {
        return storage[key] != nil
    }

    public func object(forKey key: String) throws -> Data {
        if promptRequired.contains(key) {
            promptRequired.remove(key)
            // Simulate user authentication success
        }

        guard let data = storage[key] as? Data else {
            throw NSError(domain: "MockSecureCache", code: 1, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
        }
        return data
    }

    public func string(forKey key: String) throws -> String? {
        if promptRequired.contains(key) {
            promptRequired.remove(key)
            // Simulate user authentication success
        }
        return storage[key] as? String
    }

    public func setString(_ string: String, forKey key: String) throws {
        storage[key] = string
    }

    public func setObject(_ object: Data, forKey key: String) throws {
        storage[key] = object
    }

    public func removeObject(forKey key: String) throws {
        storage.removeValue(forKey: key)
        promptRequired.remove(key)
    }

    public func requirePromptOnNextAccess(forKey key: String) throws {
        promptRequired.insert(key)
    }
}

// MARK: - Mock Permission Service
public class MockPermissionService: PermissionServiceProtocol {
    private var permissions: [String: String] = [:]

    public var shouldGrantPermissions: Bool = true

    public init() {}

    public func requestPermission(for type: String, completion: @escaping (Bool) -> Void) {
        permissions[type] = shouldGrantPermissions ? "authorized" : "denied"
        DispatchQueue.main.async {
            completion(self.shouldGrantPermissions)
        }
    }

    public func permissionStatus(for type: String) -> String {
        return permissions[type] ?? "notDetermined"
    }

    public func openSettings() {
        // Mock implementation - no action needed in tests
    }
}

// MARK: - Mock App Review Service
public class MockAppReviewService: AppReviewServiceProtocol {
    public var reviewRequestCount: Int = 0
    public var canReview: Bool = true
    public var shouldSimulateAsync: Bool = true
    public var completionDelay: TimeInterval = 0.01 // 10ms for fast testing

    public init() {}

    public func requestReview() {
        reviewRequestCount += 1
        // Mock service just increments counter - actual completion handled by worker
    }

    public func canRequestReview() -> Bool {
        return canReview
    }

    // Test helper method to simulate async completion
    public func simulateAsyncCompletion(completion: @escaping () -> Void) {
        if shouldSimulateAsync {
            DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
                completion()
            }
        } else {
            completion()
        }
    }
}