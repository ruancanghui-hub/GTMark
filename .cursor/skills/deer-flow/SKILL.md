---
name: deer-flow
description: Runs ByteDance DeerFlow super-agent harness for deep research, sub-agents, memory, and sandbox tasks. Use when the user mentions DeerFlow, deer-flow, deep research flow, super agent harness, or delegated multi-agent research.
---

# DeerFlow

开源超级代理框架，协调子代理、内存和沙箱执行复杂任务。

## 何时使用

- 多步骤深度研究与报告生成
- 需要子代理并行探索
- 沙箱内执行代码/文件操作
- 可扩展技能驱动的自动化流程

## 启动

```bash
cd integrations/deer-flow
make setup          # 首次：交互式配置
make doctor         # 健康检查
make dev            # 本地开发（Gateway ~:8001）
# 或 Docker: make docker-start
```

## 在 Cursor 中调用

**方式 A — 嵌入式 CLI（无需 Gateway）：**

```bash
cd integrations/deer-flow
deerflow "研究主题：..."
```

**方式 B — Gateway API：**

```bash
curl -s http://localhost:8001/api/health
```

**方式 C — 让 Cursor Agent 引导安装：**

```text
Help me bootstrap DeerFlow by following https://raw.githubusercontent.com/bytedance/deer-flow/main/Install.md
```

## 配置要点

- `config.yaml` — 模型、沙箱、MCP 扩展
- `extensions_config.json` — 额外 MCP 服务器
- `.env` — API keys

## 注意

- DeerFlow 2.0 与 1.x 无代码共享
- 生产部署需配置认证网关，见官方安全说明
