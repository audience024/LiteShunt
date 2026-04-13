import Foundation
import Testing
@testable import LiteShuntShared

struct LiteShuntConfigTests {
    @Test("默认配置校验通过")
    func 默认配置校验通过() throws {
        let config = LiteShuntConfig(
            version: 1,
            proxyConfig: ProxyConfig.standard,
            appRules: [
                AppRule(
                    bundleId: "com.example.browser",
                    signingIdentifier: "com.example.browser",
                    displayName: "示例浏览器",
                    enabled: true,
                    routeMode: .proxy
                )
            ],
            exclusionRules: [],
            runtimePolicy: .default,
            updatedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )

        try config.validate()
    }

    @Test("端口超出范围时校验失败")
    func 端口超出范围时校验失败() throws {
        let config = LiteShuntConfig(
            version: 1,
            proxyConfig: ProxyConfig(
                host: "127.0.0.1",
                port: 0,
                protocol: .socks5,
                connectTimeoutMs: 3000
            ),
            appRules: [],
            exclusionRules: [],
            runtimePolicy: .default,
            updatedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )

        do {
            try config.validate()
            Issue.record("预期端口非法时抛出错误，但实际校验通过")
        } catch {
            #expect(error as? LiteShuntConfigError == .invalidProxyPort(0))
        }
    }

    @Test("配置编码解码后保留关键字段")
    func 配置编码解码后保留关键字段() throws {
        let config = LiteShuntConfig(
            version: 2,
            proxyConfig: ProxyConfig(
                host: "127.0.0.1",
                port: 7890,
                protocol: .socks5,
                connectTimeoutMs: 5000
            ),
            appRules: [
                AppRule(
                    bundleId: "com.example.chat",
                    signingIdentifier: nil,
                    displayName: "聊天工具",
                    enabled: true,
                    routeMode: .proxy
                )
            ],
            exclusionRules: [
                ExclusionRule(
                    matchType: .bundleId,
                    value: "io.github.clash-verge-rev.clash-verge-rev"
                )
            ],
            runtimePolicy: .default,
            updatedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let data = try JSONEncoder().encode(config)
        let decoded = try JSONDecoder().decode(LiteShuntConfig.self, from: data)

        #expect(decoded.version == 2)
        #expect(decoded.proxyConfig.port == 7890)
        #expect(decoded.appRules.first?.bundleId == "com.example.chat")
        #expect(decoded.exclusionRules.first?.value == "io.github.clash-verge-rev.clash-verge-rev")
    }
}
