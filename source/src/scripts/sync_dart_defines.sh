#!/usr/bin/env bash
# 从 scripts/.env.local 生成 config/dart_defines.local.json（供 Cursor / flutter run 使用）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$SCRIPT_DIR/.env.local"
OUT="$ROOT/config/dart_defines.local.json"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "缺少 $ENV_FILE，请复制 .env.example 为 .env.local 并填写 Supabase 凭据。" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

if [[ -z "${SUPABASE_URL:-}" || -z "${SUPABASE_ANON_KEY:-}" ]]; then
  echo "SUPABASE_URL 与 SUPABASE_ANON_KEY 不能为空。" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")"
cat > "$OUT" <<EOF
{
  "SUPABASE_URL": "${SUPABASE_URL}",
  "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}"
}
EOF

echo "已生成 $OUT"
