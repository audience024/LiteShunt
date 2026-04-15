# 本轮任务清单

## 1. 任务总览

| 编号 | 任务 | 负责人线程 | 状态 | 备注 |
| --- | --- | --- | --- | --- |
| S1 | 补全本轮规格与完成标准 | `01-规划-Planner` | DONE | 已更新 `SPEC.md`，收敛到 `POC-001` |
| S2 | 明确目录写入边界与所有权 | `00-主控` | DONE | 已更新 `OWNERSHIP.md`，写入边界已锁定 |
| S3 | 按规格完成实现 | `02-实现-Generator` | DONE | 已完成实现并更新 `HANDOFF.md` |
| S4 | 执行构建、测试与行为验收 | `03-验收-Evaluator` | DONE | 已完成验收并更新 `QA_REPORT.md` |
| S5 | 决定是否进入下一轮 | `00-主控` | DONE | 决定进入下一轮 `POC-002` |

## 2. 状态定义

- `TODO`：尚未开始
- `IN_PROGRESS`：进行中
- `BLOCKED`：有阻塞
- `DONE`：已完成

## 3. 当前建议任务池

以下任务可作为 LiteShunt 当前阶段的优先候选：

| 候选编号 | 候选任务 | 推荐优先级 | 备注 |
| --- | --- | --- | --- |
| POC-A | 验证透明代理扩展基本可用性 | 高 | 本轮唯一主目标，对齐 `POC-001` |
| POC-B | 验证按应用识别 TCP Flow | 中 | 下一轮候选，对齐 `POC-002` |
| POC-C | 验证 SOCKS5 转发链路 | 中 | 下一轮候选，对齐 `POC-003` |
| POC-D | 验证回环规避策略 | 中 | 下一轮候选，对齐 `POC-004` |
| POC-E | 验证 `FAIL_CLOSED` 策略 | 中 | 下一轮候选，对齐 `POC-005` |

## 4. 本轮实施拆解

| 子任务 | 说明 | 负责人线程 | 状态 |
| --- | --- | --- | --- |
| POC-001-A | 创建 `LiteShunt.xcodeproj` 与最小 Target 拓扑 | `02-实现-Generator` | DONE |
| POC-001-B | 建立宿主、扩展、共享、测试目录与基础源码入口 | `02-实现-Generator` | DONE |
| POC-001-C | 提供工程级构建验证命令或脚本 | `02-实现-Generator` | DONE |
| POC-001-D | 记录实际验证结果与阻塞点到 `HANDOFF.md` | `02-实现-Generator` | DONE |
| POC-001-E | 独立执行构建、测试与结构验收 | `03-验收-Evaluator` | DONE |

## 5. 维护规则

- `Planner` 负责把候选任务收敛为“本轮唯一主目标”。
- `Generator` 不得私自扩写任务范围。
- `Evaluator` 发现范围漂移时，应直接在 `QA_REPORT.md` 中指出。
