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

open class WKRCoreGeo: WKRBlankGeo, CLLocationManagerDelegate {
    lazy var locationManager: CLLocationManager = utilityCreateLocationManager()

    var block: WKRPTCLGeoBlkString?

    // MARK: - Internal Work Methods
    override open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLGeoBlkString?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        self.block = block

        if DNSAppGlobals.isRunningTest {
            let dnsError = DNSError.Geo.denied(.coreWorkers(self))
            block?(Result.failure(dnsError))
            _ = resultBlock?(.error)
            return
        }
        DNSUIThread.run {
            let authorizationStatus: CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                authorizationStatus = self.locationManager.authorizationStatus
            } else {
                authorizationStatus = CLLocationManager.authorizationStatus()
            }
            if authorizationStatus == .denied {
                let dnsError = DNSError.Geo.denied(.coreWorkers(self))
                block?(Result.failure(dnsError))
                _ = resultBlock?(.error)
                return
            }
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
            _ = resultBlock?(.completed)
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
        locationManager.stopUpdatingLocation()

        let geohash = userLocation.geohash(precision: 6)
        self.block?(Result.success(geohash))

        dnsLog.debug("user latitude = \(userLocation.coordinate.latitude)")
        dnsLog.debug("user longitude = \(userLocation.coordinate.longitude)")
        dnsLog.debug("user geohash = \(geohash)")
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
