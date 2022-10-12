// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreValidationWorker
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSCoreWorkers",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v10_15),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSCoreWorkers",
            type: .static,
            targets: ["DNSCoreWorkers"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/DoubleNode/DNSAppCore.git", from: "1.10.0"),
        .package(url: "https://github.com/DoubleNode/DNSBaseTheme.git", from: "1.10.0"),
        .package(url: "https://github.com/DoubleNode/DNSBlankWorkers.git", from: "1.10.6"),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", from: "1.10.2"),
        .package(url: "https://github.com/DoubleNode/DNSCrashWorkers.git", from: "1.10.3"),
        .package(url: "https://github.com/DoubleNode/DNSError.git", from: "1.10.0"),
        .package(url: "https://github.com/DoubleNode/DNSProtocols.git", from: "1.10.12"),
        .package(url: "https://github.com/nidegen/Geodesy", from: "1.2.2"),
        .package(url: "https://github.com/sparrowcode/PermissionsKit", from: "8.0.1"),
        .package(url: "https://github.com/Square/Valet", from: "4.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSCoreWorkers",
            dependencies: [
                "DNSAppCore", "DNSBaseTheme", "DNSBlankWorkers", "DNSCore",
                "DNSCrashWorkers", "DNSError", "DNSProtocols", "Geodesy", "Valet",
                .product(name: "CalendarPermission", package: "PermissionsKit"),
                .product(name: "CameraPermission", package: "PermissionsKit"),
                .product(name: "LocationWhenInUsePermission", package: "PermissionsKit"),
                .product(name: "NotificationPermission", package: "PermissionsKit"),
            ]),
        .testTarget(
            name: "DNSCoreWorkersTests",
            dependencies: ["DNSCoreWorkers"]),
    ],
    swiftLanguageVersions: [.v5]
)
