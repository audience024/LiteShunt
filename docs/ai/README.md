# LiteShunt 多线程协作说明

## 1. 目标

本目录用于支持 Codex App 中的多线程协同开发。当前推荐采用“四线程协作”：

1. `00-主控`
2. `01-规划-Planner`
3. `02-实现-Generator`
4. `03-验收-Evaluator`

说明：
- 线程等价于独立工作角色，不建议在同一线程里同时做规划、编码、验收。
- 线程之间优先通过本目录中的文档交接，不依赖长对话记忆。
- 当前 LiteShunt 仍处于 `M2 POC 验证` 准备阶段，所有任务默认遵守 `TECHNICAL_DESIGN.md` 与 `PLAN.md` 的范围边界。

## 2. 文件职责

- `SPEC.md`：由 `Planner` 维护，定义本轮目标、边界、验收标准。
- `TASK_LIST.md`：由 `Planner` 和 `主控` 维护，拆解任务并分配状态。
- `OWNERSHIP.md`：由 `主控` 维护，约束各线程的职责与可修改范围。
- `HANDOFF.md`：由 `Generator` 维护，记录实现结果、风险与后续建议。
- `QA_REPORT.md`：由 `Evaluator` 维护，输出验收结论与问题清单。
- `THREAD_PROMPTS.md`：保存线程命名建议与首条启动 prompt。

## 3. 推荐工作流

1. `主控` 创建或更新 `OWNERSHIP.md`，明确本轮谁负责什么。
2. `Planner` 更新 `SPEC.md` 与 `TASK_LIST.md`，定义本轮 contract。
3. `Generator` 严格按 contract 实现，完成后写入 `HANDOFF.md`。
4. `Evaluator` 根据 `SPEC.md`、`TASK_LIST.md` 与代码现状执行验收，输出 `QA_REPORT.md`。
5. `主控` 根据 `QA_REPORT.md` 决定是否进入下一轮修复或收口。

## 4. 协作约束

- `Planner` 不直接提交实现代码，避免把“规格”与“实现”混在一起。
- `Generator` 不负责宣布“验收通过”，只能报告已完成内容与已知风险。
- `Evaluator` 只负责验证与指出问题，不建议直接顺手修改实现。
- 所有线程都必须优先遵守项目边界：
  - 仅支持 `macOS 14+`
  - 第一版仅支持 `TCP`
  - 仅对接本机 `Clash Verge`
  - 命中规则失败时执行 `FAIL_CLOSED`
  - 不扩展到 `UDP`、`QUIC`、全量 `DNS`

## 5. 使用建议

- 小需求或单文件修复时，不必强行启用四线程。
- 涉及 POC 验证、模块拆分、实现与验收分离时，再启用该协作模式。
- 如果同一轮需要多个实现线程，必须先更新 `OWNERSHIP.md`，确保写入目录不重叠。

## 6. 推荐配套 Skill

如果你已经在 Codex 中安装了全局 skill `liteshunt-multi-agent-orchestrator`，建议在新会话开头显式要求使用它。

推荐触发语句：

- `使用 liteshunt-multi-agent-orchestrator skill 编排这一轮 LiteShunt 开发`
- `按 LiteShunt 多智能体协作 skill 工作，并结合 docs/ai 文档推进`

该 skill 会优先读取本目录文档，并在可用时把 `superpowers` 的规划、实现、并行和验收流程接入当前仓库协作方式。
