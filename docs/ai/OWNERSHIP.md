# 本轮职责与写入边界

## 1. 线程职责

### `00-主控`

- 负责决定本轮唯一主目标与节奏。
- 负责维护本文件、`TASK_LIST.md` 以及必要的任务切换动作。
- 本轮允许为任务编排和 contract 收口做小规模文档修改，不承担主实现。

### `01-规划-Planner`

- 负责产出和更新 `SPEC.md`、`TASK_LIST.md` 与当前任务文件。
- 负责澄清边界、验收标准、风险与任务依赖。
- 不直接修改业务实现代码。

### `02-实现-Generator`

- 负责按 contract 实现功能。
- 负责维护 `HANDOFF.md`，必要时补充任务文件中的执行现场。
- 不负责给出验收通过结论。

### `03-验收-Evaluator`

- 负责执行构建、测试、静态检查和行为验收。
- 负责维护 `QA_REPORT.md`。
- 不直接替代 `Generator` 完成实现。

## 2. 推荐写入范围

| 线程 | 默认可写文件/目录 |
| --- | --- |
| `00-主控` | `docs/ai/` |
| `01-规划-Planner` | `docs/ai/SPEC.md`、`docs/ai/TASK_LIST.md`、`docs/ai/tasks/` |
| `02-实现-Generator` | `LiteShunt.xcodeproj`、`LiteShuntApp/`、`LiteShuntExtension/`、`LiteShuntShared/`、`LiteShuntTests/`、`Tests/`、`script/`、`docs/ai/HANDOFF.md`、必要的当前任务文件现场段落 |
| `03-验收-Evaluator` | `docs/ai/QA_REPORT.md`、必要的当前任务文件现场段落 |

## 3. 当前主任务专项边界

当前唯一主任务：`POC-002`

当前任务文件：
- [docs/ai/tasks/POC-002.md](/Users/zero/Downloads/code/LiteShunt/docs/ai/tasks/POC-002.md)

### `00-主控`

- 负责收敛目标、切换主任务、维护导航与边界。
- 不直接改动 `LiteShunt.xcodeproj` 与主要实现目录，避免与实现线程冲突。

### `01-规划-Planner`

- 可更新 `SPEC.md`、`TASK_LIST.md` 与 `docs/ai/tasks/POC-002.md`。
- 不得直接修改宿主应用、扩展和测试实现代码。

### `02-实现-Generator`

- 独占负责以下写入范围：
  - `LiteShuntApp/`
  - `LiteShuntExtension/`
  - `LiteShuntShared/`
  - `LiteShuntTests/`
  - `Tests/`
  - `script/`
  - `docs/ai/HANDOFF.md`
- 如需更新任务文件，只允许补充执行现场，不得擅自改写 contract。
- 不得修改：
  - `PLAN.md`
  - `TECHNICAL_DESIGN.md`
  - `README.md`
  - `docs/ai/OWNERSHIP.md`
  - `docs/ai/QA_REPORT.md`

### `03-验收-Evaluator`

- 只读规格、任务与实现结果。
- 仅允许写 `docs/ai/QA_REPORT.md` 和必要的任务文件验收现场。
- 不得替代实现线程补代码。

## 4. LiteShunt 推荐模块归属

如果后续需要多个实现线程，可参考以下拆分：

| 模块 | 推荐实现线程 | 目录 |
| --- | --- | --- |
| 宿主应用 UI 与设置 | `Generator-App` | `LiteShuntApp/` |
| 扩展流量处理与转发 | `Generator-Extension` | `LiteShuntExtension/` |
| 共享模型与常量 | `Generator-Shared` | `LiteShuntShared/`、`Sources/LiteShuntShared/` |
| 单元测试与验证代码 | `Generator-Tests` | `LiteShuntTests/`、`Tests/` |

## 5. 冲突处理规则

- 如果两个实现线程需要改同一目录，先由 `主控` 重划边界。
- 未经 `主控` 明确授权，不要跨线程修改对方负责目录。
- 若发现本轮目标需要跨多个核心目录联动，优先由 `Planner` 重新拆分 contract 或细化任务文件。
