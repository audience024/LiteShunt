import Foundation

public enum LiteShuntConfigError: Error, Equatable {
    case invalidProxyHost
    case invalidProxyPort(Int)
    case invalidConnectTimeout(Int)
}
