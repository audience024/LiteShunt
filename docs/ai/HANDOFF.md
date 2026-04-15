# 实现交接记录

## 1. 本轮目标

`POC-001：搭建最小 Xcode 工程，验证 LiteShunt Transparent Proxy Extension 可成功构建、可被宿主配置并具备接收首个 TCP Flow 的代码入口。`

## 2. 已完成内容

- 已新增正式 `LiteShunt.xcodeproj`，包含 `LiteShuntApp`、`LiteShuntExtension`、`LiteShuntSharedKit`、`LiteShuntPOCTests` 四个 Target。
- 已新增共享 Scheme：`LiteShuntApp`。
- 已建立宿主应用最小 SwiftUI 入口、透明代理扩展最小 `NETransparentProxyProvider` 子类，以及共享常量与 POC 测试骨架。
- 已新增 `script/generate_xcodeproj.rb` 用于通过本机 `xcodeproj` gem 生成工程。
- 已新增 `script/build_and_run.sh`，可执行工程级构建、启动与验证。
- 已新增 `.codex/environments/environment.toml`，为 Codex App 提供 `Run` 动作入口。

## 3. 修改文件

请逐项列出本轮修改的文件与原因：

- `LiteShunt.xcodeproj/project.pbxproj`：正式 Xcode 工程文件。
- `LiteShunt.xcodeproj/xcshareddata/xcschemes/LiteShuntApp.xcscheme`：共享 Scheme，供 `xcodebuild` 与 Run 动作使用。
- `LiteShuntApp/App/LiteShuntApp.swift`：宿主应用入口。
- `LiteShuntApp/Features/Status/StatusView.swift`：最小 POC 状态页。
- `LiteShuntApp/Services/TransparentProxyManagerStore.swift`：宿主侧最小透明代理配置读取逻辑。
- `LiteShuntApp/Resources/Info.plist`：宿主应用 Info 配置。
- `LiteShuntApp/Resources/LiteShuntApp.entitlements`：宿主应用 App Group / NetworkExtension entitlement 占位。
- `LiteShuntExtension/Provider/LiteShuntTransparentProxyProvider.swift`：透明代理扩展生命周期与新 Flow 入口。
- `LiteShuntExtension/Resources/Info.plist`：扩展 Info 配置。
- `LiteShuntExtension/Resources/LiteShuntExtension.entitlements`：扩展 App Group / NetworkExtension entitlement 占位。
- `LiteShuntShared/Constants/LiteShuntSharedConstants.swift`：POC 共享常量。
- `LiteShuntTests/POCTests/LiteShuntPOCTests.swift`：Xcode 测试 Target 的最小测试样例。
- `LiteShuntTests/Resources/Info.plist`：测试 Bundle 配置。
- `script/generate_xcodeproj.rb`：工程生成脚本。
- `script/build_and_run.sh`：统一构建 / 运行 / 验证脚本。
- `.codex/environments/environment.toml`：Codex Run 动作配置。

## 4. 执行过的验证

请写实际执行过的命令和结果，不要写“理论可行”：

- `swift build`：通过。
- `swift test`：通过，8 个测试全部通过。
- `swift run LiteShuntSmokeTests`：通过，输出 `LiteShunt 核心自校验通过`。
- `ruby script/generate_xcodeproj.rb`：通过，成功生成 `LiteShunt.xcodeproj`。
- `xcodebuild -list -project LiteShunt.xcodeproj`：通过，成功识别 4 个 Target 和 `LiteShuntApp` Scheme。
- `./script/build_and_run.sh --build-only`：通过，`LiteShuntApp.app` 与 `LiteShuntExtension.appex` 成功构建。
- `./script/build_and_run.sh --verify`：通过，脚本返回 0，说明构建后应用可被启动并通过进程存在性校验。

## 5. 已知问题

- 当前尚未验证真实的透明代理规则安装与首个 TCP Flow 的系统级捕获，只完成了扩展生命周期入口与工程级构建验证。
- 当前 entitlement 中使用的 `app-proxy-provider` 是依据本机 SDK 模板与 `NETransparentProxyManager` / `NETransparentProxyProvider` 关系做的 POC 级推断；进入真实配置与签名联调前，需要再做一次人工确认。
- 目前构建命令使用 `CODE_SIGNING_ALLOWED=NO`，因此尚未覆盖开发者签名、Team ID、系统授权弹窗与偏好设置保存链路。

## 6. 风险说明

- 是否涉及权限、签名、回环规避、失败策略：
  - 涉及。当前只完成无签名构建，未进入真实权限、签名、回环规避与 `FAIL_CLOSED` 行为联调。
- 是否存在未覆盖的异常分支：
  - 存在。尚未覆盖扩展启动失败、配置保存失败、透明代理网络规则安装失败、真实 Flow 识别失败等分支。

## 7. 建议下一步

- 建议先交给 `Evaluator` 独立检查以下事项：
  - `LiteShunt.xcodeproj` 与 Scheme 是否可稳定识别。
  - `swift build` / `swift test` / `swift run LiteShuntSmokeTests` 是否未被破坏。
  - `./script/build_and_run.sh --build-only` 是否稳定产出 `.app` 与 `.appex`。
  - 扩展中是否确实存在 `startProxy`、`stopProxy`、`handleNewFlow` 的最小入口。
- 若验收通过，下一轮建议进入 `POC-002`：在真实扩展配置下验证来源应用识别与首个 TCP Flow 捕获。

## 8. 填写要求

- 本文件只由 `Generator` 维护。
- 不要在本文件里直接写“验收通过”。
- 结论应基于实际执行，不要写模糊表述。
