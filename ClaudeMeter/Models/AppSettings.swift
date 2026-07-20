//
//  AppSettings.swift
//  ClaudeMeter
//
//  Created by Edd on 2025-11-14.
//

import Foundation

/// Which usage limit drives the percentage shown in the menu bar
enum MenuBarMetric: String, Codable, CaseIterable, Sendable {
    case session
    case weekly
    case fable

    var displayName: String {
        switch self {
        case .session: "5-Hour Session"
        case .weekly: "Weekly"
        case .fable: "Fable"
        }
    }
}

/// User preferences and app configuration
struct AppSettings: Codable, Equatable, Sendable {
    /// Refresh interval in seconds (60-600)
    var refreshInterval: TimeInterval

    /// Whether notifications are enabled
    var hasNotificationsEnabled: Bool

    /// Notification thresholds
    var notificationThresholds: NotificationThresholds

    /// Whether this is first launch
    var isFirstLaunch: Bool

    /// Last known organization ID (cached)
    var cachedOrganizationId: UUID?

    /// Whether to show Sonnet usage in the popover
    var isSonnetUsageShown: Bool

    /// Whether to show Fable usage in the popover
    var isFableUsageShown: Bool

    /// Menu bar icon display style
    var iconStyle: IconStyle

    /// Which usage limit the menu bar percentage reflects
    var menuBarMetric: MenuBarMetric

    /// Whether menu bar icons are shown in color instead of monochrome.
    var isColoredIcon: Bool

    static let `default` = AppSettings(
        refreshInterval: 60,
        hasNotificationsEnabled: true,
        notificationThresholds: .default,
        isFirstLaunch: true,
        cachedOrganizationId: nil,
        isSonnetUsageShown: false,
        isFableUsageShown: true,
        iconStyle: .battery,
        menuBarMetric: .session,
        isColoredIcon: true
    )

    enum CodingKeys: String, CodingKey {
        case refreshInterval = "refresh_interval"
        case hasNotificationsEnabled = "notifications_enabled"
        case notificationThresholds = "notification_thresholds"
        case isFirstLaunch = "is_first_launch"
        case cachedOrganizationId = "cached_organization_id"
        case isSonnetUsageShown = "show_sonnet_usage"
        case isFableUsageShown = "show_fable_usage"
        case iconStyle = "icon_style"
        case menuBarMetric = "menu_bar_metric"
        case isColoredIcon = "is_colored_icon"
    }
}

extension AppSettings {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let defaults = AppSettings.default

        refreshInterval = try container.decodeIfPresent(TimeInterval.self, forKey: .refreshInterval) ?? defaults.refreshInterval
        hasNotificationsEnabled = try container.decodeIfPresent(Bool.self, forKey: .hasNotificationsEnabled) ?? defaults.hasNotificationsEnabled
        notificationThresholds = try container.decodeIfPresent(NotificationThresholds.self, forKey: .notificationThresholds) ?? defaults.notificationThresholds
        isFirstLaunch = try container.decodeIfPresent(Bool.self, forKey: .isFirstLaunch) ?? defaults.isFirstLaunch
        cachedOrganizationId = try container.decodeIfPresent(UUID.self, forKey: .cachedOrganizationId)
        isSonnetUsageShown = try container.decodeIfPresent(Bool.self, forKey: .isSonnetUsageShown) ?? defaults.isSonnetUsageShown
        isFableUsageShown = try container.decodeIfPresent(Bool.self, forKey: .isFableUsageShown) ?? defaults.isFableUsageShown
        iconStyle = try container.decodeIfPresent(IconStyle.self, forKey: .iconStyle) ?? defaults.iconStyle
        menuBarMetric = try container.decodeIfPresent(MenuBarMetric.self, forKey: .menuBarMetric) ?? defaults.menuBarMetric
        isColoredIcon = try container.decodeIfPresent(Bool.self, forKey: .isColoredIcon) ?? defaults.isColoredIcon
    }
}

extension AppSettings {
    /// Validate refresh interval is within bounds
    mutating func setRefreshInterval(_ interval: TimeInterval) {
        refreshInterval = max(60, min(600, interval))
    }
}
