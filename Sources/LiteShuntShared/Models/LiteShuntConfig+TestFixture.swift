import Foundation

public extension LiteShuntConfig {
    static func testFixture(
        version: Int = LiteShuntDefaults.initialConfigVersion,
        proxyConfig: ProxyConfig = .standard,
        appRules: [AppRule] = [],
        exclusionRules: [ExclusionRule] = [],
        runtimePolicy: RuntimePolicy = .default,
        updatedAt: Date = Date(timeIntervalSince1970: 1_700_000_000)
    ) -> LiteShuntConfig {
        LiteShuntConfig(
            version: version,
            proxyConfig: proxyConfig,
            appRules: appRules,
            exclusionRules: exclusionRules,
            runtimePolicy: runtimePolicy,
            updatedAt: updatedAt
        )
    }
}
