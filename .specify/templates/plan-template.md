# Implementation Plan（实现计划）: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]  
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note（说明）**: 本模板由 `/speckit.plan` 命令填充。执行流程请参考 `.specify/templates/plan-template.md`。

## Summary（摘要）

[从 feature spec 中提取：核心需求 + 从 research 中提炼的技术路线]

## Technical Context（技术上下文）

<!--
  ACTION REQUIRED（需补充）：
  请将本节替换为项目真实的技术上下文。
  这里给出的结构仅作为引导，用于帮助你有条理地完成方案整理。
-->

**Language/Version**: [例如 Python 3.11、Swift 6、Rust 1.75，或 NEEDS CLARIFICATION]  
**Primary Dependencies**: [例如 FastAPI、UIKit、LLVM，或 NEEDS CLARIFICATION]  
**Storage**: [如适用，例如 PostgreSQL、CoreData、files，或 N/A]  
**Testing**: [例如 pytest、XCTest、cargo test，或 NEEDS CLARIFICATION]  
**Target Platform**: [例如 Linux server、iOS 15+、WASM，或 NEEDS CLARIFICATION]  
**Project Type**: [例如 library / cli / web-service / mobile-app / compiler / desktop-app，或 NEEDS CLARIFICATION]  
**Performance Goals**: [领域相关指标，例如 1000 req/s、10k lines/sec、60 fps，或 NEEDS CLARIFICATION]  
**Constraints**: [领域约束，例如 <200ms p95、<100MB 内存、支持离线，或 NEEDS CLARIFICATION]  
**Scale/Scope**: [领域范围，例如 10k 用户、1M LOC、50 个页面，或 NEEDS CLARIFICATION]

## Constitution Check（宪章检查）

*GATE（门禁）: 必须在 Phase 0 research 前通过，并在 Phase 1 design 后再次复核。*

[根据 constitution 文件填写门禁项]

## Project Structure（项目结构）

### Documentation（本功能文档）

```text
specs/[###-feature]/
├── plan.md              # 当前文件（/speckit.plan 命令输出）
├── research.md          # Phase 0 输出（/speckit.plan 命令）
├── data-model.md        # Phase 1 输出（/speckit.plan 命令）
├── quickstart.md        # Phase 1 输出（/speckit.plan 命令）
├── contracts/           # Phase 1 输出（/speckit.plan 命令）
└── tasks.md             # Phase 2 输出（/speckit.tasks 命令生成，不由 /speckit.plan 直接创建）
```

### Source Code（仓库根目录源码结构）
<!--
  ACTION REQUIRED（需补充）：
  请将下方占位目录树替换为本功能真实使用的代码结构。
  删除未使用的选项，并把选中的结构展开为真实路径
  （例如 apps/admin、packages/something）。
  最终交付的 plan.md 中不应保留 Option 标签。
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project（单体项目，默认）
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application（检测到 frontend + backend 时）
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API（检测到 iOS / Android 时）
api/
└── [与上方 backend 类似的结构]

ios/ or android/
└── [平台特定结构：功能模块、UI 流程、平台测试]
```

**Structure Decision（结构决策）**: [说明最终采用的结构，并引用上面已经明确的真实目录]

## Complexity Tracking（复杂度跟踪）

> **仅当 Constitution Check 存在必须说明的违例时才填写**

| Violation（违例） | Why Needed（为何需要） | Simpler Alternative Rejected Because（更简单方案未采用的原因） |
|-----------|------------|-------------------------------------|
| [例如：第 4 个子项目] | [当前需求] | [为什么 3 个子项目不够] |
| [例如：Repository pattern] | [具体问题] | [为什么直接访问数据库不够] |
