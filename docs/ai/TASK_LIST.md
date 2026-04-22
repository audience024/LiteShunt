# 任务总目录

## 1. 状态定义

- `TODO`：任务已定义，但尚未开始执行。
- `IN_PROGRESS`：任务已有明确执行现场，允许继续推进。
- `BLOCKED`：任务存在外部阻塞，当前无法安全推进。
- `DONE`：任务已完成并满足当前阶段验收标准。

## 2. 当前主任务

- 当前唯一主任务：`POC-002`
- 当前任务文件：[docs/ai/tasks/POC-002.md](/Users/zero/Downloads/code/LiteShunt/docs/ai/tasks/POC-002.md)
- 下一候选任务：`POC-003`
- 协同中的支撑任务：`CFG-001`

## 3. 任务大纲

| 编号 | 任务标题 | 状态 | 优先级 | 依赖 | 任务文件 |
| --- | --- | --- | --- | --- | --- |
| `POC-002` | 验证按应用识别 TCP Flow | `TODO` | 高 | `POC-001` | [docs/ai/tasks/POC-002.md](/Users/zero/Downloads/code/LiteShunt/docs/ai/tasks/POC-002.md) |
| `CFG-001` | 实现共享配置快照模型 | `IN_PROGRESS` | 高 | `M2` | [docs/ai/tasks/CFG-001.md](/Users/zero/Downloads/code/LiteShunt/docs/ai/tasks/CFG-001.md) |
| `POC-003` | 验证 SOCKS5 转发链路 | `TODO` | 中 | `POC-002`、`CFG-001` | [docs/ai/tasks/POC-003.md](/Users/zero/Downloads/code/LiteShunt/docs/ai/tasks/POC-003.md) |

## 4. 任务依赖说明

- `POC-002` 依赖 `POC-001` 已完成的工程骨架与扩展入口。
- `CFG-001` 为 `POC-002` 和 `POC-003` 提供配置快照与共享读写基础。
- `POC-003` 依赖 `POC-002` 先确认真实 Flow 已进入扩展，避免先做无落点的转发链路。
- `POC-004`、`POC-005` 暂不单独建档，待 `POC-003` 接近完成后再细化为独立任务文件。

## 5. 当前维护约定

- `TASK_LIST.md` 只做导航，不长期记录详细执行步骤。
- 每个核心任务的静态约束与动态现场统一写入 `docs/ai/tasks/*.md`。
- 当前主任务发生变化时，必须同时更新本文件、对应任务文件，以及必要的 `docs/ai/SPEC.md`。
- `docs/ai/SPEC.md` 负责描述“本轮 contract”，任务文件负责保存“可恢复的执行现场”。
- 若本轮只启用单线程推进，也仍然优先维护任务文件，而不是把细节写回聊天记录。
