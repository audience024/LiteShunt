import Foundation
import LiteShuntCore
import LiteShuntShared

@inline(__always)
func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() {
        fputs("校验失败: \(message)\n", stderr)
        exit(1)
    }
}

let validConfig = LiteShuntConfig.testFixture(
    appRules: [
        AppRule(
            bundleId: "com.example.browser",
            signingIdentifier: nil,
            displayName: "示例浏览器",
            enabled: true,
            routeMode: .proxy
        )
    ],
    exclusionRules: [
        ExclusionRule(
            matchType: .bundleId,
            value: "io.github.clash-verge-rev.clash-verge-rev"
        )
    ]
)

do {
    try validConfig.validate()
} catch {
    fputs("校验失败: 默认配置不应抛错，实际错误 \(error)\n", stderr)
    exit(1)
}

let classifier = FlowClassifier()

let proxyDecision = classifier.classify(
    request: FlowClassificationRequest(
        appIdentity: AppIdentity(bundleId: "com.example.browser", signingIdentifier: nil)
    ),
    config: validConfig
)
expect(proxyDecision == .proxy, "命中代理规则时应返回 proxy")

let bypassDecision = classifier.classify(
    request: FlowClassificationRequest(
        appIdentity: AppIdentity(
            bundleId: "io.github.clash-verge-rev.clash-verge-rev",
            signingIdentifier: nil
        )
    ),
    config: validConfig
)
expect(bypassDecision == .bypass, "命中排除名单时应返回 bypass")

let fallbackDecision = classifier.classify(
    request: FlowClassificationRequest(
        appIdentity: AppIdentity(bundleId: "com.example.unknown", signingIdentifier: nil)
    ),
    config: validConfig
)
expect(fallbackDecision == .bypass, "未命中规则时应返回 bypass")

print("LiteShunt 核心自校验通过")
