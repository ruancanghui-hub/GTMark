#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env"

start_deerflow() {
  local dir="$ROOT/integrations/deer-flow"
  [[ -d "$dir" ]] || { echo "请先运行 scripts/setup-frameworks.sh"; exit 1; }
  cd "$dir"
  if [[ -f Makefile ]] && grep -q '^dev:' Makefile; then
    make dev &
  elif [[ -f Makefile ]] && grep -q '^up:' Makefile; then
    make up &
  else
    echo "在 $dir 中手动启动 DeerFlow"
    exit 1
  fi
  echo "DeerFlow Gateway: http://localhost:8001"
}

start_prompt_optimizer() {
  docker compose -f "$ROOT/docker-compose.yml" --env-file "$ENV_FILE" up -d prompt-optimizer
  echo "Prompt Optimizer MCP: http://localhost:8081/mcp"
}

case "${1:-all}" in
  deerflow) start_deerflow ;;
  prompt-optimizer|prompt) start_prompt_optimizer ;;
  all)
    start_prompt_optimizer 2>/dev/null || true
    echo "MCP 服务 (ruflo/letta) 由 Cursor 按需启动"
    echo "DeerFlow 需单独: scripts/start-services.sh deerflow"
    ;;
  *) echo "用法: $0 [all|deerflow|prompt-optimizer]"; exit 1 ;;
esac
