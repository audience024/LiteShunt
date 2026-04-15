# LiteShunt 技术设计文档

## 1. 文档信息
- 项目名称：`LiteShunt`
- 文档版本：`v0.1.0`
- 最近更新：`2026-04-15`
- 当前阶段：`POC-001` 已完成 / 准备进入 `POC-002`

## 2. 产品目标

### 2.1 要解决的问题
在 macOS 上，用户经常只能通过系统全局代理或代理软件自身规则来控制网络出口。LiteShunt 的目标是补足“按应用精准分流”这一层能力，让用户能明确指定哪些应用必须走代理，哪些应用继续直连。

### 2.2 核心目标
- 提供轻量级的 app 级流量分流能力
- 将命中应用的 TCP 流量转发到本机 `Clash Verge`
- 保持未命中应用的网络行为不变
- 以最小 UI、最小后台组件、最小系统侵入实现可维护架构

### 2.3 非目标
- 不自研代理内核
- 不做节点管理、订阅管理、策略组功能
- 不做通用网络分析工具
- 第一版不做 `UDP`、`QUIC`、全量 `DNS` 接管
- 第一版不追求 App Store 分发优先

## 3. 需求边界
- 平台：`macOS`
- 目标系统：`macOS 14+`
- 分发方式：开发者自用 / 内部测试
- 代理后端：仅支持本机 `Clash Verge`
- 协议范围：第一版仅支持 `TCP`
- 系统能力：`NetworkExtension / NETransparentProxyProvider`
- 默认语言：用户可见文案使用简体中文

## 4. 技术选型

### 4.1 宿主应用
- 技术：`SwiftUI + AppKit`
- 形态：菜单栏常驻应用
- 原因：
  - 菜单栏形态更符合轻量级工具定位
  - `SwiftUI` 适合构建简洁配置页面
  - `AppKit` 可补充菜单栏与系统集成细节能力

### 4.2 流量拦截主线
- 技术：`NETransparentProxyProvider`
- 原因：
  - 属于 Apple 官方 `NetworkExtension` 能力
  - 适合对匹配流量进行自行处理或放行
  - 相比 `PF` 规则方案，可维护性与兼容性更好

### 4.3 配置共享
- 技术：`App Group + JSON 配置快照`
- 原因：
  - 宿主应用与扩展天然存在边界
  - 配置快照结构简单、版本化清晰、调试成本低
  - 不需要额外常驻后台进程参与通信

### 4.4 代理后端接入
- 技术：`SOCKS5 -> Clash Verge mixed-port`
- 默认地址：`127.0.0.1`
- 默认端口：`7890`
- 原因：
  - `Clash Verge` 已提供本地代理入口
  - LiteShunt 无需重复实现代理能力
  - `SOCKS5` 建链逻辑简单，适合做轻量级桥接

## 5. 总体架构

### 5.1 架构组成
1. `LiteShuntApp`
   - 菜单栏状态
   - 规则编辑
   - 代理配置
   - 启停扩展
   - 日志与诊断展示
2. `LiteShuntExtension`
   - 接收透明代理 Flow
   - 提取来源应用信息
   - 匹配规则与排除名单
   - 建立到 `Clash Verge` 的 `SOCKS5` 连接
   - 双向数据转发
3. `LiteShuntShared`
   - 配置快照模型
   - 公共常量
   - 错误码定义
   - 公共工具

### 5.2 数据流
```text
目标应用 -> LiteShuntExtension -> 规则匹配
命中规则 -> SOCKS5 -> Clash Verge -> 远端网络
未命中规则 -> 直接放行 -> 系统默认网络出口
```

## 6. 核心流程设计

### 6.1 启动流程
1. 宿主应用启动，加载本地规则与代理配置。
2. 宿主应用将配置写入 `App Group` 共享区域。
3. 用户启用 LiteShunt 后，宿主应用拉起透明代理扩展。
4. 扩展启动时加载最新配置快照。
5. 宿主应用定期或按需检查扩展状态与 `Clash Verge` 连通性。

### 6.2 新连接处理流程
1. 扩展收到新的 TCP Flow。
2. 提取 Flow 元数据中的来源应用身份信息。
3. 先匹配排除名单，命中则直接放行。
4. 再匹配应用规则。
5. 如果未命中规则，返回不处理，由系统直连。
6. 如果命中规则，则建立到本机 `Clash Verge` 的 `SOCKS5` 连接。
7. 建链成功后启动双向数据转发。
8. 建链失败时按 `FAIL_CLOSED` 中止该连接。

### 6.3 配置更新流程
1. 宿主应用修改规则或代理配置。
2. 生成新的完整配置快照。
3. 原子化写入共享区域。
4. 扩展在收到重载信号或下一次读取时整体刷新配置。
5. 新配置解析失败时回退到上一版有效快照。

## 7. 配置与模型设计

### 7.1 AppRule
```text
AppRule
- bundleId: String
- signingIdentifier: String?
- displayName: String
- enabled: Bool
- routeMode: PROXY | DIRECT
```

说明：
- 第一版主行为是 `PROXY`
- 保留 `DIRECT` 是为了后续扩展，但当前不做复杂多策略路由

### 7.2 ProxyConfig
```text
ProxyConfig
- host: String
- port: Int
- protocol: SOCKS5
- connectTimeoutMs: Int
```

默认值：
- `host = 127.0.0.1`
- `port = 7890`
- `protocol = SOCKS5`
- `connectTimeoutMs = 3000`

