# [PROJECT_NAME] Constitution（项目宪章）
<!-- 示例：Spec Constitution、TaskFlow Constitution 等 -->

## Core Principles（核心原则）

### [PRINCIPLE_1_NAME]
<!-- 示例：I. Library-First（库优先） -->
[PRINCIPLE_1_DESCRIPTION]
<!-- 示例：每个功能都应先抽象为独立库；库必须自包含、可独立测试、具备文档；必须有明确业务目的，不能只为组织代码而建库 -->

### [PRINCIPLE_2_NAME]
<!-- 示例：II. CLI Interface（命令行接口） -->
[PRINCIPLE_2_DESCRIPTION]
<!-- 示例：每个库都应通过 CLI 暴露能力；文本输入输出协议：stdin/args → stdout，错误 → stderr；同时支持 JSON 和人类可读格式 -->

### [PRINCIPLE_3_NAME]
<!-- 示例：III. Test-First（先测后写，非妥协项） -->
[PRINCIPLE_3_DESCRIPTION]
<!-- 示例：必须执行 TDD：先写测试 → 用户确认 → 测试失败 → 再实现；严格遵守 Red-Green-Refactor 周期 -->

### [PRINCIPLE_4_NAME]
<!-- 示例：IV. Integration Testing（集成测试） -->
[PRINCIPLE_4_DESCRIPTION]
<!-- 示例：以下场景必须有集成测试：新增库的契约测试、契约变更、服务间通信、共享 Schema -->

### [PRINCIPLE_5_NAME]
<!-- 示例：V. Observability、VI. Versioning & Breaking Changes、VII. Simplicity -->
[PRINCIPLE_5_DESCRIPTION]
<!-- 示例：文本输入输出便于调试；必须有结构化日志；或：使用 MAJOR.MINOR.BUILD 版本规范；或：坚持简单优先、遵循 YAGNI -->

## [SECTION_2_NAME]
<!-- 示例：Additional Constraints（附加约束）、Security Requirements（安全要求）、Performance Standards（性能标准）等 -->

[SECTION_2_CONTENT]
<!-- 示例：技术栈要求、合规标准、部署策略等 -->

## [SECTION_3_NAME]
<!-- 示例：Development Workflow（开发流程）、Review Process（评审流程）、Quality Gates（质量门禁）等 -->

[SECTION_3_CONTENT]
<!-- 示例：代码评审要求、测试门槛、上线审批流程等 -->

## Governance（治理）
<!-- 示例：宪章优先于其他实践；修订必须附带文档、审批与迁移计划 -->

[GOVERNANCE_RULES]
<!-- 示例：所有 PR / review 都必须校验是否符合宪章；复杂度必须有正当理由；运行期开发指南可引用 [GUIDANCE_FILE] -->

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
<!-- 示例：Version: 2.1.1 | Ratified: 2025-06-13 | Last Amended: 2025-07-16 -->
