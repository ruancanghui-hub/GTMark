#!/usr/bin/env bash
# 在项目根目录用 Chrome 运行本 Flutter 应用（Web）。
#
# 用法:
#   ./scripts/run_chrome.sh
#   ./scripts/run_chrome.sh --release          # 发布模式（更慢编译，更接近生产）
#   ./scripts/run_chrome.sh --web-port=8080  # 传给 flutter run 的其它参数
#
# 需已安装 Flutter 并启用 Web：flutter config --enable-web
# 查看设备: flutter devices
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=load_supabase_env.sh
source "$ROOT/scripts/load_supabase_env.sh"

echo ">> flutter pub get"
flutter pub get

if ((${#SUPABASE_DART_DEFINES[@]} > 0)); then
  echo ">> Supabase: ${SUPABASE_URL}"
fi

echo ">> flutter run -d chrome ${SUPABASE_DART_DEFINES[*]} $*"
exec flutter run -d chrome "${SUPABASE_DART_DEFINES[@]}" "$@"
