#!/usr/bin/env bash
# 加载 scripts/.env.local 并生成 flutter --dart-define 参数。
# 用法: source "$(dirname "$0")/load_supabase_env.sh"
set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_ROOT="$(cd "$_SCRIPT_DIR/.." && pwd)"
_ENV_FILE="$_SCRIPT_DIR/.env.local"
_DART_DEFINES_FILE="$_ROOT/config/dart_defines.local.json"

if [[ -f "$_ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$_ENV_FILE"
  # 保持 dart-define JSON 与 .env.local 同步
  if [[ -x "$_SCRIPT_DIR/sync_dart_defines.sh" ]]; then
    bash "$_SCRIPT_DIR/sync_dart_defines.sh" >/dev/null 2>&1 || true
  fi
fi

# 兼容 macOS 自带 Bash 3.2（无 mapfile）
SUPABASE_DART_DEFINES=()
if [[ -f "$_DART_DEFINES_FILE" ]]; then
  SUPABASE_DART_DEFINES=("--dart-define-from-file=$_DART_DEFINES_FILE")
elif [[ -n "${SUPABASE_URL:-}" && -n "${SUPABASE_ANON_KEY:-}" ]]; then
  SUPABASE_DART_DEFINES=(
    "--dart-define=SUPABASE_URL=${SUPABASE_URL}"
    "--dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}"
  )
fi

if [[ -n "${ADMOB_APP_ID:-}" ]]; then
  SUPABASE_DART_DEFINES+=("--dart-define=ADMOB_APP_ID=${ADMOB_APP_ID}")
fi
if [[ -n "${ADMOB_APP_OPEN_UNIT_ID:-}" ]]; then
  SUPABASE_DART_DEFINES+=(
    "--dart-define=ADMOB_APP_OPEN_UNIT_ID=${ADMOB_APP_OPEN_UNIT_ID}"
  )
fi
if [[ -n "${ADMOB_REWARDED_UNIT_ID:-}" ]]; then
  SUPABASE_DART_DEFINES+=(
    "--dart-define=ADMOB_REWARDED_UNIT_ID=${ADMOB_REWARDED_UNIT_ID}"
  )
fi
