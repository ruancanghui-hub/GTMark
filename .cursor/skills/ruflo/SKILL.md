---
name: ruflo
description: Coordinates Ruflo agent swarms, self-learning memory, and federated multi-machine agents via MCP. Use when the user mentions Ruflo, ruflo, agent swarm, swarm_init, memory_store, or multi-agent coordination harness.
---

# Ruflo

Claude Code / Codex 的元.harness：100+ 专用代理、群体协调、自学习记忆、联邦通信。

## MCP 接入（Cursor 已配置）

```json
"ruflo": {
  "command": "npx",
  "args": ["-y", "ruflo@latest", "mcp", "start"]
}
```

重载 Cursor MCP 后即可调用 `memory_store`、`swarm_init`、`agent_spawn` 等工具。

## 完整安装（可选，项目级）

```bash
npx ruflo@latest init wizard
```

会在项目中生成 `.claude/`、`.claude-flow/`、hooks、daemon。与 Cursor 并存时注意目录冲突。

## 典型 MCP 场景

- **群体任务**：`swarm_init` → `agent_spawn` → 并行子任务
- **跨会话记忆**：`memory_store` / `memory_retrieve`
- **联邦**：多机代理安全通信（需 ruflo-federation 插件）

## 轻量路径 vs 完整路径

| | Plugin only | `npx ruflo init` |
|--|------------|------------------|
| MCP | 否 | 是 |
| Hooks | 否 | 是 |
| 适用 | 试用 slash 命令 | 生产级全功能 |

Cursor 用户推荐：**仅 MCP**（已在 `.cursor/mcp.json` 配置）。

## 参考

- https://github.com/ruvnet/ruflo
- UI Beta: https://flo.ruv.io/
