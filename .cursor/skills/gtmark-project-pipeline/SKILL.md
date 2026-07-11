---
name: gtmark-project-pipeline
description: >-
  GTMark 五框架串联写项目流水线。在用户要从零写项目、新建工程、搭建代码库，
  或说「五框架串联」「gtmark 写项目」「agent-frameworks 写项目」「gtmark-project-pipeline」时使用。
  按 Prompt Optimizer → DeerFlow → 实现 → Ruflo → Letta 顺序执行。
---

# GTMark 项目构建流水线

将 **ECC + Prompt Optimizer + DeerFlow + Ruflo + Letta** 串联为可重复的新项目工作流。

## 何时激活

- 用户要从零创建项目、新仓库、新功能模块（含脚手架）
- 用户明确要求五框架串联或引用本 skill 名称
- 用户说「用 GTMark 写项目」「全流程写项目」

**轻量跳过**：仅改 1–2 个文件、修 bug、回答问题 → 不激活本 skill。

## 前置条件

```bash
bash start.sh
bash scripts/health-check.sh
```

| 服务 | 地址 | 用途 |
|------|------|------|
| Prompt Optimizer | `http://localhost:3001/mcp` | 阶段 1 |
| DeerFlow Web | `http://localhost:2026` | 阶段 2 |
| DeerFlow API | `http://localhost:8001` | 阶段 2 备选 |
| Ruflo / Letta | Cursor MCP（stdio） | 阶段 4–5 |

API Key 从 `.env` 读取，禁止硬编码。

---

## 流水线总览

```
阶段 0  ECC              规则/钩子自动兜底（无需显式调用）
阶段 1  Prompt Optimizer  需求 → 项目 Brief + 开发 System Prompt
阶段 2  DeerFlow           技术调研、选型、风险
阶段 3  实现               按 Brief + RESEARCH 写代码（ECC skills 辅助）
阶段 4  Ruflo              跨会话记忆：决策 / 模式 / 踩坑
阶段 5  Letta              长期记忆代理，供后续会话恢复上下文
```

每阶段结束须通过 `checklist.md` 对应门禁，再进入下一阶段。

---

## 阶段 0 — ECC 基线（自动）

- `.cursor/rules/`、`hooks.json`、相关 ECC skills（如 `tdd-workflow`、`coding-standards`）全程生效
- 实现阶段按项目语言选用对应 `*-patterns` / `*-security` 规则

---

## 阶段 1 — 需求澄清与 Prompt 优化

**工具**：Prompt Optimizer MCP

1. 向用户确认（缺失则追问）：
   - 项目名、目标用户、核心功能
   - 技术约束（语言、框架、部署环境）
   - 交付物与验收标准
2. 调用 `optimize-user-prompt`，输入原始需求，产出结构化 **项目 Brief**
3. 调用 `optimize-system-prompt`，产出 **开发 Agent 系统提示**（编码规范、目录结构、测试要求）
4. 用 `templates/project-brief.md` 格式化，写入目标项目：

```
docs/PROJECT_BRIEF.md
docs/AGENT_SYSTEM_PROMPT.md
```

**门禁**：Brief 必须含「目标 / 范围 / 非目标 / 验收标准」四项，否则不进入阶段 2。

---

## 阶段 2 — 深度调研

**工具**：DeerFlow

**方式 A（推荐）**：引导用户或自行通过 http://localhost:2026 提交调研任务  
**方式 B**：调用 Gateway API `http://localhost:8001`（需服务已启动）

调研输入 = 阶段 1 的 `PROJECT_BRIEF.md`。

调研维度（可并行子任务）：

- 技术选型与依赖
- 同类方案 / 竞品
- 推荐目录结构与模块划分
- 安全、部署、已知风险

产出：`docs/RESEARCH.md`（结论 + 来源 + 推荐方案）

**门禁**：`RESEARCH.md` 有明确技术选型与理由；否则回到阶段 1 补充约束。

**降级**：DeerFlow 不可用时，由 Cursor Agent 完成调研，并在 `RESEARCH.md` 顶部注明 `fallback: cursor-research`。

---

## 阶段 3 — 实现

**工具**：Cursor Agent + ECC skills

1. 阅读 `PROJECT_BRIEF.md`、`RESEARCH.md`、`AGENT_SYSTEM_PROMPT.md`
2. 创建项目骨架（`README`、依赖清单、基础目录）
3. 按验收标准分模块实现；复杂项目优先 `tdd-workflow`
4. 每完成一个模块，对照 Brief 中的 AC 自检

产出：

- 可运行代码
- `README.md`（含 install / run / test）
- 测试（按 Brief 要求）

**门禁**：新人可按 README 完成 `clone → install → run`。

---

## 阶段 4 — 知识沉淀（Ruflo）

**工具**：Ruflo MCP

调用 `memory_store`（或等价工具），键名规范：

| 键 | 内容 |
|----|------|
| `{项目名}/decisions` | 架构决策及原因 |
| `{项目名}/patterns` | 可复用代码模式 |
| `{项目名}/pitfalls` | 踩坑与解法 |
| `{项目名}/summary` | 项目一句话摘要 |

**降级**：Ruflo 不可用时，写入 `docs/MEMORY.md`。

---

## 阶段 5 — 长期记忆（Letta）

**工具**：Letta MCP

1. 创建或恢复 agent：`GTMark-{项目名}-advisor`
2. 写入：Brief 摘要、技术栈、关键决策、未完成 TODO
3. 向用户返回 **agent ID**，供后续 `letta_chat_with_agent` 续聊

**降级**：Letta 不可用时，将同上内容追加到 `docs/MEMORY.md`。

---

## 阶段交接

阶段切换时，用 `templates/handoff.md` 向用户汇报：

- 本阶段产出文件路径
- 门禁是否通过
- 下一阶段计划

---

## 用户触发示例

```text
用 gtmark-project-pipeline 从零写项目：

项目名：TodoApp
目标：React 待办应用，本地存储
要求：增删改、暗黑模式、单元测试
```

```text
五框架串联，帮我做一个 FastAPI + SQLite 的笔记 API，要有 OpenAPI 文档和 pytest。
```

---

## 轻量模式

满足以下全部条件时，可跳过阶段 2：

- 预估新增文件 < 5
- 无新技术栈引入
- 用户未要求调研

流程：阶段 1（简版 Brief）→ 阶段 3 → 阶段 4（仅 summary）

---

## 故障处理

| 现象 | 处理 |
|------|------|
| Prompt Optimizer 不可用 | `bash start.sh`；仍失败则手动写 Brief |
| DeerFlow 不可用 | 阶段 2 降级为 Cursor 调研 |
| Ruflo / Letta 红 | 阶段 4–5 写入 `docs/MEMORY.md` |
| 首次 DeerFlow | 访问 http://localhost:2026/setup 创建管理员 |

---

## 相关 Skills

| Skill | 关系 |
|-------|------|
| `agent-frameworks` | 单框架路由入口 |
| `prompt-optimizer` | 阶段 1 细节 |
| `deer-flow` | 阶段 2 细节 |
| `ruflo` / `letta` | 阶段 4–5 细节 |
| `tdd-workflow` | 阶段 3 测试驱动 |
