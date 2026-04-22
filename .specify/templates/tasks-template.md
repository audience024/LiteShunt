---

description: "功能实现任务清单模板"
---

# Tasks（任务清单）: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`  
**Prerequisites**: `plan.md`（必需）, `spec.md`（用户故事必需）, `research.md`, `data-model.md`, `contracts/`

**Tests**: 下方示例包含测试任务。测试是 OPTIONAL（可选）的，只有当 feature specification 明确要求时才应纳入。

**Organization**: 任务按 user story 分组，目的是让每个故事都能独立实现、独立验证。

## Format（格式）: `[ID] [P?] [Story] Description`

- **[P]**: 可并行执行（不同文件、无依赖）
- **[Story]**: 该任务属于哪个 user story（例如 `US1`、`US2`、`US3`）
- 任务描述中必须写出准确文件路径

## Path Conventions（路径约定）

- **Single project**: 仓库根目录下使用 `src/`、`tests/`
- **Web app**: 使用 `backend/src/`、`frontend/src/`
- **Mobile**: 使用 `api/src/`、`ios/src/` 或 `android/src/`
- 下方路径示例默认按 single project 编写，请根据 `plan.md` 的结构调整

<!-- 
  ============================================================================
  IMPORTANT（重要）：
  下方任务仅为示例，用于说明结构和写法。

  /speckit.tasks 命令必须将这些示例替换为真实任务，依据包括：
  - spec.md 中的 user stories（及其优先级 P1、P2、P3...）
  - plan.md 中的功能需求
  - data-model.md 中的实体
  - contracts/ 中的接口或契约

  任务必须按 user story 组织，确保每个故事都可以：
  - 独立实现
  - 独立测试
  - 作为一次 MVP 增量独立交付

  不要在最终生成的 tasks.md 中保留这些示例任务。
  ============================================================================
-->

## Phase 1: Setup（初始化 / 共享基础设施）

**Purpose（目的）**: 项目初始化与基础结构搭建

- [ ] T001 按实现计划创建项目结构
- [ ] T002 使用 [framework] 依赖初始化 [language] 项目
- [ ] T003 [P] 配置 lint 和格式化工具

---

## Phase 2: Foundational（基础能力 / 阻塞前置）

**Purpose（目的）**: 在开始任何 user story 之前必须完成的核心基础能力

**⚠️ CRITICAL（关键）**: 在本阶段完成前，不得开始任何 user story 开发

基础任务示例（请根据项目实际情况调整）：

- [ ] T004 搭建数据库 Schema 与迁移框架
- [ ] T005 [P] 实现认证 / 授权框架
- [ ] T006 [P] 搭建 API 路由与中间件结构
- [ ] T007 创建所有故事共用的基础模型 / 实体
- [ ] T008 配置错误处理与日志基础设施
- [ ] T009 配置环境变量与配置管理机制

**Checkpoint（检查点）**: 基础能力已就绪，后续 user story 可并行推进

---

## Phase 3: User Story 1（用户故事 1）- [标题] (Priority: P1) 🎯 MVP

**Goal（目标）**: [简要说明该故事交付什么价值]

**Independent Test（独立验证）**: [说明如何独立验证该故事]

### Tests for User Story 1（用户故事 1 的测试，可选）⚠️

> **NOTE（注意）: 这些测试应先写，且在实现前必须先失败**

- [ ] T010 [P] [US1] 为 [endpoint] 编写契约测试，文件：`tests/contract/test_[name].py`
- [ ] T011 [P] [US1] 为 [user journey] 编写集成测试，文件：`tests/integration/test_[name].py`

### Implementation for User Story 1（用户故事 1 的实现）

- [ ] T012 [P] [US1] 在 `src/models/[entity1].py` 中创建 `[Entity1]` 模型
- [ ] T013 [P] [US1] 在 `src/models/[entity2].py` 中创建 `[Entity2]` 模型
- [ ] T014 [US1] 在 `src/services/[service].py` 中实现 `[Service]`（依赖 T012、T013）
- [ ] T015 [US1] 在 `src/[location]/[file].py` 中实现 `[endpoint/feature]`
- [ ] T016 [US1] 增加校验与错误处理
- [ ] T017 [US1] 为用户故事 1 的操作增加日志

**Checkpoint（检查点）**: 到这里，用户故事 1 应已可独立运行并完成验证

---

## Phase 4: User Story 2（用户故事 2）- [标题] (Priority: P2)

**Goal（目标）**: [简要说明该故事交付什么价值]

**Independent Test（独立验证）**: [说明如何独立验证该故事]

### Tests for User Story 2（用户故事 2 的测试，可选）⚠️

- [ ] T018 [P] [US2] 为 [endpoint] 编写契约测试，文件：`tests/contract/test_[name].py`
- [ ] T019 [P] [US2] 为 [user journey] 编写集成测试，文件：`tests/integration/test_[name].py`

### Implementation for User Story 2（用户故事 2 的实现）

- [ ] T020 [P] [US2] 在 `src/models/[entity].py` 中创建 `[Entity]` 模型
- [ ] T021 [US2] 在 `src/services/[service].py` 中实现 `[Service]`
- [ ] T022 [US2] 在 `src/[location]/[file].py` 中实现 `[endpoint/feature]`
- [ ] T023 [US2] 如有需要，与用户故事 1 的组件集成

**Checkpoint（检查点）**: 到这里，用户故事 1 和 2 都应可以独立工作

