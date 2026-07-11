#!/usr/bin/env bash
# Patch tdesign_flutter 0.2.7 for Flutter 3.44+ (IconData is final).
set -euo pipefail

ICON_FILE="$(find "${PUB_CACHE:-$HOME/.pub-cache}/hosted" -path '*/tdesign_flutter-0.2.7/lib/src/components/icon/td_icons.dart' 2>/dev/null | head -1)"

if [[ -z "${ICON_FILE}" ]]; then
  echo "tdesign_flutter td_icons.dart not found; run flutter pub get first."
  exit 1
fi

if grep -q 'Patched for Flutter 3.44' "${ICON_FILE}"; then
  echo "Already patched: ${ICON_FILE}"
  exit 0
fi

python3 - "${ICON_FILE}" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()

old_class = """@immutable
class _TDIconsData extends IconData {
  const _TDIconsData(int codePoint, this.name)
      : super(
    codePoint,
    fontFamily: 'TDIcons',
    fontPackage: 'tdesign_flutter',
  );

  final String name;
}"""

new_header = """// Patched for Flutter 3.44+: IconData is final and cannot be extended."""

if old_class not in text:
    raise SystemExit(f"Unexpected td_icons.dart format in {path}")

text = text.replace(old_class, new_header, 1)
text = re.sub(
    r"_TDIconsData\((0x[0-9A-Fa-f]+),\s*'[^']+'\)",
    r"IconData(\1, fontFamily: 'TDIcons', fontPackage: 'tdesign_flutter')",
    text,
)
text = text.replace("<String, _TDIconsData>", "<String, IconData>")

path.write_text(text)
print(f"Patched {path}")
PY
