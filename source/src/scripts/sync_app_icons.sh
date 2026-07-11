#!/usr/bin/env bash
# 从设计稿同步 App Icon 到 iOS / Android 工程。
#
# 源目录：仓库根/设计文档/设计稿/appicons/
# 用法（在 source/src 下）:
#   ./scripts/sync_app_icons.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
DESIGN="$REPO_ROOT/设计文档/设计稿/appicons"

IOS_SRC="$DESIGN/ios/AppIcon.appiconset"
IOS_DEST="$ROOT/ios/Runner/Assets.xcassets/AppIcon.appiconset"
ANDROID_SRC="$DESIGN/android"
ANDROID_DEST="$ROOT/android/app/src/main/res"

if [[ ! -d "$IOS_SRC" ]]; then
  echo "缺少 iOS 图标: $IOS_SRC" >&2
  exit 1
fi
if [[ ! -d "$ANDROID_SRC" ]]; then
  echo "缺少 Android 图标: $ANDROID_SRC" >&2
  exit 1
fi

echo ">> iOS: $IOS_SRC -> $IOS_DEST"
mkdir -p "$IOS_DEST"
cp -f "$IOS_SRC/Contents.json" "$IOS_DEST/Contents.json"
for f in "$IOS_SRC"/icon-*.png; do
  [[ -f "$f" ]] || continue
  cp -f "$f" "$IOS_DEST/$(basename "$f")"
done

echo ">> Android: $ANDROID_SRC/mipmap-* -> $ANDROID_DEST"
for d in "$ANDROID_SRC"/mipmap-*; do
  [[ -d "$d" ]] || continue
  name="$(basename "$d")"
  mkdir -p "$ANDROID_DEST/$name"
  cp -f "$d/ic_launcher.png" "$ANDROID_DEST/$name/ic_launcher.png"
  echo "   $name/ic_launcher.png"
done

# 可选：同步到 assets 镜像（部分工具链引用）
ASSETS_IOS="$ROOT/assets/images/icons/ios/AppIcon.appiconset"
if [[ -d "$(dirname "$ASSETS_IOS")" ]]; then
  mkdir -p "$ASSETS_IOS"
  cp -f "$IOS_DEST/Contents.json" "$ASSETS_IOS/"
  cp -f "$IOS_DEST"/icon-*.png "$ASSETS_IOS/" 2>/dev/null || true
fi

echo ">> 完成。请重新安装 App 才能在真机/模拟器上看到新图标。"
