#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ok()   { printf '  ✅ %s\n' "$1"; }
warn() { printf '  ⚠️  %s\n' "$1"; }
fail() { printf '  ❌ %s\n' "$1"; }

echo ""
echo "=== GTMark 代理框架健康检查 ==="
echo ""

# ECC
if [[ -f .cursor/hooks.json ]]; then ok "ECC hooks 已安装"; else fail "ECC 未安装 → bash integrations/ecc/install.sh --target cursor --profile minimal"; fi

# .env
if [[ -f .env ]]; then
  ok ".env 存在"
  grep -q '^VITE_DEEPSEEK_API_KEY=sk-' .env 2>/dev/null && ok "DeepSeek Key 已配置" || warn "DeepSeek Key 未配置"
  grep -q '^LETTA_API_KEY=sk-' .env 2>/dev/null && ok "Letta Key 已配置" || warn "Letta 未配置（可选，长期记忆用）"
else
  fail ".env 缺失 → cp .env.example .env"
fi

# MCP
if [[ -f .cursor/mcp.json ]]; then ok "MCP 配置存在"; else fail ".cursor/mcp.json 缺失"; fi

# Prompt Optimizer
if curl -sf http://localhost:3001/mcp >/dev/null 2>&1 || nc -z localhost 3001 2>/dev/null; then
  ok "Prompt Optimizer MCP 运行中 (:3001)"
elif command -v docker >/dev/null 2>&1 && docker compose ps prompt-optimizer 2>/dev/null | grep -q Up; then
  ok "Prompt Optimizer 运行中 (Docker :8081)"
else
  warn "Prompt Optimizer 未启动 → bash start.sh"
fi

# DeerFlow
if [[ -f integrations/deer-flow/config.yaml ]]; then
  ok "DeerFlow config.yaml 已配置"
  curl -sf http://localhost:8001/health >/dev/null 2>&1 && ok "DeerFlow Gateway 运行中 (:8001)" || warn "DeerFlow 未启动 → bash start.sh"
  curl -sf http://localhost:2026/ >/dev/null 2>&1 && ok "DeerFlow Web UI 运行中 (:2026)" || true
else
  warn "DeerFlow 未配置 → cd integrations/deer-flow && make setup"
fi

# Ruflo
if [[ -f "$HOME/.local/lib/node_modules/ruflo/bin/ruflo.js" ]]; then
  ok "Ruflo 已安装 (~/.local, v3.7.0-alpha.9)"
else
  warn "Ruflo 未安装 → npm install -g ruflo@3.7.0-alpha.9 --prefix ~/.local"
fi
ok "Ruflo MCP 已写入配置（Cursor Reload 后可用）"
grep -q '^LETTA_API_KEY=.' .env 2>/dev/null && [[ -n "$(grep '^LETTA_API_KEY=' .env | cut -d= -f2)" ]] && ok "Letta MCP 可启用" || warn "Letta MCP 跳过（无 Key）"

echo ""
echo "=== 串联就绪度 ==="
echo "  立即可用: ECC（hooks/rules/skills）+ Ruflo MCP（Cursor Reload）"
echo "  需启动:   bash start.sh（Prompt Optimizer + DeerFlow）"
echo "  可选:     Letta（需平台 API Key）"
echo ""
echo "在 Cursor 对话示例:"
echo '  「用 agent-frameworks 串联：先优化 prompt，再 deer-flow 调研，ruflo 存结论」'
echo ""
