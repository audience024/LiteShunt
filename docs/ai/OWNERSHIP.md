# 本轮职责与写入边界

## 1. 线程职责

### `00-主控`

- 负责决定本轮目标与节奏。
- 负责维护本文件与收口判断。
- 本轮允许为工程编排和文档 contract 做小规模修改，不承担主实现。

### `01-规划-Planner`

- 负责产出和更新 `SPEC.md`、`TASK_LIST.md`。
- 负责澄清边界、验收标准、风险。
- 不直接修改业务实现代码。

### `02-实现-Generator`

- 负责按 contract 实现功能。
- 负责维护 `HANDOFF.md`。
- 不负责验收结论。

### `03-验收-Evaluator`

- 负责执行构建、测试、静态检查和行为验收。
- 负责维护 `QA_REPORT.md`。
- 不直接替代 `Generator` 完成实现。

## 2. 推荐写入范围

| 线程 | 默认可写文件/目录 |
| --- | --- |
| `00-主控` | `docs/ai/` |
| `01-规划-Planner` | `docs/ai/SPEC.md`、`docs/ai/TASK_LIST.md` |
| `02-实现-Generator` | `LiteShunt.xcodeproj`、`LiteShuntApp/`、`LiteShuntExtension/`、`LiteShuntShared/`、`LiteShuntTests/`、`script/`、`docs/ai/HANDOFF.md` |
| `03-验收-Evaluator` | `docs/ai/QA_REPORT.md` |

## 3. 本轮 POC-001 专项边界

### `00-主控`

- 负责收敛目标、维护 contract、派发实现与回收结果。
- 不直接改动 `LiteShunt.xcodeproj` 与 POC 源码目录，避免与实现线程冲突。

### `02-实现-Generator`

- 独占负责以下写入范围：
  - `LiteShunt.xcodeproj`
  - `LiteShuntApp/`
  - `LiteShuntExtension/`
  - `LiteShuntShared/`
  - `LiteShuntTests/`
  - `script/`
  - `docs/ai/HANDOFF.md`
- 不得修改：
  - `PLAN.md`
  - `TECHNICAL_DESIGN.md`
  - `README.md`
  - `docs/ai/SPEC.md`
  - `docs/ai/TASK_LIST.md`
  - `docs/ai/OWNERSHIP.md`
  - `docs/ai/QA_REPORT.md`

### `03-验收-Evaluator`

- 只读规格、任务与实现结果。
- 仅允许写 `docs/ai/QA_REPORT.md`。
- 不得替代实现线程补代码。

## 4. LiteShunt 推荐模块归属

如果后续需要多个实现线程，可参考以下拆分：

| 模块 | 推荐实现线程 | 目录 |
| --- | --- | --- |
| 宿主应用 UI 与设置 | `Generator-App` | `LiteShuntApp/` |
| 扩展流量处理与转发 | `Generator-Extension` | `LiteShuntExtension/` |
| 共享模型与常量 | `Generator-Shared` | `LiteShuntShared/` |
| 单元测试与验证代码 | `Generator-Tests` | `LiteShuntTests/`、`Tests/` |

## 5. 冲突处理规则

- 如果两个实现线程需要改同一目录，先由 `主控` 重划边界。
- 未经 `主控` 明确授权，不要跨线程修改对方负责目录。
- 若发现本轮目标需要跨多个核心目录联动，优先由 `Planner` 重新拆分 contract。