### 7.3 RuntimePolicy
```text
RuntimePolicy
- selectedAppsFailStrategy: FAIL_CLOSED
- selfBypassEnabled: true
- clashBypassEnabled: true
```

### 7.4 LiteShuntConfig
```text
LiteShuntConfig
- version: Int
- proxyConfig: ProxyConfig
- appRules: [AppRule]
- exclusionRules: [ExclusionRule]
- runtimePolicy: RuntimePolicy
- updatedAt: Date
```

## 8. 核心模块设计

### 8.1 FlowClassifier
职责：
- 读取 Flow 元数据
- 提取应用身份
- 匹配排除名单
- 匹配应用规则

输入：
- 新到达的 TCP Flow
- 当前配置快照

输出：
- `BYPASS`
- `PROXY`
- `REJECT`

### 8.2 SocksConnector
职责：
- 连接本机 `Clash Verge`
- 完成 `SOCKS5` 握手
- 请求连接原始目标地址

约束：
- 统一处理连接超时
- 握手失败必须携带明确错误码
- 不在此模块内做业务规则判断

### 8.3 BidirectionalPump
职责：
- 管理客户端与代理后端之间的双向数据转发
- 处理连接关闭、异常中止与资源回收

要求：
- 不阻塞主控制逻辑
- 明确半关闭与全关闭策略
- 严格避免资源泄漏

### 8.4 RuntimeGuard
职责：
- 处理回环规避
- 统一执行失败策略
- 做基础运行时保护

至少负责识别：
- LiteShunt 宿主应用自身流量
- LiteShunt 扩展自身流量
- `Clash Verge` 相关进程流量

## 9. 关键技术决策

### 9.1 为什么不以 Per-App VPN 为主线
Apple 的 per-app VPN 更适合 `MDM` 管理场景，不适合作为普通用户安装使用的主线方案。LiteShunt 第一版以开发者自用和内部测试为目标，应优先选择更现实的 `NETransparentProxyProvider` 路径。

### 9.2 为什么不使用 PF 规则劫持作为主线
`PF` 不属于推荐的产品化路径，长期兼容性、维护性与风险控制都不理想。LiteShunt 需要建立在官方可持续能力之上。

### 9.3 为什么第一版只做 TCP
`UDP`、`QUIC`、`DNS` 接管会显著提高复杂度，尤其是连接模型、异常处理和泄漏控制。第一版优先把最有价值、覆盖面最大的 TCP 场景做稳。

### 9.4 为什么默认 FAIL_CLOSED
如果用户明确要求某应用必须走代理，那么在代理不可用时自动降级为直连会造成行为失真与潜在泄漏。因此默认策略必须是阻断而不是偷偷放行。

## 10. UI 与交互设计

### 10.1 菜单栏展示
- LiteShunt 运行状态
- 扩展状态
- `Clash Verge` 连通性
- 已启用代理的应用数量
- 一键启停入口

### 10.2 设置页结构
1. 代理后端
   - 地址
   - 端口
   - 连通性测试
2. 应用规则
   - 应用列表
   - 勾选状态
   - 排除名单
3. 诊断信息
   - 最近错误
   - 最近状态
   - 简化日志

### 10.3 明确不做的 UI
- 节点切换面板
- 订阅管理
- 复杂图表大盘
- 通用网络调试台

## 11. 异常与边界处理

### 11.1 Clash Verge 未启动
- 宿主应用显示后端不可达
- 命中规则的连接按 `FAIL_CLOSED` 失败

### 11.2 代理端口配置错误
- 宿主应用在连通性测试中提示错误
- 扩展记录错误码并阻断命中连接

### 11.3 配置快照损坏
- 扩展保留上一版有效配置
- 宿主应用提示配置异常

### 11.4 回环风险
- 默认排除 LiteShunt 自身与 `Clash Verge`
- 转发链路必须在实现阶段优先做回环验证

## 12. 测试方案

### 12.1 功能测试
- 命中应用的 TCP 连接能成功转发到 `Clash Verge`
- 未命中应用保持直连
- 修改规则后扩展能够加载新配置

### 12.2 异常测试
- `Clash Verge` 未启动
- 端口配置错误
- 配置快照解析失败
- `SOCKS5` 握手失败

### 12.3 兼容性验证
- `URLSession` 类应用
- Chromium 系应用
- Electron 类应用
- 至少一类原生 Socket 客户端

## 13. 里程碑路线

### 13.1 M1：方案固化与文档初始化
- 建立 `README.md`
- 建立 `TECHNICAL_DESIGN.md`
- 建立 `PLAN.md`
- 建立 `AGENTS.md`

### 13.2 M2：POC 验证
- 验证按应用识别 TCP Flow
- 验证与本机 `Clash Verge` 的 `SOCKS5` 转发
- 验证回环规避与失败策略

### 13.3 M3：v1 基础功能
- 搭建宿主应用
- 搭建扩展
- 实现共享配置
- 实现菜单栏状态与基础设置

### 13.4 M4：稳定性完善
- 补齐测试
- 强化日志与诊断
- 优化配置加载与恢复

## 14. 风险清单
- `NetworkExtension` 权限与签名配置具有一定门槛
- 不同应用的网络栈表现可能存在差异
- 回环规避若处理不当会造成连接异常或死循环
- 用户可能误以为 LiteShunt 负责完整代理能力，需要在产品文案中持续澄清

## 15. 实施默认值
- 默认代理地址：`127.0.0.1`
- 默认代理端口：`7890`
- 默认协议：`SOCKS5`
- 默认连接超时：`3000ms`
- 默认失败策略：`FAIL_CLOSED`
- 默认语言：简体中文
