#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

export LETTA_BASE_URL="${LETTA_BASE_URL:-https://api.letta.com}"

if [[ -z "${LETTA_API_KEY:-}" ]]; then
  echo "LETTA_API_KEY 未配置。请在 .env 中设置 Letta 平台 Key：" >&2
  echo "  1. 打开 https://app.letta.com/api-keys 申请" >&2
  echo "  2. 写入 $ENV_FILE → LETTA_API_KEY=..." >&2
  echo "  3. Cursor → MCP → Reload" >&2
  exit 1
fi

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
exec npx -y letta-mcp
