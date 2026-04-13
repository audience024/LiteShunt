import Foundation

public enum FlowDecision: Equatable, Sendable {
    case bypass
    case proxy
    case reject
}
