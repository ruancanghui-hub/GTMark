#!/usr/bin/env bash
# 从吉辰品牌 IP 生成原生启动页资源（米白底 + 梅花鹿）。
#
# 输入: assets/images/brand/ip_deer.png
# 输出:
#   android/.../drawable-nodpi/splash_logo.png
#   ios/Runner/Assets.xcassets/SplashDeer.imageset/*.png
#
# 用法（在 source/src 下）:
#   ./scripts/sync_brand_assets.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEER_SRC="$ROOT/assets/images/brand/ip_deer.png"
ANDROID_OUT="$ROOT/android/app/src/main/res/drawable-nodpi/splash_logo.png"
IOS_SET="$ROOT/ios/Runner/Assets.xcassets/SplashDeer.imageset"

if [[ ! -f "$DEER_SRC" ]]; then
  echo "!! 缺少品牌图: $DEER_SRC" >&2
  exit 1
fi

python3 - "$DEER_SRC" "$ANDROID_OUT" "$IOS_SET" <<'PY'
import sys
from pathlib import Path

from PIL import Image

deer_src, android_out, ios_set = map(Path, sys.argv[1:4])
ios_set.mkdir(parents=True, exist_ok=True)
android_out.parent.mkdir(parents=True, exist_ok=True)

deer = Image.open(deer_src).convert("RGBA")

def resize_width(img: Image.Image, width: int) -> Image.Image:
    ratio = width / img.width
    height = max(1, round(img.height * ratio))
    return img.resize((width, height), Image.Resampling.LANCZOS)

# Android 启动 logo（居中，layer-list 叠加米白底）
resize_width(deer, 480).save(android_out, optimize=True)

# iOS SplashDeer @1x/@2x/@3x
sizes = {
    "splash_deer.png": 200,
    "splash_deer@2x.png": 400,
    "splash_deer@3x.png": 600,
}
for name, width in sizes.items():
    resize_width(deer, width).save(ios_set / name, optimize=True)

contents = """{
  "images" : [
    {
      "filename" : "splash_deer.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "splash_deer@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "splash_deer@3x.png",
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
(ios_set / "Contents.json").write_text(contents, encoding="utf-8")
print(f">> Android splash_logo: {android_out}")
print(f">> iOS SplashDeer.imageset: {ios_set}")
PY

echo ">> 完成。请同步更新 launch_background.xml / LaunchScreen.storyboard 后重装 App。"
