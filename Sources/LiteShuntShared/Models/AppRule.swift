import Foundation

public struct AppRule: Codable, Equatable, Sendable {
    public let bundleId: String
    public let signingIdentifier: String?
    public let displayName: String
    public let enabled: Bool
    public let routeMode: RouteMode

    public init(
        bundleId: String,
        signingIdentifier: String?,
        displayName: String,
        enabled: Bool,
        routeMode: RouteMode
    ) {
        self.bundleId = bundleId
        self.signingIdentifier = signingIdentifier
        self.displayName = displayName
        self.enabled = enabled
        self.routeMode = routeMode
    }
}
