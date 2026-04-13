import Testing
@testable import LiteShuntCore
import LiteShuntShared

struct FlowClassifierTests {
    @Test("命中排除名单时返回 Bypass")
    func 命中排除名单时返回Bypass() {
        let classifier = FlowClassifier()
        let request = FlowClassificationRequest(
            appIdentity: AppIdentity(
                bundleId: "io.github.clash-verge-rev.clash-verge-rev",
                signingIdentifier: nil
            )
        )
        let config = LiteShuntConfig.testFixture(
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
                ExclusionRule(matchType: .bundleId, value: "io.github.clash-verge-rev.clash-verge-rev")
            ]
        )

        let decision = classifier.classify(request: request, config: config)

        #expect(decision == .bypass)
    }

    @Test("命中代理规则时返回 Proxy")
    func 命中代理规则时返回Proxy() {
        let classifier = FlowClassifier()
        let request = FlowClassificationRequest(
            appIdentity: AppIdentity(
                bundleId: "com.example.browser",
                signingIdentifier: nil
            )
        )
        let config = LiteShuntConfig.testFixture(
            appRules: [
                AppRule(
                    bundleId: "com.example.browser",
                    signingIdentifier: nil,
                    displayName: "示例浏览器",
                    enabled: true,
                    routeMode: .proxy
                )
            ]
        )

        let decision = classifier.classify(request: request, config: config)

        #expect(decision == .proxy)
    }

    @Test("命中直连规则时返回 Bypass")
    func 命中直连规则时返回Bypass() {
        let classifier = FlowClassifier()
        let request = FlowClassificationRequest(
            appIdentity: AppIdentity(
                bundleId: "com.example.browser",
                signingIdentifier: nil
            )
        )
        let config = LiteShuntConfig.testFixture(
            appRules: [
                AppRule(
                    bundleId: "com.example.browser",
                    signingIdentifier: nil,
                    displayName: "示例浏览器",
                    enabled: true,
                    routeMode: .direct
                )
            ]
        )

        let decision = classifier.classify(request: request, config: config)

        #expect(decision == .bypass)
    }

    @Test("未命中规则时返回 Bypass")
    func 未命中规则时返回Bypass() {
        let classifier = FlowClassifier()
        let request = FlowClassificationRequest(
            appIdentity: AppIdentity(
                bundleId: "com.example.unknown",
                signingIdentifier: nil
            )
        )
        let config = LiteShuntConfig.testFixture(
            appRules: [
                AppRule(
                    bundleId: "com.example.browser",
                    signingIdentifier: nil,
                    displayName: "示例浏览器",
                    enabled: true,
                    routeMode: .proxy
                )
            ]
        )

        let decision = classifier.classify(request: request, config: config)

        #expect(decision == .bypass)
    }

    @Test("命中禁用规则时返回 Bypass")
    func 命中禁用规则时返回Bypass() {
        let classifier = FlowClassifier()
        let request = FlowClassificationRequest(
            appIdentity: AppIdentity(
                bundleId: "com.example.browser",
                signingIdentifier: nil
            )
        )
        let config = LiteShuntConfig.testFixture(
            appRules: [
                AppRule(
                    bundleId: "com.example.browser",
                    signingIdentifier: nil,
                    displayName: "示例浏览器",
                    enabled: false,
                    routeMode: .proxy
                )
            ]
        )

        let decision = classifier.classify(request: request, config: config)

        #expect(decision == .bypass)
    }
}
