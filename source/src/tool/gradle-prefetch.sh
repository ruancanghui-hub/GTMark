#!/usr/bin/env bash
# 预下载 Gradle Wrapper 发行包，避免 flutter run 时 120s 锁超时
# 用法：source/src/tool/gradle-prefetch.sh

set -euo pipefail

GRADLE_VERSION="8.14"
DIST_NAME="gradle-${GRADLE_VERSION}-all"
HASH_DIR="c2qonpi39x1mddn7hk5gh9iqj"
DIST_ROOT="${GRADLE_USER_HOME:-$HOME/.gradle}/wrapper/dists/${DIST_NAME}/${HASH_DIR}"
ZIP_PATH="${DIST_ROOT}/${DIST_NAME}.zip"

MIRRORS=(
  "https://mirrors.cloud.tencent.com/gradle/${DIST_NAME}.zip"
  "https://services.gradle.org/distributions/${DIST_NAME}.zip"
)

echo "==> 停止可能占用锁的 Gradle 进程..."
pkill -f 'GradleWrapperMain' 2>/dev/null || true
pkill -f 'org.gradle.launcher.daemon' 2>/dev/null || true
sleep 2

if [[ -x "${DIST_ROOT}/${DIST_NAME}/bin/gradle" ]]; then
  echo "==> Gradle ${GRADLE_VERSION} 已解压，跳过下载"
  exit 0
fi

if [[ -f "${ZIP_PATH}" ]]; then
  size=$(stat -f%z "${ZIP_PATH}" 2>/dev/null || stat -c%s "${ZIP_PATH}")
  # 完整包约 220MB+
  if [[ "${size}" -gt 200000000 ]]; then
    echo "==> 已存在完整 zip (${size} bytes)，跳过下载"
  else
    echo "==> 删除不完整的 zip (${size} bytes)"
    rm -f "${ZIP_PATH}" "${ZIP_PATH}.part" "${ZIP_PATH}.lck" "${ZIP_PATH}.ok"
  fi
fi

if [[ ! -f "${ZIP_PATH}" ]] || [[ "$(stat -f%z "${ZIP_PATH}" 2>/dev/null || stat -c%s "${ZIP_PATH}")" -lt 200000000 ]]; then
  rm -rf "${DIST_ROOT}"
  mkdir -p "${DIST_ROOT}"

  downloaded=0
  for url in "${MIRRORS[@]}"; do
    echo "==> 下载 ${url}"
    if curl -fL --connect-timeout 20 --retry 3 --retry-delay 5 \
      -o "${ZIP_PATH}.part" "${url}"; then
      mv "${ZIP_PATH}.part" "${ZIP_PATH}"
      downloaded=1
      break
    fi
    echo "    失败，尝试下一个镜像..."
    rm -f "${ZIP_PATH}.part"
  done

  if [[ "${downloaded}" -ne 1 ]]; then
    echo "错误：Gradle 下载失败，请检查网络或代理" >&2
    exit 1
  fi
fi

echo "==> 解压并验证 Gradle..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_DIR="${SCRIPT_DIR}/../android"
source "${SCRIPT_DIR}/android-dev-env.sh" 2>/dev/null || true
(cd "${ANDROID_DIR}" && ./gradlew --version)

NDK_VERSION="27.0.12077973"
if [[ ! -d "${ANDROID_HOME:-$HOME/Library/Android/sdk}/ndk/${NDK_VERSION}" ]]; then
  echo "==> 安装 Android NDK ${NDK_VERSION}..."
  source "${SCRIPT_DIR}/android-dev-env.sh" 2>/dev/null || true
  yes | sdkmanager "ndk;${NDK_VERSION}" >/dev/null
fi

echo "==> Gradle ${GRADLE_VERSION} + NDK 就绪。可执行："
echo "    ./run_android.sh   或   cd source/src && flutter run -d <device_id>"
