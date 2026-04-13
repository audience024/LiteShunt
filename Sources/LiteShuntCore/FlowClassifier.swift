import Foundation
import LiteShuntShared

public struct FlowClassifier: Sendable {
    public init() {}

    public func classify(request: FlowClassificationRequest, config: LiteShuntConfig) -> FlowDecision {
        guard let appIdentity = request.appIdentity else {
            return .bypass
        }

        if config.exclusionRules.contains(where: { $0.matches(appIdentity: appIdentity) }) {
            return .bypass
        }

        guard let matchedRule = matchedRule(for: appIdentity, rules: config.appRules) else {
            return .bypass
        }

        guard matchedRule.enabled else {
            return .bypass
        }

        switch matchedRule.routeMode {
        case .proxy:
            return .proxy
        case .direct:
            return .bypass
        }
    }

    private func matchedRule(for appIdentity: AppIdentity, rules: [AppRule]) -> AppRule? {
        if let signingIdentifier = appIdentity.signingIdentifier {
            if let rule = rules.first(where: { $0.signingIdentifier == signingIdentifier }) {
                return rule
            }
        }

        return rules.first(where: { $0.bundleId == appIdentity.bundleId })
    }
}
