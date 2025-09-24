//
//  WKRCorePermissions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import AtomicSwift
import DNSBlankWorkers
import DNSCore
import DNSCoreThreading
import DNSError
import DNSProtocols
import DNSThemeObjects
import UIKit

#if !TESTING
import PermissionsKit
import CalendarPermission
import CameraPermission
import LocationWhenInUsePermission
import NotificationPermission
#endif

// swiftlint:disable:next type_body_length
open class WKRCorePermissions: WKRBasePermissions, PermissionsDataSource, PermissionsDelegate {
    private let serviceFactory: ServiceFactoryProtocol
    private var permissionService: PermissionServiceProtocol?

    // MARK: - Initialization
    public init(serviceFactory: ServiceFactoryProtocol? = nil) {
        self.serviceFactory = serviceFactory ?? ProductionServiceFactory()
        super.init()
    }

    required public init() {
        self.serviceFactory = ProductionServiceFactory()
        super.init()
    }

    // MARK: - Lazy Service Initialization
    private var _permissionService: PermissionServiceProtocol {
        if permissionService == nil {
            permissionService = serviceFactory.makePermissionService()
        }
        return permissionService!
    }
    struct PermissionBlock {
        var permission: WKRPTCLPermissions.Data.System
        var block: WKRPTCLPermissionsBlkAction?
        var resultBlock: DNSPTCLResultBlock?
    }
    struct PermissionsBlock {
        var permissions: [WKRPTCLPermissions.Data.System]
        var block: WKRPTCLPermissionsBlkAAction?
        var resultBlock: DNSPTCLResultBlock?
    }

    public static let pauseDeniedRetryMax = 10
    public static let pauseDeniedRetryMemoryMax = 12
    public static let pauseSkippedRetryMax = 3
    public static let pauseSkippedRetryMemoryMax = 5

//    public static var colors: SPPermissionsColorProtocol {
//        set {
//            SPPermissions.color = newValue
//        }
//        get {
//            SPPermissions.color
//        }
//    }
//    public static var strings: SPPermissionsTextProtocol {
//        set {
//            SPPermissions.text = newValue
//        }
//        get {
//            SPPermissions.text
//        }
//    }

    enum Permissions {
        static let calendar = "WKRCorePermissions_Permissions_Calendar"
        static let camera = "WKRCorePermissions_Permissions_Camera"
        static let locationWhenInUse = "WKRCorePermissions_Permissions_LocationWhenInUse"
        static let notification = "WKRCorePermissions_Permissions_Notification"

        enum Pause {
            static let calendar = "WKRCorePermissions_Permissions_Pause_Calendar"
            static let camera = "WKRCorePermissions_Permissions_Pause_Camera"
            static let locationWhenInUse = "WKRCorePermissions_Permissions_Pause_LocationWhenInUse"
            static let notification = "WKRCorePermissions_Permissions_Pause_Notification"
        }
    }

    @Atomic var dialogAsking: [WKRPTCLPermissions.Data.System] = []
    @Atomic var dialogDesire: WKRPTCLPermissions.Data.Desire = .wouldLike
    @Atomic var memorySettings: [String: WKRPTCLPermissions.Data.Action] = [:]
    @Atomic var memoryPauseSettings: [String: Int] = [:]
    @Atomic var permissionBlocks: [PermissionBlock] = []
    @Atomic var permissionsBlocks: [PermissionsBlock] = []

    override open func configure() {
        super.configure()
//        Self.colors = WKRCorePermissionsColors()
//        Self.strings = WKRCorePermissionsStrings()
    }

    var nativeMode = true

    // MARK: - Business Logic / Single Item CRUD -
    override open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                                    _ permission: WKRPTCLPermissions.Data.System,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLPermissionsBlkAction?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        if self.utilityAction(permission) == .allowed {
            block?(.success(WKRPTCLPermissions.Action(permission, .allowed)))
            _ = resultBlock?(.completed)
            return
        }

