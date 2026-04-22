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
- 当前 LiteShunt 已启用“协作增强层 + 任务文件核心层”的组合模式：协作文件负责角色分工，任务文件负责保存可恢复的任务现场。
- 当前项目仍处于 `M2 POC 验证` 阶段，所有任务默认遵守 `TECHNICAL_DESIGN.md` 与 `PLAN.md` 的范围边界。

## 2. 文件职责

- `SPEC.md`：由 `Planner` 维护，定义本轮唯一主任务的 contract。
- `TASK_LIST.md`：由 `Planner` 和 `主控` 维护，只做任务导航、依赖说明和任务文件入口。
- `tasks/*.md`：任务文件事实源，保存每个核心任务的静态边界与动态执行现场。
- `OWNERSHIP.md`：由 `主控` 维护，约束各线程职责与写入边界。
- `HANDOFF.md`：由 `Generator` 维护，记录实现结果、风险与后续建议。
- `QA_REPORT.md`：由 `Evaluator` 维护，输出验收结论与问题清单。
- `THREAD_PROMPTS.md`：保存线程命名建议与首条启动 prompt。

## 3. 推荐工作流

1. `主控` 先确认当前唯一主任务，并检查 `TASK_LIST.md` 与对应任务文件是否存在。
2. `Planner` 更新 `SPEC.md` 与当前任务文件，收敛本轮目标、边界、完成标准与执行现场。
3. `Generator` 严格按任务文件和 `OWNERSHIP.md` 实现，完成后更新 `HANDOFF.md`，必要时回写任务文件现场。
4. `Evaluator` 根据 `SPEC.md`、任务文件和实现结果执行验收，输出 `QA_REPORT.md`。
5. `主控` 根据验收结果决定是否收口、继续修复，或切换到下一个主任务，并同步更新 `TASK_LIST.md`。

## 4. 协作约束

- `Planner` 不直接提交业务实现代码，避免把“规格”与“实现”混在一起。
- `Generator` 不负责宣布“验收通过”，只能报告已完成内容与已知风险。
- `Evaluator` 只负责验证与指出问题，不建议直接顺手修改实现。
- 总表只做导航，不长期承载详细执行步骤。
- 任务执行现场必须优先沉淀到 `docs/ai/tasks/*.md`，保证中断后可接手。
- 所有线程都必须优先遵守项目边界：
  - 仅支持 `macOS 14+`
  - 第一版仅支持 `TCP`
  - 仅对接本机 `Clash Verge`
  - 命中失败走 `FAIL_CLOSED`
  - 不扩展到 `UDP`、`QUIC`、`DNS` 接管

## 5. 使用建议

- 小需求或单文件修复时，不必强行启用四线程，但仍建议至少维护当前任务文件。
- 涉及 POC 验证、模块拆分、实现与验收分离时，优先使用当前协作模式。
- 如果同一轮需要多个实现线程，必须先更新 `OWNERSHIP.md`，确保写入目录不重叠。
- 如果任务较大，先补任务文件，再考虑是否继续细分子任务。

## 6. 推荐配套 Skill

如果你已经在 Codex 中安装了全局 skill `liteshunt-multi-agent-orchestrator`，建议在新会话开头显式要求使用它。

推荐触发语句：

- `使用 liteshunt-multi-agent-orchestrator skill 编排这一轮 LiteShunt 开发`
- `按 LiteShunt 多智能体协作 skill 工作，并结合 docs/ai 文档推进`
- `使用 task-driven-workflow-orchestrator skill，并以 docs/ai/tasks 中的任务文件为准推进`

该类 skill 应优先读取本目录文档，并以任务文件为事实源推进协作，而不是把执行现场留在聊天记录里。
