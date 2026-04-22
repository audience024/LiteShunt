# LiteShunt AI 编程指南

## 1. 项目概览

### 1.1 项目定位
LiteShunt 是一款运行在 macOS 上的轻量级 app 级流量分流工具。它的核心职责是识别指定应用发起的网络连接，并将这些应用的 TCP 流量转发到本机 `Clash Verge`，未命中的应用保持系统默认直连。

LiteShunt 的目标是做一层轻量、可维护、边界清晰的“按应用识别 + 转发编排”工具，而不是自研代理内核，也不是替代 `Clash Verge` 的完整代理客户端。

### 1.2 当前版本边界
- 仅支持 `macOS`
- 默认目标系统为 `macOS 14+`
- 第一版仅支持 `TCP`
- 第一版仅对接本机 `Clash Verge`
- 核心系统能力使用 `NetworkExtension / NETransparentProxyProvider`
- 默认分发场景为开发者自用或内部测试

### 1.3 核心技术栈
- 语言：`Swift 6+`
- UI：`SwiftUI + AppKit`
- 系统框架：`NetworkExtension`
- 配置共享：`App Group`
- 测试：`XCTest`

### 1.4 核心实现原则
- 不自研代理协议栈，不实现节点管理、订阅管理、规则引擎。
- LiteShunt 只负责流量识别、规则匹配、转发编排、状态展示与基础诊断。
- 命中规则的应用流量默认转发到本机 `Clash Verge`。
- 未命中规则的应用流量默认保持系统直连。

## 2. 项目文件组织架构

后续代码目录应尽量按照以下结构组织：

```text
LiteShunt/
├── README.md
├── TECHNICAL_DESIGN.md
├── PLAN.md
├── AGENTS.md
├── LiteShuntApp/                 # 宿主应用
│   ├── App/
│   ├── Features/
│   ├── Shared/
│   ├── Models/
│   ├── Services/
│   └── Resources/
├── LiteShuntExtension/           # Transparent Proxy Extension
│   ├── Provider/
│   ├── Core/
│   ├── Routing/
│   ├── Networking/
│   └── Models/
├── LiteShuntShared/              # 宿主与扩展共享模型/常量
│   ├── Models/
│   ├── Constants/
│   └── Utilities/
└── LiteShuntTests/               # 单元测试
```

### 2.1 目录组织约束
- 宿主应用、扩展、共享模块必须物理分层，不允许职责混杂。
- 宿主应用中的 UI 逻辑不得直接混入扩展中的流量处理逻辑。
- 宿主应用与扩展共享的数据模型、常量、错误码统一放在 `LiteShuntShared`。
- 新增文件优先按功能域归类，不要按临时习惯随意堆放。
- 不允许多个核心类型长期堆在同一个文件中，除非是非常紧密的小型配套定义。

### 2.2 模块职责约定

- `LiteShuntApp`：菜单栏应用、设置界面、运行状态、配置编辑、诊断信息展示。
- `LiteShuntExtension`：透明代理扩展、流量识别、规则匹配、SOCKS5 转发、双向数据泵、运行时保护。
- `LiteShuntShared`：配置快照、规则模型、常量、通用错误定义、公共工具。
- `LiteShuntTests`：核心逻辑单元测试与必要的集成验证支持代码。

## 3. 设置与命令

当前仓库尚未创建正式的 `xcodeproj` 或 `xcworkspace`，因此以下命令先作为约定模板使用。工程创建后，必须第一时间把真实命令补齐并同步更新本节。

### 3.1 环境依赖
- 开发系统：`macOS 14+`
- 开发工具：`Xcode 16+`
- 命令行工具：已安装并启用 `Xcode Command Line Tools`
- 语言版本：`Swift 6+`
- 包管理与纯 Swift 构建：可用的 `Swift Package Manager`
- 系统框架能力：可用的 `NetworkExtension` 开发与调试环境
- 签名能力：具备可用于 `NetworkExtension` 调试的 Apple 开发者签名配置
- 本地代理后端：已安装并可运行的 `Clash Verge`
- 版本控制：本地 `git`

### 3.2 命令维护规则
- 所有命令默认在项目根目录执行。
- 新增或修改 `Scheme`、工程名、测试目标后，必须同步更新本节。
- 若后续引入 `SwiftLint`、脚本工具或自动化命令，也必须补充到本节。

### 3.3 常用命令模板
```bash
# 纯 Swift 核心层构建
swift build

# 运行核心自校验
swift run LiteShuntSmokeTests

# 打开工程
open LiteShunt.xcodeproj

# 命令行构建
xcodebuild \
  -project LiteShunt.xcodeproj \
  -scheme LiteShunt \
  -configuration Debug \
  build

# 运行单元测试
xcodebuild test \
  -project LiteShunt.xcodeproj \
  -scheme LiteShunt \
  -destination 'platform=macOS'

# 完整 Xcode 环境可用后，再使用标准 SwiftPM 测试
swift test

# 清理构建缓存
xcodebuild \
  -project LiteShunt.xcodeproj \
  -scheme LiteShunt \
  clean

# 如后续接入 SwiftLint，在此补充
swiftlint
```

## 4. 编码规范

