# 实现交接记录

## 1. 本轮目标

`POC-002：打通宿主最小透明代理配置保存链路，在扩展侧安装最小透明代理规则，并补齐来源应用身份与 Flow 诊断日志，为真实 TCP Flow 捕获验证做准备。`

## 2. 已完成内容

- 已在宿主侧落地 `NETransparentProxyManager` 的最小保存闭环：
  - 读取全部 manager
  - 复用或新建 manager
  - 组装 `NETunnelProviderProtocol`
  - 调用 `saveToPreferences`
  - 保存后回读并生成摘要
- 已在状态页增加“写入 POC 配置”按钮和配置摘要显示，便于手工联调。
- 已在扩展 `startProxy` 中读取 `providerConfiguration`、安装最小 `NETransparentProxyNetworkSettings`，并输出启动日志。
- 已在扩展 `handleNewFlow(_:)` 中增加来源应用身份、audit token 长度、hostname 与 endpoint 诊断日志；当前保持 `return false`，继续采用“只采样、不接管”的 POC 策略。
- 已补充透明代理 POC 所需共享常量，收敛 `providerConfiguration` 键和默认描述。
- 已结合多智能体只读调查与 `.specify/memory/constitution.md` 做门禁复核，确认本轮仍严格停留在 `POC-002` 范围内。

## 3. 修改文件

- `LiteShuntShared/Constants/LiteShuntSharedConstants.swift`
  - 新增透明代理 POC 相关常量与 `providerConfiguration` 键。
- `LiteShuntApp/Services/TransparentProxyManagerStore.swift`
  - 从“只读 manager 数量”扩展为“加载 / 创建 / 保存 / 回读 manager”的最小闭环。
- `LiteShuntApp/Features/Status/StatusView.swift`
  - 新增“写入 POC 配置”入口和配置摘要展示。
- `LiteShuntExtension/Provider/LiteShuntTransparentProxyProvider.swift`
  - 新增 `providerConfiguration` 启动日志、最小透明代理规则安装、Flow 身份诊断日志。
- `docs/ai/TASK_LIST.md`
  - 将 `POC-002` 状态更新为 `BLOCKED`。
- `docs/ai/tasks/POC-002.md`
  - 回写本轮执行现场、阻塞与下一步建议。
- `docs/ai/HANDOFF.md`
  - 更新为本轮实现交接。

## 4. 执行过的验证

- `swift test`
  - 通过，8 个测试全部通过。
- `swift run LiteShuntSmokeTests`
  - 通过，输出 `LiteShunt 核心自校验通过`。
- `xcodebuild -project LiteShunt.xcodeproj -scheme LiteShuntApp -configuration Debug build CODE_SIGNING_ALLOWED=NO`
  - 通过，宿主应用与扩展均可完成工程级构建。

## 5. 已知问题

- 尚未进行带签名、带系统授权的真实保存验证；当前构建仍使用 `CODE_SIGNING_ALLOWED=NO`。
- `Personal Team` 已确认不支持 `Network Extensions`，无法生成 LiteShunt 所需的开发 profile。
- 已发现组织团队，但当前账号仅为 `Developer`，且 `Certificates, Identifiers & Profiles` 显示不可用；当前无法判断是权限不足、团队协议未确认，还是 `Network Extensions` capability 尚未开通。
- 在上述外部条件未解决前，`POC-002` 不建议继续做真实系统联调，避免把签名 / capability 问题误判为代码问题。
- 尚未确认是否需要额外 `AuthorizationRef` / `setAuthorization(_:)` 才能稳定写入系统配置。
- 尚未在真实目标应用上看到首个 TCP Flow 进入扩展，因此 `POC-002` 仍不能宣告完成。
- 扩展构建存在 Swift 6 并发 warning：
  - `setTunnelNetworkSettings` 回调中对 `self` 和 `completionHandler` 的 capture 仍会提示 non-Sendable warning
  - `NETransparentProxyManager` 的 retroactive `Sendable` 声明存在 warning
  - 当前 warning 不阻断构建，但后续可以继续做并发收口
- 当前 entitlement 中的 `app-proxy-provider` 仍需带签名实机确认，不能仅凭无签名构建视为最终正确。

## 6. 风险说明

- 是否涉及权限、签名、回环规避、失败策略：
  - 涉及。当前只完成无签名构建和最小规则安装，未进入真实权限、签名、回环规避与 `FAIL_CLOSED` 行为联调。
- 是否存在未覆盖的异常分支：
  - 存在。尚未覆盖配置保存失败、系统授权失败、扩展未被拉起、规则安装失败、Flow 未进入扩展等分支。

## 7. 建议下一步

- 先由团队管理员或账号持有人补齐以下外部条件：
  - 可用的付费开发团队
  - 当前账号的 `Certificates, Identifiers & Profiles` 访问权限
  - 团队最新协议确认
  - App ID / Team 的 `Network Extensions` capability
- 外部条件满足后，再用带签名配置运行宿主应用，点击“写入 POC 配置”，记录 `saveToPreferences` 的真实结果和错误信息。
- 如保存成功，继续验证扩展是否被系统拉起，以及 `startProxy` 是否成功安装最小透明代理规则。
- 选择一个目标应用做真实 TCP Flow 捕获，重点观察扩展日志里的：
  - `sourceAppSigningIdentifier`
  - `uniqueIdPrefix`
  - `remoteHost`
  - `remoteEndpoint`
- 若系统在保存阶段报权限错误，优先评估是否需要补 `setAuthorization(_:)`，不要绕开系统能力边界。
- 若真实 Flow 已进入扩展，再进入 `POC-003` 所需的 `SocksConnector` 设计与实现。

## 8. 填写要求

- 本文件只由 `Generator` 维护。
- 不要在本文件里直接写“验收通过”。
- 结论应基于实际执行，不要写模糊表述。
