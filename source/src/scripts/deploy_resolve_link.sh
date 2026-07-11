#!/usr/bin/env bash
# 部署分享链接解析 Edge Function（无需 JWT，供 anon key 调用）
set -euo pipefail
cd "$(dirname "$0")/.."

export PATH="${HOME}/.local/share/supabase:${HOME}/.local/bin:${PATH}"

# shellcheck source=load_supabase_env.sh
source "$(dirname "$0")/load_supabase_env.sh"

if ! command -v supabase >/dev/null 2>&1; then
  echo "未找到 supabase。可执行:"
  echo "  mkdir -p \"\$HOME/.local/share/supabase\""
  echo "  curl -fsSL https://github.com/supabase/cli/releases/download/v2.106.0/supabase_2.106.0_darwin_arm64.tar.gz \\"
  echo "    | tar -xzf - -C \"\$HOME/.local/share/supabase\""
  echo "  export PATH=\"\$HOME/.local/share/supabase:\$PATH\""
  exit 1
fi

if ! supabase projects list >/dev/null 2>&1; then
  echo "请先登录 Supabase CLI:"
  echo "  supabase login"
  echo "或设置: export SUPABASE_ACCESS_TOKEN=..."
  exit 1
fi

if [[ -n "${SUPABASE_PROJECT_REF:-}" ]]; then
  echo "Linking project ${SUPABASE_PROJECT_REF}..."
  supabase link --project-ref "$SUPABASE_PROJECT_REF" --yes 2>/dev/null || true
fi

echo "Deploying resolve_link..."
supabase functions deploy resolve_link --no-verify-jwt

echo "Done. 运行 App 时 scripts/.env.local 会自动注入 dart-define。"
