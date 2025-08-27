//
//  DNSCoreWorkersCodeLocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public extension DNSCodeLocation {
    typealias coreWorkers = DNSCoreWorkersCodeLocation
}
open class DNSCoreWorkersCodeLocation: DNSCodeLocation, @unchecked Sendable {
    override open class var domainPreface: String { "com.doublenode.coreWorkers." }
}
