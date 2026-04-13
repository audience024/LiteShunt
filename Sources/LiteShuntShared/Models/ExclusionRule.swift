import Foundation

public struct ExclusionRule: Codable, Equatable, Sendable {
    public let matchType: ExclusionMatchType
    public let value: String

    public init(matchType: ExclusionMatchType, value: String) {
        self.matchType = matchType
        self.value = value
    }

    public func matches(appIdentity: AppIdentity) -> Bool {
        switch matchType {
        case .bundleId:
            return appIdentity.bundleId == value
        case .signingIdentifier:
            return appIdentity.signingIdentifier == value
        }
    }
}
