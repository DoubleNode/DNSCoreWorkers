//
//  WKRCoreTestGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSBlankWorkers
import DNSCore
import DNSProtocols

open class WKRCoreTestGeo: WKRBlankGeo, @unchecked Sendable {
    static public let geohash = "9vg5c1"   // Main Event Lewisville
    static nonisolated(unsafe) public let location: DNSDataDictionary = [
        "latitude": 33.0132075,
        "longitude": -96.9763461,
    ]
    public let clLocation = CLLocation(from: location)

    // MARK: - Business Logic / Single Item CRUD
    override open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLGeoBlkStringLocation?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        let result = (WKRCoreTestGeo.geohash, self.clLocation)
        block?(.success(result))
        _ = resultBlock?(.completed)
    }
}
