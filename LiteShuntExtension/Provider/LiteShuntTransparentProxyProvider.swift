import Foundation
import NetworkExtension
import OSLog
import LiteShuntSharedKit

final class LiteShuntTransparentProxyProvider: NETransparentProxyProvider {
    private let logger = Logger(
        subsystem: LiteShuntSharedConstants.appBundleIdentifier,
        category: "TransparentProxyProvider"
    )

    override func startProxy(
        options: [String: Any]?,
        completionHandler: @escaping (Error?) -> Void
    ) {
        let optionKeys = options?.keys.sorted().joined(separator: ",") ?? "无"
        logger.info("透明代理扩展启动，options keys: \(optionKeys, privacy: .public)")

        if let providerProtocol = protocolConfiguration as? NETunnelProviderProtocol {
            let providerSummary = providerConfigurationSummary(from: providerProtocol)
            logger.info("已读取宿主写入的透明代理配置：\(providerSummary, privacy: .public)")
        } else {
            logger.error("当前 protocolConfiguration 不是 NETunnelProviderProtocol，无法读取宿主侧 providerConfiguration")
        }

        let settings = makePOCNetworkSettings()
        setTunnelNetworkSettings(settings) { [weak self] error in
            guard let self else {
                completionHandler(error)
                return
            }

            if let error {
                self.logger.error("安装透明代理网络规则失败：\(error.localizedDescription, privacy: .public)")
                completionHandler(error)
                return
            }

            self.logger.info("透明代理 POC 规则安装成功，将开始采集首个真实 TCP Flow")

            // 本轮 POC 只验证首个真实 TCP Flow 的来源应用身份采集，
            // 暂不在这里实现 SOCKS5 建链、回环规避和 FAIL_CLOSED 细节。
            completionHandler(nil)
        }
    }

    override func stopProxy(
        with reason: NEProviderStopReason,
        completionHandler: @escaping () -> Void
    ) {
        logger.info("透明代理扩展停止，停止原因：\(reason.rawValue)")
        completionHandler()
    }

    override func handleAppMessage(
        _ messageData: Data,
        completionHandler: ((Data?) -> Void)?
    ) {
        logger.debug("收到宿主应用消息，长度：\(messageData.count)")
        completionHandler?(messageData)
    }

    override func handleNewFlow(_ flow: NEAppProxyFlow) -> Bool {
        // 对 Transparent Proxy Provider 来说，返回 false 会把流量交还给系统直连。
        // 本轮先记录来源应用身份和目标端点，验证真实 Flow 是否进入扩展。
        let identitySummary = self.flowIdentitySummary(flow)
        let diagnosticSummary = self.flowDiagnosticSummary(flow)

        logger.info("收到新的 App Proxy Flow：\(identitySummary, privacy: .public)")
        logger.debug("Flow 详细诊断：\(diagnosticSummary, privacy: .private)")
        return false
    }

    private func makePOCNetworkSettings() -> NETransparentProxyNetworkSettings {
        let settings = NETransparentProxyNetworkSettings(
            tunnelRemoteAddress: LiteShuntSharedConstants.clashVergeLoopbackHost
        )

        // 使用“全部出站 TCP”作为最小 POC 捕获面，先证明真实 Flow 能进入扩展。
        // 后续再在 RuntimeGuard 中补完整的自旁路、Clash 旁路和 FAIL_CLOSED 行为。
        settings.includedNetworkRules = [
            NENetworkRule(
                __remoteNetwork: nil,
                remotePrefix: 0,
                localNetwork: nil,
                localPrefix: 0,
                protocol: .TCP,
                direction: .outbound
            )
        ]

        return settings
    }

    private func providerConfigurationSummary(from providerProtocol: NETunnelProviderProtocol) -> String {
        let serverAddress = providerProtocol.serverAddress ?? "未设置"
        let providerBundleIdentifier = providerProtocol.providerBundleIdentifier ?? "未设置"
        let configVersion = providerProtocol.providerConfiguration?[LiteShuntSharedConstants.providerConfigurationConfigVersionKey] ?? "未设置"
        let captureStrategy = providerProtocol.providerConfiguration?[LiteShuntSharedConstants.providerConfigurationCaptureStrategyKey] ?? "未设置"

        return "bundle=\(providerBundleIdentifier) server=\(serverAddress) version=\(configVersion) capture=\(captureStrategy)"
    }

    private func flowIdentitySummary(_ flow: NEAppProxyFlow) -> String {
        let metaData = flow.metaData
        let signingIdentifier = sanitized(value: metaData.sourceAppSigningIdentifier)
        let uniqueIdentifierPreview = hexadecimalPrefix(for: metaData.sourceAppUniqueIdentifier)
        let remoteHostname = sanitized(value: flow.remoteHostname)
        let flowType = flowTypeDescription(flow)

        return "type=\(flowType) signingId=\(signingIdentifier) uniqueIdPrefix=\(uniqueIdentifierPreview) remoteHost=\(remoteHostname)"
    }

    private func flowDiagnosticSummary(_ flow: NEAppProxyFlow) -> String {
        let metaData = flow.metaData
        let sourceAuditTokenLength = metaData.sourceAppAuditToken?.count ?? 0
        let remoteEndpoint = endpointSummary(for: flow)
        let providerEndpoint = localEndpointSummary(for: flow)

        return "remoteEndpoint=\(remoteEndpoint) localEndpoint=\(providerEndpoint) auditTokenBytes=\(sourceAuditTokenLength)"
    }

    private func flowTypeDescription(_ flow: NEAppProxyFlow) -> String {
        if flow is NEAppProxyTCPFlow {
            return "tcp"
        }

        if flow is NEAppProxyUDPFlow {
            return "udp"
        }

        return String(describing: type(of: flow))
    }

    private func endpointSummary(for flow: NEAppProxyFlow) -> String {
        if let tcpFlow = flow as? NEAppProxyTCPFlow {
            if #available(macOS 15.0, *) {
                return tcpFlow.remoteFlowEndpoint.debugDescription
            }

            return "macOS14-无法直接读取 TCP remote endpoint"
        }

        if flow is NEAppProxyUDPFlow {
            return "UDP Flow 需通过 handleNewUDPFlow 的 initialRemoteFlowEndpoint 读取"
        }

        return "unknown"
    }

    private func localEndpointSummary(for flow: NEAppProxyFlow) -> String {
        if let tcpFlow = flow as? NEAppProxyTCPFlow {
            _ = tcpFlow
            return "TCP Flow 无公开 local endpoint"
        }

        if let udpFlow = flow as? NEAppProxyUDPFlow {
            if #available(macOS 15.0, *) {
                return udpFlow.localFlowEndpoint?.debugDescription ?? "nil"
            }

            return "macOS14-无法直接读取 UDP local endpoint"
        }

        return "unknown"
    }

    private func sanitized(value: String?) -> String {
        guard let value, !value.isEmpty else {
            return "unknown"
        }

        return value
    }

    private func hexadecimalPrefix(for data: Data) -> String {
        guard !data.isEmpty else {
            return "empty"
        }

        return data.prefix(6).map { String(format: "%02x", $0) }.joined()
    }
}
