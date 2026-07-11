#!/usr/bin/env bash
# 本地开发快速启动（iOS 模拟器优先）。
#
# 用法:
#   bash source/src/scripts/run_dev.sh
#   bash source/src/scripts/run_dev.sh -d chrome
#   bash source/src/scripts/run_dev.sh -d "iPhone 17"
#
set -euo pipefail

_script_path="${BASH_SOURCE[0]}"
case "$_script_path" in
  /*) ;;
  *) _script_path="$PWD/$_script_path" ;;
esac
SCRIPT_DIR="$(cd "$(dirname "$_script_path")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT"

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

_has_device=false
device_id=""
run_args=()
i=1
while [[ $i -le $# ]]; do
  arg="${!i}"
  case "$arg" in
    -d|--device-id)
      _has_device=true
      i=$((i + 1))
      device_id="${!i:-}"
      i=$((i + 1))
      ;;
    --device-id=*)
      _has_device=true
      device_id="${arg#--device-id=}"
      i=$((i + 1))
      ;;
    *)
      run_args+=("$arg")
      i=$((i + 1))
      ;;
  esac
done

if [[ "$_has_device" == false ]]; then
  if open -Ra Simulator 2>/dev/null; then
    open -a Simulator
    sleep "${SIMULATOR_BOOT_WAIT:-3}"
  fi
  device_id="$(_pick_ios_simulator_id)" || {
    echo "!! 未找到 iOS 模拟器，请用 -d 指定设备，例如: $0 -d chrome" >&2
    exit 1
  }
fi

echo ">> ROOT=$ROOT"
echo ">> flutter run -d $device_id ${run_args[*]:-}"
if ((${#run_args[@]} > 0)); then
  exec flutter run -d "$device_id" "${run_args[@]}"
else
  exec flutter run -d "$device_id"
fi
