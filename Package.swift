// swift-tools-version:6.0
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
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
        .tvOS(.v18),
        .macCatalyst(.v18),
        .macOS(.v15),
        .watchOS(.v11),
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
        .package(url: "https://github.com/DoubleNode/DNSAppCore.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/DoubleNode/DNSBaseTheme.git", .upToNextMajor(from: "2.0.1")),
        .package(url: "https://github.com/DoubleNode/DNSBlankWorkers.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "2.0.2")),
        .package(url: "https://github.com/DoubleNode/DNSCrashWorkers.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/DoubleNode/DNSError.git", .upToNextMajor(from: "2.0.1")),
        .package(url: "https://github.com/DoubleNode/DNSProtocols.git", .upToNextMajor(from: "2.0.4")),
        .package(url: "https://github.com/nidegen/Geodesy", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/sparrowcode/PermissionsKit", .upToNextMajor(from: "8.0.1")),
        .package(url: "https://github.com/Square/Valet", .upToNextMajor(from: "4.3.0")),
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
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "DNSCoreWorkersTests",
            dependencies: ["DNSCoreWorkers"],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
