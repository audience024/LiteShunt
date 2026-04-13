import Foundation

public struct ProxyConfig: Codable, Equatable, Sendable {
    public let host: String
    public let port: Int
    public let `protocol`: ProxyTransportProtocol
    public let connectTimeoutMs: Int

    public init(host: String, port: Int, protocol: ProxyTransportProtocol, connectTimeoutMs: Int) {
        self.host = host
        self.port = port
        self.protocol = `protocol`
        self.connectTimeoutMs = connectTimeoutMs
    }

    public static let standard = ProxyConfig(
        host: LiteShuntDefaults.proxyHost,
        port: LiteShuntDefaults.proxyPort,
        protocol: .socks5,
        connectTimeoutMs: LiteShuntDefaults.connectTimeoutMs
    )
}
