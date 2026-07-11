# GTMark 项目流水线 — 阶段门禁清单

Agent 每阶段结束前对照本清单，全部满足方可进入下一阶段。

## 阶段 1 — Prompt 优化

- [ ] 已确认：项目名、目标用户、核心功能、技术约束、交付物
- [ ] 已调用 Prompt Optimizer MCP（或用户明确跳过）
- [ ] `docs/PROJECT_BRIEF.md` 已创建
- [ ] Brief 含：**目标 / 范围 / 非目标 / 验收标准**
- [ ] `docs/AGENT_SYSTEM_PROMPT.md` 已创建（或合并入 Brief 附录）

## 阶段 2 — DeerFlow 调研

- [ ] `docs/RESEARCH.md` 已创建
- [ ] 含技术选型及理由
- [ ] 含推荐目录结构或模块划分
- [ ] 含风险点或备选方案
- [ ] 若降级调研，文件顶部有 `fallback:` 说明

## 阶段 3 — 实现

- [ ] 项目骨架与依赖已就绪
- [ ] `README.md` 含 install / run / test 说明
- [ ] 对照 Brief 验收标准，核心 AC 已通过
- [ ] 无已知阻塞性 lint / 构建错误

## 阶段 4 — Ruflo 沉淀

- [ ] 已写入 `{项目名}/decisions`、`patterns`、`pitfalls`、`summary`
- [ ] 或已写入 `docs/MEMORY.md`（降级）

## 阶段 5 — Letta 长期记忆

- [ ] 已创建或更新 Letta agent
- [ ] 已向用户返回 agent ID 或续聊方式
- [ ] 或已追加 `docs/MEMORY.md`（降级）

## 最终交付

- [ ] 向用户汇总：产出文件列表、Letta agent ID、后续续作方式
- [ ] 提示：下次可说「恢复 {项目名} 项目，继续 gtmark-project-pipeline」
