import Foundation
import NetworkExtension
import Observation
import LiteShuntSharedKit

// Apple 文档明确说明 NETransparentProxyManager 实例是线程安全的，
// 这里为了通过 Swift 6 的 sendable 检查，显式声明为 @unchecked Sendable。
extension NETransparentProxyManager: @unchecked Sendable {}

@MainActor
@Observable
final class TransparentProxyManagerStore {
    private(set) var statusMessage = "尚未加载透明代理配置"
    private(set) var managerCount = 0
    private(set) var lastErrorMessage: String?
    private(set) var lastSavedConfigurationSummary = "尚未写入 POC 配置"
    private(set) var isPerformingOperation = false

    var appGroupIdentifier: String {
        LiteShuntSharedConstants.appGroupIdentifier
    }

    var extensionBundleIdentifier: String {
        LiteShuntSharedConstants.extensionBundleIdentifier
    }

    func reloadManagers() async {
        isPerformingOperation = true
        statusMessage = "正在加载透明代理配置"

        do {
            let managers = try await loadManagers()
            managerCount = managers.count
            lastErrorMessage = nil

            if let firstManager = managers.first {
                lastSavedConfigurationSummary = configurationSummary(for: firstManager)
            } else {
                lastSavedConfigurationSummary = "尚未写入 POC 配置"
            }

            if managers.isEmpty {
                statusMessage = "未发现已保存的透明代理配置"
            } else {
                statusMessage = "已读取 \(managers.count) 个透明代理配置"
            }
        } catch {
            managerCount = 0
            statusMessage = "透明代理配置加载失败"
            lastErrorMessage = error.localizedDescription
        }

        isPerformingOperation = false
    }

    func savePOCConfiguration() async {
        isPerformingOperation = true
        statusMessage = "正在写入 POC 配置"

        do {
            let manager = try await loadOrCreateManager()
            let providerProtocol = makeProviderProtocol()

            manager.localizedDescription = LiteShuntSharedConstants.transparentProxyLocalizedDescription
            manager.protocolConfiguration = providerProtocol
            manager.isEnabled = true
            manager.isOnDemandEnabled = false

            try await save(manager: manager)

            statusMessage = "POC 配置写入成功"
            lastErrorMessage = nil
            lastSavedConfigurationSummary = configurationSummary(for: manager)
            await reloadManagers()
        } catch {
            statusMessage = "POC 配置写入失败"
            lastErrorMessage = error.localizedDescription
            isPerformingOperation = false
        }
    }

    private func loadManagers() async throws -> [NETransparentProxyManager] {
        try await withCheckedThrowingContinuation { continuation in
            NETransparentProxyManager.loadAllFromPreferences { managers, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: managers ?? [])
            }
        }
    }

    private func loadOrCreateManager() async throws -> NETransparentProxyManager {
        let managers = try await loadManagers()
        if let manager = managers.first {
            try await load(manager: manager)
            return manager
        }

        return NETransparentProxyManager()
    }

    private func load(manager: NETransparentProxyManager) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            manager.loadFromPreferences { error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: ())
            }
        }
    }

    private func save(manager: NETransparentProxyManager) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            manager.saveToPreferences { error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: ())
            }
        }
    }

    private func makeProviderProtocol() -> NETunnelProviderProtocol {
        let providerProtocol = NETunnelProviderProtocol()

        providerProtocol.providerBundleIdentifier = extensionBundleIdentifier
        providerProtocol.serverAddress = "\(LiteShuntSharedConstants.clashVergeLoopbackHost):\(LiteShuntSharedConstants.clashVergeDefaultPort)"
        providerProtocol.disconnectOnSleep = false
        providerProtocol.providerConfiguration = [
            LiteShuntSharedConstants.providerConfigurationAppGroupIdentifierKey: appGroupIdentifier,
            LiteShuntSharedConstants.providerConfigurationConfigVersionKey: LiteShuntSharedConstants.transparentProxyProviderConfigurationVersion,
            LiteShuntSharedConstants.providerConfigurationCaptureStrategyKey: LiteShuntSharedConstants.metadataOnlyCaptureStrategy,
            LiteShuntSharedConstants.providerConfigurationDiagnosticModeKey: true,
            LiteShuntSharedConstants.providerConfigurationCreatedAtKey: ISO8601DateFormatter().string(from: Date()),
            LiteShuntSharedConstants.providerConfigurationHostKey: LiteShuntSharedConstants.clashVergeLoopbackHost,
            LiteShuntSharedConstants.providerConfigurationPortKey: LiteShuntSharedConstants.clashVergeDefaultPort
        ]

        return providerProtocol
    }

    private func configurationSummary(for manager: NETransparentProxyManager) -> String {
        guard let providerProtocol = manager.protocolConfiguration as? NETunnelProviderProtocol else {
            return "已读取配置，但协议类型不是 NETunnelProviderProtocol"
        }

        let description = manager.localizedDescription ?? "未命名配置"
        let serverAddress = providerProtocol.serverAddress ?? "未设置"
        let version = providerProtocol.providerConfiguration?[LiteShuntSharedConstants.providerConfigurationConfigVersionKey] ?? "未设置"
        let captureStrategy = providerProtocol.providerConfiguration?[LiteShuntSharedConstants.providerConfigurationCaptureStrategyKey] ?? "未设置"

        return "\(description) | server=\(serverAddress) | version=\(version) | capture=\(captureStrategy)"
    }
}
