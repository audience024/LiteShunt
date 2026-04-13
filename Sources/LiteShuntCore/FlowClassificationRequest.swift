import Foundation
import LiteShuntShared

public struct FlowClassificationRequest: Sendable {
    public let appIdentity: AppIdentity?

    public init(appIdentity: AppIdentity?) {
        self.appIdentity = appIdentity
    }
}
