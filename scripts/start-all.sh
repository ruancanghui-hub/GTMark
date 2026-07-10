#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
GTMARK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"

load_env

PROMPT_MODE=""
PROMPT_URL=""
DEERFLOW_STARTED=0

start_prompt_optimizer_docker() {
  command -v docker >/dev/null 2>&1 || return 1
  log "启动 Prompt Optimizer (Docker :8081) ..."
  docker compose -f "$ROOT/docker-compose.yml" --env-file "$ENV_FILE" up -d prompt-optimizer
  PROMPT_MODE=docker
  PROMPT_URL="http://localhost:8081/mcp"
  wait_url "http://localhost:8081/" "Prompt Optimizer" 120 || true
}

start_prompt_optimizer_local() {
  local po="$ROOT/integrations/prompt-optimizer"
  local mcp="$po/packages/mcp-server"
  [[ -d "$po" ]] || { warn "未找到 integrations/prompt-optimizer"; return 1; }

  if is_running prompt-optimizer; then
    log "Prompt Optimizer 已在运行"
    PROMPT_MODE=local
    PROMPT_URL="$(read_state PROMPT_OPTIMIZER_MCP_URL http://localhost:3000/mcp)"
    return 0
  fi

  sync_prompt_optimizer_env
  local pnpm
  pnpm="$(pnpm_cmd)"
  local port="${MCP_HTTP_PORT:-3001}"

  log "安装 Prompt Optimizer 依赖（首次较慢）..."
  export PNPM_CONFIG_ENGINE_STRICT=false
  (cd "$po" && $pnpm install --config.engine-strict=false)

  log "构建 Prompt Optimizer MCP ..."
  (cd "$po" && $pnpm --config.engine-strict=false -r --filter @prompt-optimizer/core --filter @prompt-optimizer/mcp-server run build)

  log "启动 Prompt Optimizer 本地 MCP (:$port) ..."
  (
    cd "$mcp"
    nohup env \
      MCP_HTTP_PORT="$port" \
      MCP_DEFAULT_MODEL_PROVIDER="${MCP_DEFAULT_MODEL_PROVIDER:-deepseek}" \
      VITE_DEEPSEEK_API_KEY="${VITE_DEEPSEEK_API_KEY:-}" \
      node -r ./preload-env.js dist/start.js --transport=http \
      >>"$LOG_DIR/prompt-optimizer.log" 2>&1 \
      < /dev/null &
    echo $! >"$(pid_file prompt-optimizer)"
  )

  PROMPT_MODE=local
  PROMPT_URL="http://localhost:${port}/mcp"
  wait_url "$PROMPT_URL" "Prompt Optimizer MCP" 60 || true
}

start_prompt_optimizer() {
  if start_prompt_optimizer_docker; then
    :
  else
    warn "Docker 不可用，改用本地 pnpm 启动 Prompt Optimizer"
    start_prompt_optimizer_local || warn "Prompt Optimizer 启动失败，见 $LOG_DIR/prompt-optimizer.log"
  fi

  if [[ -n "$PROMPT_URL" ]]; then
    patch_prompt_optimizer_mcp_url "$PROMPT_URL"
  fi
}

