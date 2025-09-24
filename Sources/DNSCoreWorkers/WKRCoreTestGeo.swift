//
//  WKRCoreTestGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSBlankWorkers
import DNSProtocols

open class WKRCoreTestGeo: WKRBaseGeo {
    public var geohash = ""

    private let serviceFactory: ServiceFactoryProtocol

    // MARK: - Initialization
    public init(serviceFactory: ServiceFactoryProtocol? = nil) {
        self.serviceFactory = serviceFactory ?? ProductionServiceFactory()
        super.init()
    }

    required public init() {
        self.serviceFactory = ProductionServiceFactory()
        super.init()
    }

    // MARK: - Business Logic / Single Item CRUD
    override open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLGeoBlkStringLocation?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.completed)
//        block?(.success(self.geohash))
    }
}
