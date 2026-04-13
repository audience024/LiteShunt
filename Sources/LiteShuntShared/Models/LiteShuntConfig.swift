import Foundation

public struct LiteShuntConfig: Codable, Equatable, Sendable {
    public let version: Int
    public let proxyConfig: ProxyConfig
    public let appRules: [AppRule]
    public let exclusionRules: [ExclusionRule]
    public let runtimePolicy: RuntimePolicy
    public let updatedAt: Date

    public init(
        version: Int,
        proxyConfig: ProxyConfig,
        appRules: [AppRule],
        exclusionRules: [ExclusionRule],
        runtimePolicy: RuntimePolicy,
        updatedAt: Date
    ) {
        self.version = version
        self.proxyConfig = proxyConfig
        self.appRules = appRules
        self.exclusionRules = exclusionRules
        self.runtimePolicy = runtimePolicy
        self.updatedAt = updatedAt
    }

    public func validate() throws {
        if proxyConfig.host.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw LiteShuntConfigError.invalidProxyHost
        }

        if !(1...65_535).contains(proxyConfig.port) {
            throw LiteShuntConfigError.invalidProxyPort(proxyConfig.port)
        }

        if proxyConfig.connectTimeoutMs <= 0 {
            throw LiteShuntConfigError.invalidConnectTimeout(proxyConfig.connectTimeoutMs)
        }
    }
}
