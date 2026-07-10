---
name: prompt-optimizer
description: Optimizes AI prompts via Prompt Optimizer MCP tools (optimize-user-prompt, optimize-system-prompt, iterate-prompt). Use when the user asks to optimize, refine, or iterate prompts, system prompts, or user prompts for better LLM output.
---

# Prompt Optimizer

通过 MCP 优化 system/user prompt，提升 LLM 输出质量。

## MCP 工具

| 工具 | 用途 |
|-----|------|
| `optimize-user-prompt` | 优化用户提示 |
| `optimize-system-prompt` | 优化系统提示 |
| `iterate-prompt` | 基于反馈迭代成熟 prompt |

## 启动服务

```bash
# Docker（推荐）
docker compose up -d prompt-optimizer
# MCP: http://localhost:8081/mcp

# 或在线版（无需部署）
# https://prompt.always200.com
```

## 在 Cursor 中使用

1. 确认 `.cursor/mcp.json` 含 `prompt-optimizer`（url: `http://localhost:8081/mcp`）
2. 在 Cursor Settings → MCP 启用并重载
3. 直接请求：「用 prompt-optimizer 优化这段 system prompt：...」

## 环境变量（`.env`）

```bash
VITE_OPENAI_API_KEY=sk-...
MCP_DEFAULT_MODEL_PROVIDER=openai
MCP_DEFAULT_LANGUAGE=zh
```

## 工作流

1. 用户提供原始 prompt + 目标场景
2. 调用对应 MCP 工具
3. 展示优化结果，可选 A/B 对比
4. 将最终 prompt 保存到项目文件（用户确认后）
