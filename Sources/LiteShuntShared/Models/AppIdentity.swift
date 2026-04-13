import Foundation

public struct AppIdentity: Codable, Equatable, Sendable {
    public let bundleId: String
    public let signingIdentifier: String?

    public init(bundleId: String, signingIdentifier: String?) {
        self.bundleId = bundleId
        self.signingIdentifier = signingIdentifier
    }
}
