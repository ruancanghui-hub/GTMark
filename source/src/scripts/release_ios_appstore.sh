#!/usr/bin/env bash
# App Store：Flutter IPA + fastlane deliver 上传二进制。
# 前置：仓库根目录 pubspec.yaml 已设好 version（如 2.0.2+4）；
#      ios/fastlane/.env 已按 .env.example 配置 ASC Key（不要将 .env 提交 git）。
#
# 用法（在仓库任意目录）:
#   bash scripts/release_ios_appstore.sh
#
set -euo pipefail

if [[ -z "${BASH_VERSION:-}" ]]; then
  echo "请使用 bash 运行" >&2
  exit 1
fi

_script_path="${BASH_SOURCE[0]}"
case "$_script_path" in
  /*) ;;
  *) _script_path="$PWD/$_script_path" ;;
esac
SCRIPT_DIR="$(cd "$(dirname "$_script_path")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT/ios"
echo ">> version (pubspec): $(grep '^version:' "$ROOT/pubspec.yaml" | head -1)"
echo ">> fastlane ios release"
exec fastlane ios release
