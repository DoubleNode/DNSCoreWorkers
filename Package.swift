// swift-tools-version:6.0
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreValidationWorker
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSCoreWorkers",
    platforms: [
        .iOS(.v18),
        .tvOS(.v18),
        .macCatalyst(.v16),
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
        .package(url: "https://github.com/DoubleNode/DNSAppCore.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSBlankWorkers.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSCrashWorkers.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSError.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSProtocols.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSThemeObjects.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSThemeTypes.git", .upToNextMajor(from: "1.12.1")),
//        .package(path: "../DNSAppCore.git"),
//        .package(path: "../DNSBlankWorkers.git"),
//        .package(path: "../DNSCore.git"),
//        .package(path: "../DNSCrashWorkers.git"),
//        .package(path: "../DNSError.git"),
//        .package(path: "../DNSProtocols.git"),
//        .package(path: "../DNSThemeObjects.git"),
//        .package(path: "../DNSThemeTypes.git"),
        .package(url: "https://github.com/nidegen/Geodesy", from: "1.2.2"),
        .package(url: "https://github.com/sparrowcode/PermissionsKit", from: "8.0.1"),
        .package(url: "https://github.com/Square/Valet", from: "4.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSCoreWorkers",
            dependencies: [
                "DNSAppCore", "DNSBlankWorkers", "DNSCore", "DNSCrashWorkers", "DNSError",
                "DNSThemeObjects", "DNSThemeTypes", "DNSProtocols", "Geodesy", "Valet",
                .product(name: "CalendarPermission", package: "PermissionsKit"),
                .product(name: "CameraPermission", package: "PermissionsKit"),
                .product(name: "LocationWhenInUsePermission", package: "PermissionsKit"),
                .product(name: "NotificationPermission", package: "PermissionsKit"),
            ]),
        .testTarget(
            name: "DNSCoreWorkersTests",
            dependencies: ["DNSCoreWorkers"],
            resources: [
                .process("Constants.plist")
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
