#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
GTMARK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"

load_env

log "=== 停止 GTMark 代理框架 ==="

stop_pid prompt-optimizer

if [[ -d "$ROOT/integrations/deer-flow" ]]; then
  log "停止 DeerFlow ..."
  (cd "$ROOT/integrations/deer-flow" && make stop) >/dev/null 2>&1 || true
fi
rm -f "$(pid_file deerflow)"

if command -v docker >/dev/null 2>&1; then
  if docker compose -f "$ROOT/docker-compose.yml" ps prompt-optimizer 2>/dev/null | grep -q Up; then
    log "停止 Prompt Optimizer Docker ..."
    docker compose -f "$ROOT/docker-compose.yml" stop prompt-optimizer >/dev/null 2>&1 || true
  fi
fi

rm -f "$STATE_FILE"
log "已全部停止"
