//
//  WKRCoreBeaconsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSBlankWorkers
import DNSCore
import DNSCoreThreading
import DNSDataObjects
import DNSProtocols
import Geodesy
import UIKit

open class WKRCoreBeaconsWorker: WKRBlankBeaconsWorker, CLLocationManagerDelegate {
    lazy var locationManager: CLLocationManager = utilityCreateLocationManager()

    var block: WKRPTCLGeoBlkString?

    // MARK: - UIWindowSceneDelegate methods
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    override public func didBecomeActive() {
        super.didBecomeActive()
        utilityUpdateTracking()
    }

    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    override public func willResignActive() {
        super.willResignActive()
        utilityStopTracking()
    }

    // MARK: - Internal Work Methods
    /*
    override public func doRangeBeacons(named uuids: [UUID],
                                        for processKey: String,
                                        with progress: DNSPTCLProgressBlock?,
                                        and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws {
        var process = BeaconProcess(process: processKey)
        process.uuids.append(contentsOf: uuids)
        process.beaconsBlock = block
        processes[processKey] = process

        uuids.forEach { uuid in
            var beaconRegion = regions[uuid] ?? BeaconRegion(uuid: uuid)
            beaconRegion.processes[processKey] = process
            regions[uuid] = beaconRegion
        }

        utilityUpdateMonitoringAndRanging()
    }

    override public func doStopRangeBeacons(for processKey: String) throws {
        guard let process = processes[processKey] else { return }

        process.uuids.forEach { (uuid) in
            regions[uuid]?.processes.removeValue(forKey: processKey)
        }

        processes.removeValue(forKey: processKey)

        utilityUpdateMonitoringAndRanging()
    }
 */

    // MARK: - CLLocationManagerDelegate methods

//    public func locationManager(_ manager: CLLocationManager,
//                                didFailWithError error: Error) {
//        let dnsError = PTCLGeolocationError.failure(error: error,
//                                                    domain: "com.mainevent.\(type(of: self))",
//                                                    file: DNSCore.shortenErrorPath("\(#file)"),
//                                                    line: "\(#line)",
//                                                    method: "\(#function)")
//        self.block?("", dnsError)
//
//        log.error(error)
//    }
//
//    public func locationManager(_ manager: CLLocationManager,
//                                didUpdateLocations locations: [CLLocation]) {
//        let userLocation: CLLocation = locations[0] as CLLocation
//
//        locationManager.stopUpdatingLocation()
//
//        let geohash = userLocation.geohash(precision: 6)
//        self.block?(geohash, nil)
//
//        log.verbose("user latitude = \(userLocation.coordinate.latitude)")
//        log.verbose("user longitude = \(userLocation.coordinate.longitude)")
//        log.verbose("user geohash = \(geohash)")
//    }

    /*
    public func locationManager(_ manager: CLLocationManager,
                                didDetermineState state: CLRegionState,
                                for region: CLRegion) {
        guard let clBeaconRegion = region as? CLBeaconRegion else { return }
        let uuid = clBeaconRegion.uuid

        switch state {
        case .inside:
            print("Inside Region: \(uuid)")
            regions[uuid]?.isInside = true

        case .outside:
            print("Outside Region: \(uuid)")
            regions[uuid]?.isInside = false

        case .unknown:
            print("Unknown State for Region: \(uuid)")

        default:
            break
        }

        if UIApplication.shared.applicationState == .active {
            self.utilityUpdateMonitoringAndRanging()

            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
            DNSUIThread.run(after: 0.2) {   // TODO: DNSThread
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
                DNSUIThread.run(after: 0.2) {   // TODO: DNSThread
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)
                }
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager,
                                didRange beacons: [CLBeacon],
                                satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1.0)

        let uuid = beaconConstraint.uuid

        var daoBeacons: [DAOBeacon] = []

        beacons.forEach { beacon in
            let daoBeacon = DAOBeacon()
            daoBeacon.code = "\(beacon.major):\(beacon.minor)"
            daoBeacon.data = beacon
            daoBeacon.accuracy = beacon.accuracy

            switch beacon.proximity {
            case .immediate:    daoBeacon.range = "Immediate"
            case .near:         daoBeacon.range = "Near"
            case .far:          daoBeacon.range = "Far"
            case .unknown:      daoBeacon.range = "Unknown"
            default:            break
            }

            daoBeacons.append(daoBeacon)
        }

        daoBeacons.sort { $0.accuracy < $1.accuracy }

        var region = regions[uuid]
        region?.beacons = daoBeacons

        self.utilityStopRanging()
        DNSUIThread.run(after: 1.0) { // TO DO: Revert to 3 to 5 seconds    // TODO: DNSThread
            self.utilityUpdateMonitoringAndRanging()
        }
    }
 */

    // MARK: - Utility methods
    private func utilityCreateLocationManager() -> CLLocationManager {
        let retval = CLLocationManager()
        retval.delegate = self
        retval.desiredAccuracy = kCLLocationAccuracyBest
        retval.allowsBackgroundLocationUpdates = false
        retval.requestWhenInUseAuthorization()
//        retval.requestAlwaysAuthorization()
        return retval
    }

    func utilityUpdateTracking() {
        /*
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else {
            locationManager.monitoredRegions.forEach(locationManager.stopMonitoring(for:))
            return
        }

        locationManager.monitoredRegions.forEach { (clRegion) in
            guard let clBeaconRegion = clRegion as? CLBeaconRegion else { return }
            let uuid = clBeaconRegion.uuid
            if regions[uuid] == nil {
                locationManager.stopMonitoring(for: clRegion)
                locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid))
            }
        }

        regions.forEach { (uuid, beaconRegion) in
            if !beaconRegion.isMonitoring {
                let clBeaconRegion = CLBeaconRegion(uuid: uuid, identifier: uuid.uuidString)
                // 19097:34461 - SC: Darren's Desk
                /* Used for testing inside/outside region monitoring
                let clBeaconRegion = CLBeaconRegion.init(uuid: uuid,
                                                         major: 19097,
                                                         minor: 34461,
                                                         identifier: uuid.uuidString)
                 */
                locationManager.startMonitoring(for: clBeaconRegion)
                regions[uuid]?.isMonitoring = true
            }

            let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid)
            if beaconRegion.isInside {
                if !beaconRegion.isRanging {
                    locationManager.startRangingBeacons(satisfying: beaconConstraint)
                    regions[uuid]?.isRanging = true
                }
            } else {
                locationManager.stopRangingBeacons(satisfying: beaconConstraint)
            }
        }
         */
    }
    func utilityStopTracking() {
        /*
        locationManager.monitoredRegions.forEach { (clRegion) in
            locationManager.stopMonitoring(for: clRegion)

            guard let clBeaconRegion = clRegion as? CLBeaconRegion else { return }
            let uuid = clBeaconRegion.uuid
            regions[uuid]?.isMonitoring = false
        }
         */
    }
}
