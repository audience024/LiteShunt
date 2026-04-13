import Foundation

public struct RuntimePolicy: Codable, Equatable, Sendable {
    public let selectedAppsFailStrategy: SelectedAppProxyFailureStrategy
    public let selfBypassEnabled: Bool
    public let clashBypassEnabled: Bool

    public init(
        selectedAppsFailStrategy: SelectedAppProxyFailureStrategy,
        selfBypassEnabled: Bool,
        clashBypassEnabled: Bool
    ) {
        self.selectedAppsFailStrategy = selectedAppsFailStrategy
        self.selfBypassEnabled = selfBypassEnabled
        self.clashBypassEnabled = clashBypassEnabled
    }

    public static let `default` = RuntimePolicy(
        selectedAppsFailStrategy: .failClosed,
        selfBypassEnabled: true,
        clashBypassEnabled: true
    )
}
