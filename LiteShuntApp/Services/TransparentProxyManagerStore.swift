import Foundation
import NetworkExtension
import Observation
import LiteShuntSharedKit

@MainActor
@Observable
final class TransparentProxyManagerStore {
    private(set) var statusMessage = "尚未加载透明代理配置"
    private(set) var managerCount = 0
    private(set) var lastErrorMessage: String?

    var appGroupIdentifier: String {
        LiteShuntSharedConstants.appGroupIdentifier
    }

    var extensionBundleIdentifier: String {
        LiteShuntSharedConstants.extensionBundleIdentifier
    }

    func reloadManagers() async {
        do {
            let loadedManagerCount = try await loadManagerCount()
            managerCount = loadedManagerCount
            lastErrorMessage = nil
            if loadedManagerCount == 0 {
                statusMessage = "未发现已保存的透明代理配置"
            } else {
                statusMessage = "已读取 \(loadedManagerCount) 个透明代理配置"
            }
        } catch {
            managerCount = 0
            statusMessage = "透明代理配置加载失败"
            lastErrorMessage = error.localizedDescription
        }
    }

    private func loadManagerCount() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            NETransparentProxyManager.loadAllFromPreferences { managers, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: managers?.count ?? 0)
            }
        }
    }
}