## 4.1 通用 Swift 规范
- 优先使用 `Swift 6+` 与现代并发模型，优先选择 `async/await`。
- 非必要不得引入第三方框架；如确有必要，先更新设计文档并明确引入原因。
- 默认启用严格并发思维，避免不明确的线程切换与共享可变状态。
- 优先使用现代 `Foundation` API，不使用过时写法。
- 避免使用旧式 `GCD` 风格代码，尤其是 `DispatchQueue.main.async` 作为常规控制流手段。
- 避免强制解包与强制 `try`，除非属于不可恢复的程序错误并有充分注释。
- 用户输入相关的文本匹配优先使用本地化友好的比较方式。
- 时间、数字、日期展示优先使用 `FormatStyle`，避免旧式 `Formatter` 子类作为默认方案。

## 4.2 SwiftUI / AppKit 规范
- UI 默认采用 `SwiftUI`；只有在系统能力或宿主集成确有需要时才引入 `AppKit`。
- 共享状态优先采用 `@Observable` 模型；如需跨视图传递，优先使用 `@State`、`@Bindable`、`@Environment` 体系。
- 避免默认使用 `ObservableObject`、`@Published`、`@StateObject`、`@ObservedObject`、`@EnvironmentObject`，除非涉及旧代码兼容或特定集成场景。
- 视图中的业务逻辑必须下沉到可测试对象，不要把复杂判断直接堆在 View 内。
- 优先使用现代导航与滚动 API，避免使用旧式已被替代的写法。
- 尽量使用 `Button` 表达点击交互，不要把普通交互直接写成手势。
- 不要滥用 `GeometryReader`、`AnyView`、硬编码尺寸与无依据的间距常量。
- 用户可见文案默认使用简体中文，后续如做国际化，再统一抽取。

## 4.3 LiteShunt 项目特定规范
- LiteShunt 不是代理软件本体，不实现节点订阅、策略组管理、出站协议栈等功能。
- 第一版只支持将命中应用的 TCP 流量转发到本机 `Clash Verge`。
- 命中规则的应用在代理不可用时，默认执行 `FAIL_CLOSED`，不得私自降级为直连。
- 必须始终考虑回环规避，至少排除：
  - LiteShunt 宿主应用
  - LiteShunt 扩展自身
  - `Clash Verge` 或相关核心进程
- 宿主应用与扩展之间统一使用配置快照共享，不引入额外常驻后台进程。
- 共享配置应采用可版本化结构，支持整体快照替换与安全回退。
- 不允许出现魔法常量；默认端口、超时、状态码、错误码、默认策略必须集中定义。
- 涉及系统权限、签名、扩展生命周期、回环规避、失败策略的代码必须补充中文注释，说明边界与风险。
- 日志必须分级，默认避免输出完整流量内容、敏感地址或过量调试信息。
- 设计与实现必须保持轻量，不为“可能未来会用到”而提前引入复杂抽象。

## 4.4 NetworkExtension 相关约束
- 透明代理主线固定为 `NETransparentProxyProvider`，不要自行偏转到 `PF` 劫持等非官方 API 方案。
- 规则匹配应优先围绕应用身份信息进行，如 `Bundle ID`、签名标识等。
- 转发链路优先采用到本机 `Clash Verge` 的 `SOCKS5` 连接。
- 任何流量处理实现都必须优先验证是否会形成代理回环。
- 不要在第一版擅自扩大范围到 `UDP`、`QUIC`、完整 DNS 接管，除非设计文档已明确升级范围。

## 4.5 测试与质量要求
- 核心逻辑必须有单元测试。
- 至少应覆盖以下能力：
  - 应用规则匹配
  - 排除名单匹配
  - 配置快照解析
  - `SOCKS5` 建链流程
  - 失败策略执行
- 无法通过纯单元测试覆盖的 `NetworkExtension` 行为，可通过 POC 或集成验证补充。
- 若后续接入 `SwiftLint`，提交前必须确保无高优先级告警。
- 新增复杂逻辑时，优先补测试，再进入重构或扩展。

## 5. 实现红线

以下行为默认禁止，除非设计文档已明确变更：
- 把 LiteShunt 做成 `Clash Verge` 的替代品。
- 在项目中加入节点配置、订阅管理、规则引擎 UI。
- 未经设计确认就引入第三方网络库或代理核心。
- 为了省事让命中应用在代理异常时自动直连。
- 将宿主应用、扩展、共享模型混写在同一层目录或同一职责文件中。
- 在没有测试或验证说明的情况下引入复杂并发逻辑。

## 6. 文档协同关系

项目文档职责边界如下：
- `README.md`：项目入口与总体架构概览。
- `TECHNICAL_DESIGN.md`：详细技术方案、核心决策、默认值与边界说明。
- `PLAN.md`：任务拆分、进度状态、阶段性记录与变更追踪。
- `AGENTS.md`：AI 编程代理执行规范与实现约束。

### 6.1 决策优先级
- 架构决策以 `TECHNICAL_DESIGN.md` 为准。
- 任务进度与阶段状态以 `PLAN.md` 为准。
- AI 执行规范与代码风格以 `AGENTS.md` 为准。
- 若文档之间发生冲突，应优先人工核对并修正，默认按“技术设计 > 任务计划 > AI 执行规范”的顺序处理。

## 7. 对 AI 代理的执行要求
- 在实现新功能前，先核对 `TECHNICAL_DESIGN.md` 与 `PLAN.md`，确认当前阶段边界。
- 新增目录、核心模型、命令或测试策略后，必要时同步更新相关文档。
- 若发现设计与实现存在冲突，优先修正文档或暂停实现，不要自行拍脑袋扩展范围。
- 在合适的时机执行编译验证，确保工程改动具备基本可构建性。
- 所有输出默认使用简体中文，包括代码注释、任务记录和实现说明。

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->
