#!/usr/bin/env bash
# 在 iOS 模拟器上构建并运行本 Flutter 应用（支持热重载 attach）。
#
# 用法:
#   bash source/src/scripts/run_ios_simulator.sh
#   bash source/src/scripts/run_ios_simulator.sh -d "iPhone 17"
#
# 环境变量:
#   SIMULATOR_BOOT_WAIT  打开 Simulator 后等待秒数（默认 5）
#
# 说明:
# - iOS 26 模拟器安装含 Share Extension 的 .app 可能失败，脚本会去掉 PlugIns 再安装。
# - 请勿用 `sh` 运行；需 bash。
set -euo pipefail

if [[ -z "${BASH_VERSION:-}" ]]; then
  echo "请使用 bash 运行: bash $0 $*" >&2
  exit 1
fi

_script_path="${BASH_SOURCE[0]}"
case "$_script_path" in
  /*) ;;
  *) _script_path="$PWD/$_script_path" ;;
esac
SCRIPT_DIR="$(cd "$(dirname "$_script_path")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
IOS_DIR="$ROOT/ios"
BUNDLE_ID="com.nightelf.LuckyDatePro"

cd "$ROOT"

unset BUNDLE_GEMFILE || true
unset RUBYOPT || true

_strip_home_local_bin_from_path() {
  local out=""
  local d
  local _saved_ifs="$IFS"
  IFS=':'
  set +u
  for d in ${PATH}; do
    [[ -z "$d" ]] && continue
    [[ "$d" == "${HOME}/.local/bin" ]] && continue
    out="${out:+$out:}$d"
  done
  set -u
  IFS="$_saved_ifs"
  printf '%s' "$out"
}

if [[ -x "/opt/homebrew/bin/pod" ]] || [[ -x "/usr/local/bin/pod" ]]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:$(_strip_home_local_bin_from_path)"
elif [[ -x "${HOME}/.local/bin/pod" ]]; then
  _shim_dir="$(mktemp -d)"
  cat > "$_shim_dir/pod" << 'SHIM'
#!/bin/bash
export LANG=en_US.UTF-8
export GEM_HOME=~/.gem/ruby
export GEM_PATH=~/.gem/ruby
ORIGINAL_PWD="$PWD"
ARGS=("$@")
if [[ "${ARGS[0]}" == "install" ]]; then
    has_proj=false
    for arg in "${ARGS[@]}"; do [[ "$arg" == --project-directory* ]] && has_proj=true; done
    if [[ "$has_proj" == false ]]; then
        ARGS=("install" "--project-directory=$ORIGINAL_PWD" "${ARGS[@]:1}")
    fi
fi
cd ~/cocoapods
~/.gem/ruby/bin/bundle exec bin/pod "${ARGS[@]}"
SHIM
  chmod +x "$_shim_dir/pod"
  export PATH="$_shim_dir:/opt/homebrew/bin:/usr/local/bin:$(_strip_home_local_bin_from_path)"
  echo ">> 使用 ~/.local/bin/pod wrapper（已加 shim）"
else
  echo "!! 未找到 pod。请安装 CocoaPods，例如: brew install cocoapods" >&2
  exit 1
fi

_pick_ios_simulator_id() {
  python3 - <<'PY'
import json, subprocess, sys
raw = subprocess.check_output(["flutter", "devices", "--machine"], text=True)
devices = json.loads(raw)
ios_sims = [d for d in devices if d.get("emulator") and d.get("targetPlatform") == "ios"]
if not ios_sims:
    sys.exit(1)
print(ios_sims[0]["id"])
PY
}

WAIT="${SIMULATOR_BOOT_WAIT:-5}"

echo ">> ROOT=$ROOT"
echo ">> pod=$(command -v pod)"

echo ">> open Simulator.app"
open -a Simulator

echo ">> wait ${WAIT}s for simulator to register"
sleep "$WAIT"

# shellcheck source=load_supabase_env.sh
source "$SCRIPT_DIR/load_supabase_env.sh"

echo ">> flutter pub get"
flutter pub get

if [[ ! -f "$IOS_DIR/Podfile" ]]; then
  echo "!! 未找到 Podfile: $IOS_DIR/Podfile" >&2
  exit 1
fi

_has_device=false
_sim_id=""
_run_args=()
_i=1
while [[ $_i -le $# ]]; do
  _arg="${!_i}"
  case "$_arg" in
    -d|--device-id)
      _has_device=true
      _i=$((_i + 1))
      _sim_id="${!_i:-}"
      _i=$((_i + 1))
      ;;
    --device-id=*)
      _has_device=true
      _sim_id="${_arg#--device-id=}"
      _i=$((_i + 1))
      ;;
    *)
      _run_args+=("$_arg")
      _i=$((_i + 1))
      ;;
  esac
done

if [[ "$_has_device" == false ]]; then
  _sim_id="$(_pick_ios_simulator_id)" || {
    echo "!! 未找到 iOS 模拟器，请先在 Simulator.app 中创建/启动设备。" >&2
    exit 1
  }
fi

if [[ -z "$_sim_id" ]]; then
  echo "!! 未指定有效的模拟器 device id。" >&2
  exit 1
fi

if ((${#SUPABASE_DART_DEFINES[@]} > 0)); then
  echo ">> Supabase: ${SUPABASE_URL:-from dart_defines.local.json}"
else
  echo ">> 未加载 Supabase（无 scripts/.env.local）；账号同步不可用。"
fi

_install_simulator_app_without_extension() {
  local device_id="$1"
  local app="$ROOT/build/ios/iphonesimulator/Runner.app"
  local stage
  stage="$(mktemp -d)"
  trap 'rm -rf "$stage"' RETURN
  ditto "$app" "$stage/Runner.app"
  # iOS 26 模拟器安装 Share Extension 会触发 IXErrorDomain/Invalid placeholder attributes
  rm -rf "$stage/Runner.app/PlugIns"
  echo ">> simctl install (without Share Extension) → $device_id"
  xcrun simctl install "$device_id" "$stage/Runner.app"
  echo ">> simctl launch $BUNDLE_ID"
  xcrun simctl launch "$device_id" "$BUNDLE_ID"
}

echo ">> flutter build ios --simulator --debug ${SUPABASE_DART_DEFINES[*]:-} ${_run_args[*]:-}"
flutter build ios --simulator --debug "${SUPABASE_DART_DEFINES[@]}" ${_run_args[@]+"${_run_args[@]}"}

_install_simulator_app_without_extension "$_sim_id"

echo ">> flutter attach -d $_sim_id"
exec flutter attach -d "$_sim_id" "${SUPABASE_DART_DEFINES[@]}"
