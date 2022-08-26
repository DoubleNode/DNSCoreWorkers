//
//  WKRCorePermissions+Strings.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSCoreWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation
import SPPermissions

public class WKRCorePermissionsStrings: SPPermissionsTextProtocol {
    // swiftlint:disable:next cyclomatic_complexity
    public func name(for permission: SPPermission) -> String {
        switch permission {
        #if os(iOS)
        case .camera:
            return NSLocalizedString("CorePermissionsNameCamera", comment: "CorePermissionsNameCamera")
        case .photoLibrary:
            return NSLocalizedString("CorePermissionsNamePhotoLibrary", comment: "CorePermissionsNamePhotoLibrary")
        case .microphone:
            return NSLocalizedString("CorePermissionsNameMicrophone", comment: "CorePermissionsNameMicrophone")
        case .calendar:
            return NSLocalizedString("CorePermissionsNameCalendar", comment: "CorePermissionsNameCalendar")
        case .contacts:
            return NSLocalizedString("CorePermissionsNameContacts", comment: "CorePermissionsNameContacts")
        case .reminders:
            return NSLocalizedString("CorePermissionsNameReminders", comment: "CorePermissionsNameReminders")
        case .speech:
            return NSLocalizedString("CorePermissionsNameSpeech", comment: "CorePermissionsNameSpeech")
        case .locationAlwaysAndWhenInUse:
            return NSLocalizedString("CorePermissionsNameLocationAlways", comment: "CorePermissionsNameLocationAlways")
        case .motion:
            return NSLocalizedString("CorePermissionsNameMotion", comment: "CorePermissionsNameMotion")
        case .mediaLibrary:
            return NSLocalizedString("CorePermissionsNameMediaLibrary", comment: "CorePermissionsNameMediaLibrary")
        case .bluetooth:
            return NSLocalizedString("CorePermissionsNameBluetooth", comment: "CorePermissionsNameBluetooth")
        #endif
        case .notification:
            return NSLocalizedString("CorePermissionsNameNotification", comment: "CorePermissionsNameNotification")
        case .locationWhenInUse:
            return NSLocalizedString("CorePermissionsNameLocationWhenUse", comment: "CorePermissionsNameLocationWhenUse")
        case .tracking:
            return NSLocalizedString("CorePermissionsNameTracking", comment: "CorePermissionsNameTracking")
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func description(for permission: SPPermission) -> String {
        // swiftlint:disable line_length
        switch permission {
        #if os(iOS)
        case .camera:
            return NSLocalizedString("CorePermissionsDescriptionCamera", comment: "CorePermissionsDescriptionCamera")
        case .calendar:
            return NSLocalizedString("CorePermissionsDescriptionCalendar", comment: "CorePermissionsDescriptionCalendar")
        case .contacts:
            return NSLocalizedString("CorePermissionsDescriptionContacts", comment: "CorePermissionsDescriptionContacts")
        case .microphone:
            return NSLocalizedString("CorePermissionsDescriptionMicrophone", comment: "CorePermissionsDescriptionMicrophone")
        case .photoLibrary:
            return NSLocalizedString("CorePermissionsDescriptionPhotoLibrary", comment: "CorePermissionsDescriptionPhotoLibrary")
        case .reminders:
            return NSLocalizedString("CorePermissionsDescriptionReminders", comment: "CorePermissionsDescriptionReminders")
        case .speech:
            return NSLocalizedString("CorePermissionsDescriptionSpeech", comment: "CorePermissionsDescriptionSpeech")
        case .locationAlwaysAndWhenInUse:
            return NSLocalizedString("CorePermissionsDescriptionLocationAlways", comment: "CorePermissionsDescriptionLocationAlways")
        case .motion:
            return NSLocalizedString("CorePermissionsDescriptionMotion", comment: "CorePermissionsDescriptionMotion")
        case .mediaLibrary:
            return NSLocalizedString("CorePermissionsDescriptionMediaLibrary", comment: "CorePermissionsDescriptionMediaLibrary")
        case .bluetooth:
            return NSLocalizedString("CorePermissionsDescriptionBluetooth", comment: "CorePermissionsDescriptionBluetooth")
        #endif
        case .notification:
            return NSLocalizedString("CorePermissionsDescriptionNotification", comment: "CorePermissionsDescriptionNotification")
        case .locationWhenInUse:
            return NSLocalizedString("CorePermissionsDescriptionLocationWhenUse", comment: "CorePermissionsDescriptionLocationWhenUse")
        case .tracking:
            return NSLocalizedString("CorePermissionsDescriptionTracking", comment: "CorePermissionsDescriptionTracking")
        }
        // swiftlint:enable line_length
    }

    // swiftlint:disable line_length
    public let titleText: String = NSLocalizedString("CorePermissionsTitle", comment: "CorePermissionsTitle")
    public let subtitleText: String = NSLocalizedString("CorePermissionsSubtitle", comment: "CorePermissionsSubtitle")
    public let subtitleShortText: String = NSLocalizedString("CorePermissionsSubtitleShort", comment: "CorePermissionsSubtitleShort")
    public let commentText: String = NSLocalizedString("CorePermissionsComment", comment: "CorePermissionsComment")

    public let allow: String = NSLocalizedString("CorePermissionsAllow", comment: "CorePermissionsAllow")
    public let allowed: String = NSLocalizedString("CorePermissionsAllowed", comment: "CorePermissionsAllowed")
    // swiftlint:enable line_length
}
