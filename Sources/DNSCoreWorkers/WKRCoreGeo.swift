//
//  WKRCoreGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

#if !TESTING
import CoreLocation
#endif
import DNSAppCore
import DNSBlankWorkers
import DNSCore
import DNSCoreThreading
import DNSDataObjects
import DNSError
import DNSProtocols
import Geodesy
import UIKit

open class WKRCoreGeo: WKRBlankGeo, CLLocationManagerDelegate {
    private let serviceFactory: ServiceFactoryProtocol
    private var locationService: LocationServiceProtocol?

    var block: WKRPTCLGeoBlkStringLocation?

    // MARK: - Initialization
    public init(serviceFactory: ServiceFactoryProtocol? = nil) {
        self.serviceFactory = serviceFactory ?? ProductionServiceFactory()
        super.init()
    }

    required public init() {
        self.serviceFactory = ProductionServiceFactory()
        super.init()
    }

    // MARK: - Lazy Service Initialization
    private var _locationService: LocationServiceProtocol {
        if locationService == nil {
            locationService = serviceFactory.makeLocationService()
            locationService?.delegate = self
            locationService?.desiredAccuracy = kCLLocationAccuracyBest
            locationService?.allowsBackgroundLocationUpdates = false
        }
        return locationService!
    }

    // MARK: - Internal Work Methods
    override open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLGeoBlkStringLocation?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        self.block = block

        // Check if using mock services (test mode) by checking service factory type
        if serviceFactory is TestServiceFactory {
            let dnsError = DNSError.Geo.denied(.coreWorkers(self))
            block?(.failure(dnsError))
            _ = resultBlock?(.error)
            return
        }
        DNSUIThread.run {
            let authorizationStatus = self._locationService.authorizationStatus()
            if authorizationStatus == .denied {
                let dnsError = DNSError.Geo.denied(.coreWorkers(self))
                block?(.failure(dnsError))
                _ = resultBlock?(.error)
                return
            }
            if self._locationService.locationServicesEnabled() {
                self._locationService.startUpdatingLocation()
            }
            _ = resultBlock?(.completed)
        }
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
                                didFailWithError error: Error) {
        let dnsError = DNSError.Geo.failure(error: error, .coreWorkers(self))
        block?(Result.failure(dnsError))
        dnsLog.error(dnsError)
    }
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        _locationService.stopUpdatingLocation()

        let geohash = userLocation.geohash(precision: 8)
        self.block?(Result.success((geohash, userLocation)))

        dnsLog.debug("user latitude = \(userLocation.coordinate.latitude)")
        dnsLog.debug("user longitude = \(userLocation.coordinate.longitude)")
        dnsLog.debug("user geohash = \(geohash)")
    }

}
