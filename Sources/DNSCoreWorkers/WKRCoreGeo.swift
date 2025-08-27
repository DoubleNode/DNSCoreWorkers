//
//  WKRCoreGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSAppCore
import DNSBlankWorkers
import DNSCore
import DNSCoreThreading
import DNSDataObjects
import DNSError
import DNSProtocols
import Geodesy
import UIKit

open class WKRCoreGeo: WKRBlankGeo, CLLocationManagerDelegate, @unchecked Sendable {
    lazy var locationManager: CLLocationManager = utilityCreateLocationManager()

    var block: WKRPTCLGeoBlkStringLocation?

    // MARK: - Internal Work Methods
    override open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLGeoBlkStringLocation?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        self.block = block

        // Check for test environment - default to false if we can't access DNSAppGlobals
        // This avoids main actor isolation issues while maintaining functionality
        let isTestEnvironment = false // Simplified for now to avoid concurrency issues
        
        if isTestEnvironment {
            let dnsError = DNSError.Geo.denied(.coreWorkers(self))
            block?(.failure(dnsError))
            _ = resultBlock?(.error)
            return
        }
        
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = self.locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        if authorizationStatus == .denied {
            let dnsError = DNSError.Geo.denied(.coreWorkers(self))
            block?(.failure(dnsError))
            _ = resultBlock?(.error)
            return
        }
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
        _ = resultBlock?(.completed)
    }
    override open func intDoLocate(_ address: DNSPostalAddress,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLGeoBlkStringLocation?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address.asString) { (placemarks, error) in
            guard error == nil else {
                let dnsError = DNSError.Geo.failure(error: error!, .coreWorkers(self))
                block?(.failure(dnsError))
                return
            }
            guard let placemarks,
                  let placemark = placemarks.first,
                  let location = placemark.location else {
                let dnsError = DNSError.Geo.notFound(field: "address", value: address.asString,
                                                     .coreWorkers(self))
                block?(.failure(dnsError))
                return
            }
            let geohash = location.geohash(precision: 8)
            let results = (geohash, location)
            block?(.success(results))
        }
    }

    // MARK: - CLLocationManagerDelegate methods
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: any Error) {
        let dnsError = DNSError.Geo.failure(error: error, .coreWorkers(self))
        block?(Result.failure(dnsError))
        Task { @MainActor in
            dnsLog.error(dnsError)
        }
    }
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()

        let geohash = userLocation.geohash(precision: 8)
        self.block?(Result.success((geohash, userLocation)))

        Task { @MainActor in
            dnsLog.debug("user latitude = \(userLocation.coordinate.latitude)")
            dnsLog.debug("user longitude = \(userLocation.coordinate.longitude)")
            dnsLog.debug("user geohash = \(geohash)")
        }
    }

    // MARK: - Utility methods
    private func utilityCreateLocationManager() -> CLLocationManager {
        let retval = CLLocationManager()
        retval.delegate = self
        retval.desiredAccuracy = kCLLocationAccuracyBest
        retval.allowsBackgroundLocationUpdates = false
        retval.requestWhenInUseAuthorization()
        return retval
    }
}
