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
        // 本轮 POC 只验证扩展能被宿主加载并进入生命周期入口，
        // 暂不在这里实现 SOCKS5 建链、回环规避和 FAIL_CLOSED 细节。
        logger.info("透明代理扩展启动，POC 模式暂不安装透明代理网络规则")
        completionHandler(nil)
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
        // 这里保留最小入口，下一轮再接入规则分类、SOCKS5 转发与失败策略。
        logger.info("收到新的 App Proxy Flow，POC 模式下直接交还系统处理")
        return false
    }
}
