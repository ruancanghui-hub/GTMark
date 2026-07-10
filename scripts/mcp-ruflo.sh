#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"

RUFLO_BIN="$HOME/.local/lib/node_modules/ruflo/bin/ruflo.js"
NODE_BIN="$(command -v node || true)"

if [[ -n "$NODE_BIN" && -f "$RUFLO_BIN" ]]; then
  exec "$NODE_BIN" "$RUFLO_BIN" mcp start
fi

if [[ -x "$HOME/.local/bin/ruflo" ]]; then
  exec "$HOME/.local/bin/ruflo" mcp start
fi

exec npx -y ruflo@3.7.0-alpha.9 mcp start
