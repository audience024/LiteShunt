import SwiftUI

struct StatusView: View {
    @State private var managerStore = TransparentProxyManagerStore()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("LiteShunt POC")
                .font(.largeTitle.weight(.semibold))

            Text("当前目标是验证 Transparent Proxy Extension 的最小工程骨架与生命周期入口。")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                LabeledContent("配置状态", value: managerStore.statusMessage)
                LabeledContent("已加载配置数", value: "\(managerStore.managerCount)")
                LabeledContent("最近配置摘要", value: managerStore.lastSavedConfigurationSummary)
                LabeledContent("App Group", value: managerStore.appGroupIdentifier)
                LabeledContent(
                    "扩展标识",
                    value: managerStore.extensionBundleIdentifier
                )
            }
            .textSelection(.enabled)

            if let errorMessage = managerStore.lastErrorMessage {
                Text("最近错误：\(errorMessage)")
                    .foregroundStyle(.red)
                    .textSelection(.enabled)
            }

            HStack(spacing: 12) {
                Button("写入 POC 配置") {
                    Task {
                        await managerStore.savePOCConfiguration()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(managerStore.isPerformingOperation)

                Button("重新加载透明代理配置") {
                    Task {
                        await managerStore.reloadManagers()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(managerStore.isPerformingOperation)
            }

            Spacer()
        }
        .padding(24)
        .task {
            await managerStore.reloadManagers()
        }
    }
}

#Preview {
    StatusView()
}
