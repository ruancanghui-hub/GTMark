---
name: letta
description: Builds and manages Letta stateful agents with long-term memory and self-improvement via MCP and CLI. Use when the user mentions Letta, MemGPT, agent memory, persistent agents, or letta_create_agent.
---

# Letta

构建具有先进记忆能力的 AI，支持跨会话学习与自我改进。

## 双通道接入

### 1. MCP（Cursor 已配置）

```json
"letta": {
  "command": "npx",
  "args": ["-y", "letta-mcp-server"],
  "env": { "LETTA_API_KEY": "...", "LETTA_BASE_URL": "..." }
}
```

在 `.env` 配置 `LETTA_API_KEY`（从 https://app.letta.com/api-keys 获取）。

### 2. CLI

```bash
npm install -g @letta-ai/letta-code
letta                          # 交互式代理
letta --new-agent --personality tutorial
```

## 典型工作流

1. **创建记忆代理**：通过 MCP `letta_create_agent` 或 CLI `/connect`
2. **对话**：MCP `letta_chat_with_agent` 或 CLI 直接对话
3. **记忆管理**：MCP memory/block 工具管理 persona、human、archival

## 后端选择

| 模式 | 配置 |
|-----|------|
| Cloud | `LETTA_BASE_URL=https://api.letta.com` + API Key |
| Local | `letta-code` CLI，`backend: "local"` |
| Self-hosted | App Server @ 自定义 URL |

## 在 Cursor 中调用示例

「用 Letta 为这个项目创建一个带长期记忆的开发助手，记住我们的架构决策。」

Agent 应：检查 MCP 可用 → 创建/恢复 agent → 注入项目上下文 → 返回 agent ID 供后续会话复用。

## 参考

- CLI: https://github.com/letta-ai/letta-code
- Docs: https://docs.letta.com/letta-agent
