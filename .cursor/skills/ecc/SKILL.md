---
name: ecc
description: Uses ECC (Everything Claude Code) skills, hooks, rules, agents, and continuous learning in Cursor. Use when the user mentions ECC, everything-claude-code, agent skills pack, continuous learning instincts, or production agent harness patterns.
---

# ECC

完整代理系统：技能、直觉、内存优化、持续学习、安全扫描、研究优先开发。

## 安装到当前项目

```bash
bash scripts/setup-frameworks.sh
# 或手动：
cd integrations/ecc
./install.sh --target cursor --profile minimal typescript python
```

## Cursor 已安装内容

| 组件 | 位置 |
|-----|------|
| Hooks | `.cursor/hooks.json` |
| Rules | `.cursor/rules/` |
| Agents | `.cursor/agents/ecc-*.md` |
| Skills | `.cursor/skills/` |
| MCP | `.cursor/mcp.json` |

## 常用操作

```bash
# 状态与健康
cd integrations/ecc && node scripts/ecc.js doctor
node scripts/ecc.js status --markdown

# 顾问：推荐安装组件
node scripts/ecc.js advise "我需要 ML 工作流"

# Dashboard
npm run dashboard
```

## 内存隔离

Cursor 与 Claude Code 并存时，ECC 默认将数据存于 `~/.cursor/ecc`：

```bash
export ECC_AGENT_DATA_HOME="$HOME/.cursor/ecc"
```

## 注意

- **不要** 同时用 plugin install 和 `install.sh --profile full`，会重复
- 仅需规则时：`./install.sh --profile minimal --without baseline:hooks --target cursor`
- 卸载：`node scripts/uninstall.js --dry-run` 后 `node scripts/uninstall.js`
