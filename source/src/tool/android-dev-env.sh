#!/usr/bin/env bash
# Android 真机联调环境（adb + SDK + JDK）
# 用法：source source/src/tool/android-dev-env.sh
# 或加入 ~/.zshrc：source /path/to/linkee/source/src/tool/android-dev-env.sh

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export JAVA_HOME="${JAVA_HOME:-$HOME/.local/jdk-17/Contents/Home}"

export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

if command -v flutter >/dev/null 2>&1; then
  flutter config --android-sdk "$ANDROID_HOME" >/dev/null 2>&1 || true
fi

echo "ANDROID_HOME=$ANDROID_HOME"
echo "JAVA_HOME=$JAVA_HOME"
command -v adb >/dev/null && adb version | head -1 || echo "adb 未找到"
echo "提示: 首次 Android 构建前可运行: source/src/tool/gradle-prefetch.sh"
