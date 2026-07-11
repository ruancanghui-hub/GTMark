#!/usr/bin/env bash
# 远程库已有旧版 events 等表、但 migration 历史未记录时，先 repair 再 push 吉辰表。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=load_supabase_env.sh
source "$ROOT/scripts/load_supabase_env.sh"

ALREADY_ON_REMOTE=(
  20260404120000
  20260405120000
  20260406120000
  20260510120000
)

echo ">> 将下列迁移标记为「远程已应用」（events / iap 等旧表）"
for v in "${ALREADY_ON_REMOTE[@]}"; do
  echo "   - $v"
  supabase migration repair "$v" --status applied
done

echo ""
echo ">> 推送剩余迁移（含 jichen_user_data）"
if [[ -n "${SUPABASE_DB_PASSWORD:-}" ]]; then
  SUPABASE_DB_PASSWORD="$SUPABASE_DB_PASSWORD" supabase db push
else
  echo "   提示：若再遇连接失败，可设置数据库密码后重试："
  echo "   SUPABASE_DB_PASSWORD='你的DB密码' $0"
  supabase db push
fi