---

## Phase 5: User Story 3（用户故事 3）- [标题] (Priority: P3)

**Goal（目标）**: [简要说明该故事交付什么价值]

**Independent Test（独立验证）**: [说明如何独立验证该故事]

### Tests for User Story 3（用户故事 3 的测试，可选）⚠️

- [ ] T024 [P] [US3] 为 [endpoint] 编写契约测试，文件：`tests/contract/test_[name].py`
- [ ] T025 [P] [US3] 为 [user journey] 编写集成测试，文件：`tests/integration/test_[name].py`

### Implementation for User Story 3（用户故事 3 的实现）

- [ ] T026 [P] [US3] 在 `src/models/[entity].py` 中创建 `[Entity]` 模型
- [ ] T027 [US3] 在 `src/services/[service].py` 中实现 `[Service]`
- [ ] T028 [US3] 在 `src/[location]/[file].py` 中实现 `[endpoint/feature]`

**Checkpoint（检查点）**: 到这里，所有用户故事都应具备独立可用性

---

[如有需要，可继续增加更多 user story 阶段，保持相同结构]

---

## Phase N: Polish & Cross-Cutting Concerns（打磨与横切关注点）

**Purpose（目的）**: 处理影响多个 user story 的优化与补充工作

- [ ] TXXX [P] 更新 `docs/` 中的文档
- [ ] TXXX 清理代码并完成重构
- [ ] TXXX 针对所有故事做性能优化
- [ ] TXXX [P] 在 `tests/unit/` 中补充单元测试（如有要求）
- [ ] TXXX 做安全加固
- [ ] TXXX 执行 `quickstart.md` 校验

---

## Dependencies & Execution Order（依赖与执行顺序）

### Phase Dependencies（阶段依赖）

- **Setup（Phase 1）**: 无依赖，可立即开始
- **Foundational（Phase 2）**: 依赖 Setup 完成，并阻塞所有 user story
- **User Stories（Phase 3+）**: 全部依赖 Foundational 完成
  - 有人力时可并行推进
  - 也可按优先级顺序推进（P1 → P2 → P3）
- **Polish（最终阶段）**: 依赖所有目标 user story 完成

### User Story Dependencies（用户故事依赖）

- **User Story 1（P1）**: Foundational（Phase 2）完成后即可开始，不依赖其他故事
- **User Story 2（P2）**: Foundational（Phase 2）完成后即可开始，允许与 `US1` 集成，但仍应可独立验证
- **User Story 3（P3）**: Foundational（Phase 2）完成后即可开始，允许与 `US1` / `US2` 集成，但仍应可独立验证

### Within Each User Story（每个用户故事内部顺序）

- 如果包含测试，必须先写测试并确保其先失败
- 先模型，再服务
- 先服务，再接口
- 先核心实现，再集成
- 当前故事完成后，再进入下一优先级

### Parallel Opportunities（可并行机会）

- 所有标记 `[P]` 的 Setup 任务可并行
- 所有标记 `[P]` 的 Foundational 任务可在 Phase 2 内并行
- Foundational 完成后，所有 user story 可在团队容量允许时并行开始
- 单个故事中标记 `[P]` 的测试可并行
- 单个故事中标记 `[P]` 的模型任务可并行
- 不同 user story 可由不同成员并行推进

---

## Parallel Example（并行示例）: User Story 1

```bash
# 一起启动 User Story 1 的所有测试（如果本次要求测试）：
Task: "为 [endpoint] 编写契约测试，文件：tests/contract/test_[name].py"
Task: "为 [user journey] 编写集成测试，文件：tests/integration/test_[name].py"

# 一起启动 User Story 1 的所有模型任务：
Task: "在 src/models/[entity1].py 中创建 [Entity1] 模型"
Task: "在 src/models/[entity2].py 中创建 [Entity2] 模型"
```

---

## Implementation Strategy（实施策略）

### MVP First（只先做 User Story 1）

1. 完成 Phase 1：Setup
2. 完成 Phase 2：Foundational（关键阶段，阻塞所有故事）
3. 完成 Phase 3：User Story 1
4. **STOP and VALIDATE**: 独立验证 User Story 1
5. 如果准备就绪，则部署 / 演示

### Incremental Delivery（增量交付）

1. 完成 Setup + Foundational → 基础能力就绪
2. 增加 User Story 1 → 独立测试 → 部署 / 演示（MVP）
3. 增加 User Story 2 → 独立测试 → 部署 / 演示
4. 增加 User Story 3 → 独立测试 → 部署 / 演示
5. 每个故事都应在不破坏前序故事的前提下持续增加价值

### Parallel Team Strategy（多人并行策略）

如果有多名开发者：

1. 团队先共同完成 Setup + Foundational
2. Foundational 完成后：
   - 开发者 A：负责 User Story 1
   - 开发者 B：负责 User Story 2
   - 开发者 C：负责 User Story 3
3. 各故事独立完成并逐步集成

---

## Notes（说明）

- `[P]` 任务 = 不同文件、无依赖、可并行执行
- `[Story]` 标签用于把任务映射到具体 user story，便于追踪
- 每个 user story 都应能独立完成、独立测试
- 实现前要先确认测试处于失败状态
- 每完成一个任务或一组逻辑闭环任务后及时提交
- 在任一检查点都应支持停下来独立验证当前故事
- 避免：任务过于模糊、同文件冲突、破坏独立性的跨故事依赖
