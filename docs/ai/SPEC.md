# 本轮规格说明

## 1. 背景

当前项目处于 `M2 POC 验证` 准备阶段，目标是优先验证以下能力：

- `NETransparentProxyProvider` 基本可启动
- 可按应用识别 TCP Flow
- 可转发到本机 `Clash Verge`
- 可规避回环
- 命中规则失败时执行 `FAIL_CLOSED`

## 2. 本轮目标

`POC-001：搭建最小 Xcode 工程，验证 LiteShunt Transparent Proxy Extension 可成功构建、可被宿主配置并具备接收首个 TCP Flow 的代码入口。`

## 3. 本轮范围

- 允许修改的模块：
  - 根目录工程文件与脚本
  - `LiteShuntApp/`
  - `LiteShuntExtension/`
  - `LiteShuntShared/`
  - `LiteShuntTests/`
- 允许新增的最小必要支撑代码：
  - `LiteShunt.xcodeproj`
  - 最小宿主应用入口
  - 最小 `NETransparentProxyProvider` 子类
  - App Group / 扩展标识占位配置
  - 构建与运行验证脚本
  - 与 POC 对应的文档和日志说明

本轮明确允许的实现目标：
1. 让仓库具备正式 Xcode 工程，而不是继续停留在纯 SwiftPM。
2. 建立宿主应用、扩展、共享模块、测试模块的物理目录骨架。
3. 在扩展内提供 `startProxy`、`stopProxy` 和 `handleNewFlow` 的最小代码入口。
4. 在宿主侧提供最小配置入口，用于后续加载扩展配置。
5. 提供可执行的构建命令或脚本，证明工程至少能进入 POC 级构建验证。

## 4. 本轮非目标

以下内容默认不在本轮范围内：

- 节点管理
- 订阅管理
- 规则引擎 UI
- `UDP`、`QUIC`
- 全量 `DNS` 接管
- 脱离 `Clash Verge` 的代理实现
- 完整菜单栏 UI
- 应用规则编辑 UI
- 完整 `SOCKS5` 建链
- 回环规避与 `FAIL_CLOSED` 的完整实现
- 可直接发布的签名与分发配置

## 5. 完成标准

1. 仓库新增正式 `Xcode` 工程文件，并能列出宿主应用与扩展目标。
2. `LiteShuntApp/`、`LiteShuntExtension/`、`LiteShuntShared/`、`LiteShuntTests/` 下存在与职责一致的最小源码骨架。
3. 扩展目标中存在 `NETransparentProxyProvider` 子类，包含启动、停止和处理新 Flow 的最小实现入口。
4. 至少一条工程级构建命令可执行；如果因签名或能力配置受阻，必须明确记录阻塞点和实际错误。
5. `swift build`、`swift test`、`swift run LiteShuntSmokeTests` 现有 SwiftPM 骨架不能被破坏。
6. 未引入 `UDP`、`QUIC`、代理内核、规则引擎 UI 等超范围实现。

## 6. 验收步骤

1. 执行构建命令：
   - `swift build`
   - `xcodebuild -list -project LiteShunt.xcodeproj`
2. 执行自校验命令：
   - `swift run LiteShuntSmokeTests`
3. 执行测试命令：
   - `swift test`
4. 执行 POC 工程构建验证：
   - `xcodebuild -project LiteShunt.xcodeproj -scheme LiteShuntApp -configuration Debug build`
5. 检查扩展源码中是否存在 `NETransparentProxyProvider` 最小入口，并确认无超范围实现。

## 7. 风险与边界

- `NetworkExtension` 权限、签名与调试门槛高。
- 回环规避是高风险项，必须前置考虑。
- 本机已存在完整 Xcode，但 `NetworkExtension` entitlement、Team ID、App Group 标识仍可能导致工程构建或运行阻塞。
- 若依赖开发者签名或本机手动配置，必须在交接文档中明确说明阻塞点和后续人工步骤。

## 8. 备注

- 本文件由 `Planner` 主维护。
- 如果本轮目标变化，必须先更新本文件，再进入实现。
