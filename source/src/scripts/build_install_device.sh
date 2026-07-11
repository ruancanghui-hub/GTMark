#!/usr/bin/env bash
# 在项目根目录执行：构建 release 并安装到当前连接的真机。
#
# iOS（默认，需本机已配置 Xcode 签名、设备已信任并连接）:
#   ./scripts/build_install_device.sh
#   ./scripts/build_install_device.sh -d <device_id>   # 多设备时指定
#   # 与 App Store 无关的「性能分析」包：
#   IOS_FLAVOR=profile ./scripts/build_install_device.sh -d <device_id>
#
# Android:
#   TARGET=android ./scripts/build_install_device.sh
#   TARGET=android ./scripts/build_install_device.sh -d <device_id>
#
# 若 VS Code / flutter run 报「Could not run Runner.app」但构建成功：多为 LLDB 附加失败（旧机型常见）。
# 请用本脚本「仅安装」后在手机上手动点开应用，或用 Xcode Product > Run。
#
# 查看设备: flutter devices
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=load_supabase_env.sh
source "$ROOT/scripts/load_supabase_env.sh"

TARGET="${TARGET:-ios}"

echo ">> flutter pub get"
flutter pub get

if [[ "$TARGET" == "ios" ]]; then
  IOS_FLAVOR="${IOS_FLAVOR:-release}"
  if [[ "$IOS_FLAVOR" != "release" && "$IOS_FLAVOR" != "profile" ]]; then
    echo "IOS_FLAVOR 只能是 release 或 profile，当前: $IOS_FLAVOR" >&2
    exit 1
  fi
  if ((${#SUPABASE_DART_DEFINES[@]} > 0)); then
    echo ">> Supabase: ${SUPABASE_URL}"
  fi
  echo ">> flutter build ios --$IOS_FLAVOR"
  flutter build ios --"$IOS_FLAVOR" "${SUPABASE_DART_DEFINES[@]}"
else
  if ((${#SUPABASE_DART_DEFINES[@]} > 0)); then
    echo ">> Supabase: ${SUPABASE_URL}"
  fi
  echo ">> flutter build apk --release"
  flutter build apk --release "${SUPABASE_DART_DEFINES[@]}"
fi

echo ">> flutter install（请连接真机；Android 需开启 USB 调试与授权）"
if [[ "$TARGET" == "ios" ]]; then
  flutter install --"$IOS_FLAVOR" "$@"
else
  flutter install "$@"
fi

echo ">> 完成。"
if [[ "$TARGET" == "ios" ]]; then
  echo ">> iOS：若未自动打开应用，请到主屏幕手动启动。"
fi
