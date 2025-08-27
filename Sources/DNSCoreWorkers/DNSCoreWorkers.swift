//
//  DNSCoreWorkers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import Foundation

public extension DNSAppConstants {
    enum Biometrics {
        @MainActor static var enabled: String {
            "\(DNSCore.bundleName)_Biometrics_enabled"
        }
        @MainActor static var password: String {
            "\(DNSCore.bundleName)_Biometrics_password"
        }
        @MainActor static var username: String {
            "\(DNSCore.bundleName)_Biometrics_username"
        }
        @MainActor static var valet: String {
            "\(DNSCore.bundleName)_Biometrics_valet"
        }
    }
}