        let permissionBlock = PermissionBlock(permission: permission, block: block, resultBlock: resultBlock)
        self.permissionBlocks.append(permissionBlock)

//        log.debug("***PERM-1*** \(desire.rawValue) \(permission.rawValue)")
        guard self.utilityShouldContinue(desire,
                                         permission) else { return }
        DNSCore.reportLog("doRequest(permission:)")
        guard let viewController = UIApplication.shared.dnsVisibleViewController else { return }
        guard dialogAsking.isEmpty else { return }
        dialogAsking = [permission]
        dialogDesire = desire

        let requestPermissions = self.utilityPermissionsList(startingWith: [self.utilityConvert(permission)])
        DNSUIThread.run {
            let anyDenied = requestPermissions.contains { $0.denied }
            if self.nativeMode && !anyDenied {
                let controller = PermissionsKit.native(Array(requestPermissions))
                controller.delegate = self
                controller.present(on: viewController)
                return
            }
            if requestPermissions.count < 4 {
                let controller = PermissionsKit.dialog(Array(requestPermissions))
                controller.dataSource = self
                controller.delegate = self
                controller.present(on: viewController)
            } else {
                let controller = PermissionsKit.list(Array(requestPermissions))
                controller.dataSource = self
                controller.delegate = self
                controller.present(on: viewController)
            }
        }
    }
    override open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                                    _ permissions: [WKRPTCLPermissions.Data.System],
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLPermissionsBlkAAction?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        let pkPermissions = permissions.map { self.utilityConvert($0) }
        let pkPermissionsNotAuth = pkPermissions.filter { !$0.authorized }
        if pkPermissionsNotAuth.isEmpty {
            let retval = permissions.map { WKRPTCLPermissionAction($0, .allowed) }
            block?(.success(retval))
            _ = resultBlock?(.completed)
            return
        }

        let permissionsBlk = PermissionsBlock(permissions: permissions, block: block, resultBlock: resultBlock)
        self.permissionsBlocks.append(permissionsBlk)

