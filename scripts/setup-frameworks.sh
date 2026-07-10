#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INTEGRATIONS="$ROOT/integrations"
ENV_FILE="$ROOT/.env"

log() { printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

clone_repo() {
  local name="$1" url="$2"
  local dest="$INTEGRATIONS/$name"
  if [[ -d "$dest/.git" ]]; then
    log "更新 $name ..."
    git -C "$dest" pull --ff-only
  else
    log "克隆 $name ..."
    git clone --depth 1 "$url" "$dest"
  fi
}

mkdir -p "$INTEGRATIONS"
[[ -f "$ENV_FILE" ]] || cp "$ROOT/.env.example" "$ENV_FILE"

log "=== 1/5 克隆仓库 ==="
clone_repo deer-flow "https://github.com/bytedance/deer-flow.git"
clone_repo ecc "https://github.com/affaan-m/ECC.git"
clone_repo prompt-optimizer "https://github.com/linshenkx/prompt-optimizer.git"
clone_repo ruflo "https://github.com/ruvnet/ruflo.git"
clone_repo letta "https://github.com/letta-ai/letta.git"

log "=== 2/5 安装 ECC 到 Cursor ==="
if [[ -x "$INTEGRATIONS/ecc/install.sh" ]]; then
  (cd "$ROOT" && bash "$INTEGRATIONS/ecc/install.sh" --target cursor --profile minimal) || {
    log "ECC profile 安装失败，尝试语言包安装 ..."
    (cd "$ROOT" && bash "$INTEGRATIONS/ecc/install.sh" --target cursor typescript python)
  }
else
  log "跳过 ECC：未找到 install.sh"
fi

log "=== 3/5 安装 CLI 工具 ==="
command -v letta >/dev/null 2>&1 || npm install -g @letta-ai/letta-code@latest
command -v deerflow >/dev/null 2>&1 || {
  if command -v uv >/dev/null 2>&1; then
    uv tool install deerflow 2>/dev/null || true
  fi
}

log "=== 4/5 启动 Prompt Optimizer (Docker) ==="
if command -v docker >/dev/null 2>&1; then
  docker compose -f "$ROOT/docker-compose.yml" --env-file "$ENV_FILE" up -d prompt-optimizer || true
else
  log "未检测到 Docker，跳过 Prompt Optimizer 容器。可手动运行: docker compose up -d"
fi

log "=== 5/5 DeerFlow 本地配置（可选）==="
DEERFLOW_DIR="$INTEGRATIONS/deer-flow"
if [[ -d "$DEERFLOW_DIR" && ! -f "$DEERFLOW_DIR/config.yaml" ]]; then
  log "DeerFlow 首次使用请运行: cd integrations/deer-flow && make setup"
fi

log "完成。请在 Cursor 中重载 MCP，并编辑 $ENV_FILE 填入 API Key。"
log "调用方式: 在对话中说「用 deer-flow / prompt-optimizer / ecc / ruflo / letta」或加载 agent-frameworks skill。"