start_deerflow() {
  local df="$ROOT/integrations/deer-flow"
  [[ -d "$df" ]] || { warn "未找到 DeerFlow"; return 1; }

  if is_running deerflow; then
    log "DeerFlow 已在运行"
    DEERFLOW_STARTED=1
    return 0
  fi

  ensure_deerflow_config || true
  [[ -f "$df/config.yaml" ]] || { warn "DeerFlow 无 config.yaml，跳过"; return 1; }

  if [[ -n "${DEEPSEEK_API_KEY:-}" ]]; then
    touch "$df/.env"
    if ! grep -q '^DEEPSEEK_API_KEY=' "$df/.env" 2>/dev/null; then
      echo "DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY" >>"$df/.env"
    fi
  fi

  cd "$df"
  export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
  install_uv_if_missing || true
  ensure_pnpm || true

  if ! command -v nginx >/dev/null 2>&1; then
    log "未找到 nginx，尝试本地安装 ..."
    bash "$ROOT/scripts/install-nginx.sh" || warn "nginx 安装失败"
  fi

  if ! python3 ./scripts/check.py >/tmp/deerflow-check.log 2>&1; then
    warn "DeerFlow 依赖未满足，跳过（详见 /tmp/deerflow-check.log）"
    if ! command -v nginx >/dev/null 2>&1; then
      warn "缺少 nginx：macOS 可执行 brew install nginx，或安装 Docker 后用 make docker-start"
    fi
    if ! command -v uv >/dev/null 2>&1; then
      warn "缺少 uv：脚本已尝试自动安装，请重开终端后再运行 start.sh"
    fi
    return 1
  fi

  log "安装 DeerFlow 依赖（首次较慢）..."
  make install >>"$LOG_DIR/deerflow-install.log" 2>&1 || {
    warn "DeerFlow make install 失败，见 $LOG_DIR/deerflow-install.log"
    return 1
  }

  log "启动 DeerFlow (dev daemon :8001) ..."
  make dev-daemon >>"$LOG_DIR/deerflow.log" 2>&1 || {
    warn "DeerFlow 启动失败，见 $LOG_DIR/deerflow.log"
    return 1
  }

  DEERFLOW_STARTED=1
  wait_url "http://localhost:8001/health" "DeerFlow Gateway" 180 || true
}

print_summary() {
  echo ""
  echo "=============================================="
  echo "  GTMark 代理框架已启动"
  echo "=============================================="
  echo ""
  echo "  始终可用（无需启动）"
  echo "    • ECC hooks/rules/skills  → 已在 .cursor/"
  echo "    • Ruflo MCP               → Cursor Reload 后按需连接"
  echo ""
  if [[ -n "$PROMPT_URL" ]]; then
    echo "  Prompt Optimizer ($PROMPT_MODE)"
    echo "    • MCP: $PROMPT_URL"
    echo "    • 日志: $LOG_DIR/prompt-optimizer.log"
  else
    echo "  Prompt Optimizer: 未启动"
  fi
  echo ""
  if [[ "$DEERFLOW_STARTED" == 1 ]]; then
    echo "  DeerFlow"
    echo "    • Web UI:  http://localhost:2026"
    echo "    • Gateway: http://localhost:8001"
    echo "    • 日志: $LOG_DIR/deerflow.log"
  else
    echo "  DeerFlow: 未启动（依赖或配置问题）"
  fi
  echo ""
  if [[ -z "${LETTA_API_KEY:-}" ]]; then
    echo "  Letta: 跳过（.env 未配置 LETTA_API_KEY）"
  else
    echo "  Letta MCP: 已配置 Key，Cursor Reload 后可用"
  fi
  echo ""
  echo "  下一步（重要）"
  echo "    1. Cursor → Settings → MCP → Reload"
  echo "    2. 在对话中说："
  echo '       「用 agent-frameworks 串联：优化 prompt → deer-flow 调研 → ruflo 存结论」'
  echo ""
  echo "  停止全部: bash stop.sh  或  bash scripts/stop-all.sh"
  echo "  健康检查: bash scripts/health-check.sh"
  echo "  一键启动: bash start.sh"
  echo "=============================================="
  echo ""
}

main() {
  log "=== 启动 GTMark 代理框架 ==="
  mkdir -p "$RUN_DIR" "$LOG_DIR" "$PID_DIR"

  if [[ ! -d "$ROOT/integrations/prompt-optimizer" ]]; then
    log "首次运行，克隆框架仓库 ..."
    bash "$ROOT/scripts/setup-frameworks.sh" || warn "setup-frameworks 部分失败，继续启动可用服务"
  fi

  start_prompt_optimizer
  start_deerflow || true

  save_state \
    "PROMPT_OPTIMIZER_MODE=${PROMPT_MODE}" \
    "PROMPT_OPTIMIZER_MCP_URL=${PROMPT_URL}" \
    "DEERFLOW_STARTED=${DEERFLOW_STARTED}" \
    "STARTED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  print_summary
}

main "$@"