//        let debugPermissions = permissions.map{ $0.rawValue }.joined(separator: "|")
//        log.debug("***PERM-2*** \(desire.rawValue) \(debugPermissions)")
        guard self.utilityShouldContinue(desire, permissions) else { return }
        DNSCore.reportLog("doRequest(permissions:)")
        guard let viewController = UIApplication.shared.dnsVisibleViewController else { return }
        guard dialogAsking.isEmpty else { return }
        dialogAsking = permissions
        dialogDesire = desire

        let requestPermissions = self.utilityPermissionsList(startingWith: pkPermissions)
        DNSUIThread.run {
            let anyDenied = requestPermissions.contains { $0.denied }
            if self.nativeMode && !anyDenied {
                let controller = PermissionsKit.native(Array(requestPermissions))
                controller.delegate = self
                controller.present(on: viewController)
                return
            }
            if requestPermissions.count < 4 {
                let controller = PermissionsKit.dialog(Array(requestPermissions))
                controller.dataSource = self
                controller.delegate = self
                controller.present(on: viewController)
            } else {
                let controller = PermissionsKit.list(Array(requestPermissions))
                controller.dataSource = self
                controller.delegate = self
                controller.present(on: viewController)
            }
        }
    }
    override open func intDoStatus(of permissions: [WKRPTCLPermissions.Data.System],
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLPermissionsBlkAAction?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        guard !permissions.isEmpty else {
            let dnsError = DNSError.WorkerBase
                .invalidParameters(parameters: ["permissions"], .coreWorkers(self))
            DNSCore.reportError(dnsError)
            block?(.success([]))
            _ = resultBlock?(.error)
            return
        }

        let retval = permissions.map { WKRPTCLPermissions.Action($0, utilityAction($0)) }
        block?(.success(retval))
        _ = resultBlock?(.completed)
    }
    override open func intDoWait(for permission: WKRPTCLPermissions.Data.System,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLPermissionsBlkAction?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        if self.utilityConvert(permission).authorized {
            block?(.success(WKRPTCLPermissionAction(permission, .allowed)))
            _ = resultBlock?(.completed)
            return
        }

        let permissionBlk = PermissionBlock(permission: permission, block: block, resultBlock: resultBlock)
        self.permissionBlocks.append(permissionBlk)
    }

    // MARK: - PermissionsDataSource -
    public func configure(_ cell: PermissionTableViewCell,
                          for permission: Permission) {
        cell.permissionButton.centerYAnchor.constraint(equalTo: cell.permissionTitleLabel.layoutMarginsGuide.centerYAnchor).isActive = true
        cell.permissionDescriptionLabel.topAnchor.constraint(equalTo: cell.permissionButton.bottomAnchor, constant: 8).isActive = true
        cell.permissionDescriptionLabel.trailingAnchor.constraint(equalTo: cell.permissionButton.trailingAnchor).isActive = true
    }
    
    public func deniedPermissionAlertTexts(for permission: Permission) -> DeniedPermissionAlertTexts? {
//        log.debug("*** PERMISSIONS : deniedData *** (\(permission.name))")
        return nil  // DeniedPermissionAlertTexts()
    }

    // MARK: - PermissionsDelegate -
    public func didAllow(permission: Permission) {
//        log.debug("*** PERMISSIONS : didAllow *** (\(permission.name))")
        self.utilityUpdateContinue(WKRPTCLPermissions.Data.Action.allowed,
                                   for: permission)
        self.utilityNotifyWaitingBlocks(of: permission,
                                        and: .allowed)
        if nativeMode {
            self.didHide(permissions: [])
        }
    }
    public func didDenied(permission: Permission) {
//        log.debug("*** PERMISSIONS : didDenied *** (\(permission.name))")
        self.utilityUpdateContinue(WKRPTCLPermissions.Data.Action.denied,
                                   for: permission)
        self.utilityNotifyWaitingBlocks(of: permission,
                                        and: .denied)
        if nativeMode {
            self.didHide(permissions: [])
        }
    }
    public func didHide(permissions ids: [Int]) {
//        let permissions = ids.map { SPPermission(rawValue: $0) }
//        log.debug("*** PERMISSIONS : didHide *** (\(permissions.map { $0?.name ?? "" }))")
        dialogAsking.forEach {
            if self.utilityAction($0) == .unknown {
                self.utilityUpdateContinue(WKRPTCLPermissions.Data.Action.skipped,
                                           for: $0)
            } else if self.utilityAction($0) == .denied {
                self.utilityUpdateContinue(WKRPTCLPermissions.Data.Action.denied,
                                           for: $0)
            }
        }
        dialogAsking = []
        dialogDesire = .wouldLike
    }

    // MARK: - Utility methods -
    func utilityAction(_ permission: WKRPTCLPermissions.Data.System) -> WKRPTCLPermissions.Data.Action {
        return WKRCorePermissions.utilityAction(permission)
    }
    class func utilityAction(_ permission: WKRPTCLPermissions.Data.System) -> WKRPTCLPermissions.Data.Action {
        let pkPermission = WKRCorePermissions.utilityConvert(permission)
        if pkPermission.authorized {
            return .allowed
        } else if pkPermission.denied {
            return .denied
        }
        return .unknown
    }
    func utilityConvert(_ permission: WKRPTCLPermissions.Data.System) -> Permission {
        return WKRCorePermissions.utilityConvert(permission)
    }
    // swiftlint:disable:next cyclomatic_complexity
    class func utilityConvert(_ permission: WKRPTCLPermissions.Data.System) -> Permission {
        switch permission {
        case .calendar: return .calendar
        case .camera:   return .camera
        case .locationWhenInUse:    return .locationWhenInUse
        case .notification: return .notification
        default:
            return .camera  // SHOULD NEVER OCCUR
        }
    }
    func utilityConvert(_ pkPermission: Permission) -> WKRPTCLPermissions.Data.System {
        return WKRCorePermissions.utilityConvert(pkPermission)
    }
    // swiftlint:disable:next cyclomatic_complexity
    class func utilityConvert(_ pkPermission: Permission) -> WKRPTCLPermissions.Data.System {
        switch pkPermission {
        case .calendar: return .calendar
        case .camera:   return .camera
        case .locationWhenInUse:    return .locationWhenInUse
        case .notification: return .notification
        default:
            return .camera  // SHOULD NEVER OCCUR
        }
    }

    func utilityMemorySet(_ permissionAction: WKRPTCLPermissions.Data.Action,
                          for permission: WKRPTCLPermissions.Data.System) {
        var permissionString: String = ""
        var permissionPauseString: String = ""
        if permission == .calendar {
            permissionString = Permissions.calendar
            permissionPauseString = Permissions.Pause.calendar
        } else if permission == .camera {
            permissionString = Permissions.camera
            permissionPauseString = Permissions.Pause.camera
        } else if permission == .locationWhenInUse {
            permissionString = Permissions.locationWhenInUse
            permissionPauseString = Permissions.Pause.locationWhenInUse
        } else if permission == .notification {
            permissionString = Permissions.notification
            permissionPauseString = Permissions.Pause.notification
        } else {
            return
        }
        memorySettings[permissionString] = permissionAction
        memoryPauseSettings[permissionPauseString] = 0
    }
    func utilityMemorySet(_ permissionAction: WKRPTCLPermissions.Data.Action,
                          for spPermission: Permission) {
        if spPermission == .calendar {
            self.utilityMemorySet(permissionAction, for: WKRPTCLPermissions.Data.System.calendar)
        } else if spPermission == .camera {
            self.utilityMemorySet(permissionAction, for: WKRPTCLPermissions.Data.System.camera)
        } else if spPermission == .locationWhenInUse {
            self.utilityMemorySet(permissionAction, for: WKRPTCLPermissions.Data.System.locationWhenInUse)
        } else if spPermission == .notification {
            self.utilityMemorySet(permissionAction, for: WKRPTCLPermissions.Data.System.notification)
        }
    }
    func utilityMemorySetting(for permission: WKRPTCLPermissions.Data.System) -> WKRPTCLPermissions.Data.Action {
        var permissionString: String = ""
        var permissionPauseString: String = ""
        if permission == .calendar {
            permissionString = Permissions.calendar
            permissionPauseString = Permissions.Pause.calendar
        } else if permission == .camera {
            permissionString = Permissions.camera
            permissionPauseString = Permissions.Pause.camera
        } else if permission == .locationWhenInUse {
            permissionString = Permissions.locationWhenInUse
            permissionPauseString = Permissions.Pause.locationWhenInUse
        } else if permission == .notification {
            permissionString = Permissions.notification
            permissionPauseString = Permissions.Pause.notification
        } else {
            return WKRPTCLPermissions.Data.Action.unknown
        }
        var retval = memorySettings[permissionString] ?? .unknown
        let pauseCount = memoryPauseSettings[permissionPauseString] ?? 0
        if (pauseCount >= Self.pauseSkippedRetryMemoryMax) && (retval == .skipped) {
            retval = .unknown
            memoryPauseSettings[permissionPauseString] = 0
        } else  if (pauseCount >= Self.pauseDeniedRetryMemoryMax) && (retval == .denied) {
            retval = .unknown
            memoryPauseSettings[permissionPauseString] = 0
        } else {
            memoryPauseSettings[permissionPauseString] = pauseCount + 1
        }
        return retval
    }
    func utilityMemorySetting(for spPermission: Permission) -> WKRPTCLPermissions.Data.Action {
        if spPermission == .calendar {
            return self.utilityMemorySetting(for: WKRPTCLPermissions.Data.System.calendar)
        } else if spPermission == .camera {
            return self.utilityMemorySetting(for: WKRPTCLPermissions.Data.System.camera)
        } else if spPermission == .locationWhenInUse {
            return self.utilityMemorySetting(for: WKRPTCLPermissions.Data.System.locationWhenInUse)
        } else if spPermission == .notification {
            return self.utilityMemorySetting(for: WKRPTCLPermissions.Data.System.notification)
        }
        return WKRPTCLPermissions.Data.Action.unknown
    }
    func utilityNotifyWaitingBlocks(of spPermission: Permission,
                                    and action: WKRPTCLPermissions.Data.Action) {
        // Notify waiting blocks
        permissionBlocks
            .filter { self.utilityConvert($0.permission) == spPermission }
            .forEach { $0.block?(.success(WKRPTCLPermissions.Action($0.permission, action))) }
        permissionsBlocks
            .forEach {
                let permissions = $0.permissions.map { self.utilityConvert($0) }
                if permissions.contains(spPermission) {
                    $0.block?(.success([WKRPTCLPermissions.Action(self.utilityConvert(spPermission), action)]))
                }
            }

        // Remove notified waiting blocks
        permissionBlocks = permissionBlocks
            .filter { self.utilityConvert($0.permission) != spPermission }
        var newPermissionsBlocks: [PermissionsBlock] = []
        permissionsBlocks
            .forEach {
                let permissions = $0.permissions.filter { self.utilityConvert($0) != spPermission }
                if !permissions.isEmpty {
                    newPermissionsBlocks.append(PermissionsBlock(permissions: permissions,
                                                                 block: $0.block,
                                                                 resultBlock: $0.resultBlock))
                }
            }
        permissionsBlocks = newPermissionsBlocks
    }
    func utilityPermissionsList(startingWith startingPermissions: [Permission]) -> [Permission] {
        var allPermissions = startingPermissions
        permissionBlocks.forEach { allPermissions.append(self.utilityConvert($0.permission)) }
        permissionsBlocks.forEach {
            $0.permissions.forEach { allPermissions.append(self.utilityConvert($0)) }
        }
        if dialogDesire == .present {
            return allPermissions
        }
        let allPermissionsNotAuth = allPermissions.filter { !$0.authorized }

        var retval = allPermissionsNotAuth
        if retval.count < 3 {
            allPermissions.forEach {
                if retval.count < 3 {
                    retval.append($0)
                }
            }
        }
        return Array(retval).sorted { (startingPermissions.contains($0) ? 1 : 0) > (startingPermissions.contains($1) ? 1 : 0) }
    }
    func utilitySet(_ permissionAction: WKRPTCLPermissions.Data.Action,
                    for permission: WKRPTCLPermissions.Data.System) {
        var permissionString: String = ""
        var permissionPauseString: String = ""
        if permission == .calendar {
            permissionString = Permissions.calendar
            permissionPauseString = Permissions.Pause.calendar
        } else if permission == .camera {
            permissionString = Permissions.camera
            permissionPauseString = Permissions.Pause.camera
        } else if permission == .locationWhenInUse {
            permissionString = Permissions.locationWhenInUse
            permissionPauseString = Permissions.Pause.locationWhenInUse
        } else if permission == .notification {
            permissionString = Permissions.notification
            permissionPauseString = Permissions.Pause.notification
        } else {
            return
        }
        DNSCore.setting(set: permissionString,
                        with: permissionAction.rawValue)
        DNSCore.setting(set: permissionPauseString,
                        with: 0)
    }
    func utilitySet(_ permissionAction: WKRPTCLPermissions.Data.Action,
                    for spPermission: Permission) {
        if spPermission == .calendar {
            self.utilitySet(permissionAction, for: WKRPTCLPermissions.Data.System.calendar)
        } else if spPermission == .camera {
            self.utilitySet(permissionAction, for: WKRPTCLPermissions.Data.System.camera)
        } else if spPermission == .locationWhenInUse {
            self.utilitySet(permissionAction, for: WKRPTCLPermissions.Data.System.locationWhenInUse)
        } else if spPermission == .notification {
            self.utilitySet(permissionAction, for: WKRPTCLPermissions.Data.System.notification)
        }
    }
    func utilitySetting(for permission: WKRPTCLPermissions.Data.System) -> WKRPTCLPermissions.Data.Action {
        var permissionString: String = ""
        var permissionPauseString: String = ""
        if permission == .calendar {
            permissionString = Permissions.calendar
            permissionPauseString = Permissions.Pause.calendar
        } else if permission == .camera {
            permissionString = Permissions.camera
            permissionPauseString = Permissions.Pause.camera
        } else if permission == .locationWhenInUse {
            permissionString = Permissions.locationWhenInUse
            permissionPauseString = Permissions.Pause.locationWhenInUse
        } else if permission == .notification {
            permissionString = Permissions.notification
            permissionPauseString = Permissions.Pause.notification
        } else {
            return WKRPTCLPermissions.Data.Action.unknown
        }
        let defaultAction = WKRPTCLPermissions.Data.Action.unknown.rawValue
        var retval = WKRPTCLPermissions.Data
            .Action(rawValue: DNSCore.setting(for: permissionString,
                                              withDefault: defaultAction) as? String ?? "")
        let pauseCount = DNSCore.setting(for: permissionPauseString,
                                         withDefault: 0) as? Int ?? 0
        if (pauseCount >= Self.pauseSkippedRetryMax) && (retval == .skipped) {
            retval = .unknown
            DNSCore.setting(set: permissionPauseString,
                            with: 0)
        } else if (pauseCount >= Self.pauseDeniedRetryMax) && (retval == .denied) {
            retval = .unknown
            DNSCore.setting(set: permissionPauseString,
                            with: 0)
        } else {
            DNSCore.setting(set: permissionPauseString,
                            with: pauseCount + 1)
        }
        return retval ?? .unknown
    }
    func utilitySetting(for spPermission: Permission) -> WKRPTCLPermissions.Data.Action {
        if spPermission == .calendar {
            return self.utilitySetting(for: WKRPTCLPermissions.Data.System.calendar)
        } else if spPermission == .camera {
            return self.utilitySetting(for: WKRPTCLPermissions.Data.System.camera)
        } else if spPermission == .locationWhenInUse {
            return self.utilitySetting(for: WKRPTCLPermissions.Data.System.locationWhenInUse)
        } else if spPermission == .notification {
            return self.utilitySetting(for: WKRPTCLPermissions.Data.System.notification)
        }
        return WKRPTCLPermissions.Data.Action.unknown
    }
    func utilityShouldContinue(_ desire: WKRPTCLPermissions.Data.Desire,
                               _ permission: WKRPTCLPermissions.Data.System) -> Bool {
        switch desire {
        case .wouldLike:
            if self.utilitySetting(for: permission) == .skipped ||
                self.utilitySetting(for: permission) == .denied {
                return false
            }
            fallthrough
        case .want:
            if self.utilityMemorySetting(for: permission) == .skipped ||
                self.utilityMemorySetting(for: permission) == .denied {
                return false
            }
        case .need, .present:
            break
        }
        return true
    }
    func utilityShouldContinue(_ desire: WKRPTCLPermissions.Data.Desire,
                               _ permissions: [WKRPTCLPermissions.Data.System]) -> Bool {
        let pkPermissions = permissions.map { self.utilityConvert($0) }
        let pkPermissionsNotAuth = pkPermissions.filter { !$0.authorized }

        switch desire {
        case .wouldLike:
            let pkPermissionsNotSkipped = pkPermissionsNotAuth.filter {
                self.utilitySetting(for: $0) != .skipped &&
                self.utilitySetting(for: $0) != .denied
            }
            if pkPermissionsNotSkipped.isEmpty {
                return false
            }
            fallthrough
        case .want:
            let pkPermissionsNotSkipped = pkPermissionsNotAuth.filter {
                self.utilityMemorySetting(for: $0) != .skipped &&
                self.utilityMemorySetting(for: $0) != .denied
            }
            if pkPermissionsNotSkipped.isEmpty {
                return false
            }
        case .need, .present:
            break
        }
        return true
    }
    func utilityUpdateContinue(_ permissionAction: WKRPTCLPermissions.Data.Action,
                               for permission: WKRPTCLPermissions.Data.System) {
        self.utilityUpdateContinue(permissionAction,
                                   for: self.utilityConvert(permission))
    }
    func utilityUpdateContinue(_ permissionAction: WKRPTCLPermissions.Data.Action,
                               for permission: Permission) {
        switch dialogDesire {
        case .wouldLike:
            self.utilitySet(permissionAction,
                            for: permission)
            fallthrough
        case .want:
            self.utilityMemorySet(permissionAction,
                                  for: permission)
        case .need, .present:
            break
        }
    }
}
