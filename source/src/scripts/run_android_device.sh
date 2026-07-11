#!/usr/bin/env bash
# 在 Android 真机上运行（debug + 热重载，自动注入 Supabase）。
#
# 前置：
#   - 手机开启「开发者选项 → USB 调试」，连接后点「允许」
#   - adb devices 能看到 device（非 unauthorized）
#
# 用法（在 source/src 下）:
#   ./scripts/run_android_device.sh
#   ./scripts/run_android_device.sh -d <device_id>
#   ./scripts/run_android_device.sh --release          # 发布模式
#   flutter devices                                    # 列出设备 ID
#
# 首次或换图标后建议:
#   ./scripts/sync_app_icons.sh && ./scripts/run_android_device.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=load_supabase_env.sh
source "$ROOT/scripts/load_supabase_env.sh"

pick_android_device() {
  flutter devices 2>/dev/null | while IFS= read -r line; do
    [[ "$line" == *"android"* ]] || continue
    [[ "$line" == *"emulator"* ]] && continue
    # 格式: Name • device_id • android-…
    echo "$line" | awk -F'•' '{gsub(/^ +| +$/, "", $2); print $2; exit}'
  done
}

DEVICE=""
EXTRA=()
RELEASE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d)
      DEVICE="${2:-}"
      shift 2
      ;;
    --release)
      RELEASE=1
      shift
      ;;
    *)
      EXTRA+=("$1")
      shift
      ;;
  esac
done

if [[ -z "$DEVICE" ]]; then
  DEVICE="$(pick_android_device || true)"
fi

if [[ -z "$DEVICE" ]]; then
  echo "未找到 Android 真机。请检查 USB 调试并运行: flutter devices" >&2
  exit 1
fi

echo ">> flutter pub get"
flutter pub get

if ((${#SUPABASE_DART_DEFINES[@]} > 0)); then
  echo ">> Supabase: ${SUPABASE_URL}"
else
  echo ">> 未加载 Supabase（无 scripts/.env.local）；账号同步不可用。"
fi

echo ">> 目标设备: $DEVICE"
RUN_ARGS=(run -d "$DEVICE" "${SUPABASE_DART_DEFINES[@]}")
if [[ "$RELEASE" -eq 1 ]]; then
  RUN_ARGS+=(--release)
fi
if ((${#EXTRA[@]} > 0)); then
  RUN_ARGS+=("${EXTRA[@]}")
fi

echo ">> flutter ${RUN_ARGS[*]}"
exec flutter "${RUN_ARGS[@]}"
