#!/usr/bin/env bash
set -euo pipefail

NGINX_VERSION="${NGINX_VERSION:-1.26.3}"
PREFIX="${NGINX_PREFIX:-$HOME/.local/nginx}"
BIN_LINK="$HOME/.local/bin/nginx"
BUILD_DIR="${TMPDIR:-/tmp}/nginx-build-$$"

mkdir -p "$HOME/.local/bin" "$PREFIX/logs" "$PREFIX/run"
export PATH="$HOME/.local/bin:$PATH"

nginx_has_rewrite() {
  local bin="${1:-nginx}"
  "$bin" -V 2>&1 | grep -q -- '--with-http_rewrite_module\|http_rewrite_module' \
    && ! "$bin" -V 2>&1 | grep -q 'without-http_rewrite_module'
}

if command -v nginx >/dev/null 2>&1 && nginx_has_rewrite nginx; then
  echo "nginx 已安装: $(nginx -v 2>&1)"
  exit 0
fi

if [[ -x "$PREFIX/sbin/nginx" ]] && nginx_has_rewrite "$PREFIX/sbin/nginx"; then
  ln -sf "$PREFIX/sbin/nginx" "$BIN_LINK"
  echo "nginx 已存在: $($BIN_LINK -v 2>&1)"
  exit 0
fi

if command -v nginx >/dev/null 2>&1 || [[ -x "$PREFIX/sbin/nginx" ]]; then
  echo "检测到 nginx 缺少 rewrite 模块，将重新编译 ..."
  rm -rf "$PREFIX"
fi

echo "编译安装 nginx ${NGINX_VERSION} 到 ${PREFIX} ..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

PCRE_VERSION="${PCRE_VERSION:-8.45}"
if [[ ! -d "pcre-${PCRE_VERSION}" ]]; then
  echo "下载 PCRE ${PCRE_VERSION}（nginx rewrite 模块依赖）..."
  curl -fsSL "https://sourceforge.net/projects/pcre/files/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz/download" \
    -o "pcre-${PCRE_VERSION}.tar.gz"
  tar xzf "pcre-${PCRE_VERSION}.tar.gz"
fi

curl -fsSL "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz
tar xzf nginx.tar.gz
cd "nginx-${NGINX_VERSION}"

./configure \
  --prefix="$PREFIX" \
  --sbin-path="$PREFIX/sbin/nginx" \
  --conf-path="$PREFIX/conf/nginx.conf" \
  --pid-path="$PREFIX/run/nginx.pid" \
  --lock-path="$PREFIX/run/nginx.lock" \
  --error-log-path="$PREFIX/logs/error.log" \
  --http-log-path="$PREFIX/logs/access.log" \
  --with-stream \
  --with-pcre="../pcre-${PCRE_VERSION}"

make -j"$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"
make install

ln -sf "$PREFIX/sbin/nginx" "$BIN_LINK"
rm -rf "$BUILD_DIR"

echo "完成: $(nginx -v 2>&1)"
echo "路径: $BIN_LINK"
