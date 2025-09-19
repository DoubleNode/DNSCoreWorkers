//
//  DNSCoreWorkers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import Foundation

public extension DNSAppConstants {
    enum Biometrics {
        static let enabled: String = {
            "\(DNSCore.bundleName)_Biometrics_enabled"
        }()
        static let password: String = {
            "\(DNSCore.bundleName)_Biometrics_password"
        }()
        static let username: String = {
            "\(DNSCore.bundleName)_Biometrics_username"
        }()
        static let valet: String = {
            "\(DNSCore.bundleName)_Biometrics_valet"
        }()
    }
}
