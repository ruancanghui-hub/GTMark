---
name: agent-frameworks
description: Routes tasks to DeerFlow, Prompt Optimizer, ECC, Ruflo, or Letta agent frameworks integrated in Cursor. Use when the user mentions deer-flow, deerflow, prompt-optimizer, ECC, ruflo, letta, super agent, prompt optimization, agent swarm, or long-term agent memory.
---

# Agent Frameworks Hub

GTMark 项目已集成 5 个代理框架。按用户意图加载对应 skill 或调用 MCP/CLI。

## 快速路由

| 用户意图 | 加载 Skill | 主要接口 |
|---------|-----------|---------|
| **从零写项目、五框架串联** | **`gtmark-project-pipeline`** | 全流程 SOP |
| 深度研究、子代理编排、沙箱任务 | `deer-flow` | CLI `deerflow` / Gateway `:8001` |
| 优化 system/user prompt | `prompt-optimizer` | MCP `prompt-optimizer` |
| 技能/钩子/规则/持续学习 | `ecc` | `.cursor/` ECC 资产 |
| 群体智能、跨会话记忆、联邦 | `ruflo` | MCP `ruflo` |
| 长期记忆、自我改进代理 | `letta` | MCP `letta` + CLI `letta` |

写新项目时**优先加载 `gtmark-project-pipeline`**，再按需引用上表各框架 skill。

## 前置检查

```bash
test -f .cursor/mcp.json && echo "MCP 已配置"
test -f .env && echo "环境变量已配置" || cp .env.example .env
```

## 调用约定

1. 明确用户要用的框架，加载对应 skill
2. MCP 工具优先于手写脚本
3. DeerFlow 需本地 Gateway（`:8001` / Web `:2026`）；Prompt Optimizer 本地 MCP `:3001`
4. API Key 从 `.env` 读取，勿硬编码

## 安装/修复

```bash
bash scripts/setup-frameworks.sh
bash scripts/start-services.sh all
```
