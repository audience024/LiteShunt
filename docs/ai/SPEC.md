# 本轮规格说明

## 1. 背景

当前项目处于 `M2 POC 验证` 阶段，`POC-001` 已完成最小 Xcode 工程、宿主应用入口和透明代理扩展入口的构建验证。下一步最关键的不确定性是：系统是否会将目标应用的真实 TCP Flow 送入扩展，以及扩展是否能稳定拿到用于规则匹配的来源应用身份信息。

## 2. 本轮目标

`POC-002：在真实扩展配置下验证来源应用识别与首个 TCP Flow 捕获。`

当前任务文件：
- [docs/ai/tasks/POC-002.md](/Users/zero/Downloads/code/LiteShunt/docs/ai/tasks/POC-002.md)

## 3. 本轮范围

- 允许修改的模块：
  - `LiteShuntApp/`
  - `LiteShuntExtension/`
  - `LiteShuntShared/`
  - `LiteShuntTests/`
  - `Tests/`
  - `script/`
  - `docs/ai/`
- 本轮明确允许的实现方向：
  1. 打通宿主侧最小透明代理配置保存 / 加载链路。
  2. 在扩展中补充最小 Flow 元数据采集与安全诊断输出。
  3. 选择至少一个目标应用做真实 Flow 捕获验证，并记录结果。
  4. 把命令、阻塞点、限制与下一步建议沉淀到任务文件和交接文档。

## 4. 本轮非目标

以下内容默认不在本轮范围内：

- 节点管理
- 订阅管理
- 规则引擎 UI
- `UDP`、`QUIC`
- 全量 `DNS` 接管
- 脱离 `Clash Verge` 的代理实现
- 完整菜单栏 UI
- 完整 `SOCKS5` 建链
- 回环规避与 `FAIL_CLOSED` 的最终系统级验证
- 可直接发布的签名与分发配置

## 5. 完成标准

1. 宿主侧存在可用于驱动透明代理配置的最小 POC 入口，且保存链路的实际结果或阻塞点被记录清楚。
2. 扩展能捕获至少一个真实 TCP Flow，并输出可用于规则匹配的来源应用身份信息，或明确记录系统级阻塞点。
3. 有明确证据表明当前阶段已经从“工程入口可构建”推进到“真实 Flow 行为可验证”。
4. `swift build`、`swift test`、`swift run LiteShuntSmokeTests` 现有基础链路不被破坏。
5. 未引入超出 LiteShunt 当前阶段边界的代理能力扩张。

## 6. 验收步骤

1. 执行基础验证命令：
   - `swift build`
   - `swift test`
   - `swift run LiteShuntSmokeTests`
2. 执行工程检查命令：
   - `xcodebuild -list -project LiteShunt.xcodeproj`
   - 本轮实际使用的构建 / 启动 / 验证脚本
3. 检查扩展侧日志、诊断记录或测试支撑代码，确认是否存在真实 Flow 捕获与来源应用识别证据。
4. 核对 `docs/ai/tasks/POC-002.md`、`docs/ai/HANDOFF.md` 与 `docs/ai/QA_REPORT.md` 是否已完整记录结果和阻塞点。

## 7. 风险与边界

- `NetworkExtension` 权限、签名、系统授权与调试门槛仍然较高。
- 来源应用身份信息的可见性可能受系统行为和测试应用选择影响。
- 若本轮只能证明“配置链路阻塞于系统前置条件”，也必须把阻塞点写清楚，不能模糊宣称已完成。
- 任何为了验证方便而绕过 `FAIL_CLOSED`、回环规避或产品边界的行为都不被允许。

## 8. 与任务文件的关系

- 本文件用于定义“本轮 contract”。
- 真实执行现场、已完成内容、命令记录和接手提示以 `docs/ai/tasks/POC-002.md` 为准。
- 如果本轮唯一主目标变化，必须先更新本文件和任务总目录，再进入实现。
