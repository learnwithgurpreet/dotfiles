#!/usr/bin/env bash
# Installs the VS Code extensions listed in vscode/extensions.json.
#
# A single unavailable extension (renamed, unpublished, retired) must never
# abort the run: the rest still need installing. Failures are collected and
# reported at the end instead.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

JSON_FILE="$DOTFILES_DIR/vscode/extensions.json"
[ -f "$JSON_FILE" ] || { err "Could not find $JSON_FILE"; exit 1; }

if has code; then
  CODE_BIN=(code)
elif has code-insiders; then
  CODE_BIN=(code-insiders)
elif has flatpak && flatpak info com.visualstudio.code &> /dev/null; then
  CODE_BIN=(flatpak run com.visualstudio.code)
else
  warn "VS Code CLI not found. Skipping extension install."
  exit 0
fi

# Strips VS Code's node noise (DEP0169 url.parse warnings etc.)
denoise() {
  grep -vE 'DeprecationWarning|trace-deprecation|^\(node:[0-9]+\)' || true
}

INSTALLED=0
PRESENT=0
FAILED=()

# Process substitution, not a pipe: keeps the counters in this shell.
while IFS= read -r ext; do
  [ -n "$ext" ] || continue
  if out="$("${CODE_BIN[@]}" --install-extension "$ext" --force 2>&1)"; then
    if grep -qi 'already installed' <<< "$out"; then
      PRESENT=$((PRESENT + 1))
      printf '  \033[2m= %s\033[0m\n' "$ext"
    else
      INSTALLED=$((INSTALLED + 1))
      printf '  \033[32m+ %s\033[0m\n' "$ext"
    fi
  else
    FAILED+=("$ext")
    printf '  \033[31mx %s\033[0m\n' "$ext"
    denoise <<< "$out" | sed 's/^/      /'
  fi
done < <(python3 -c "import json;print('\n'.join(json.load(open('$JSON_FILE'))['recommendations']))")

echo
info "Extensions: $INSTALLED newly installed, $PRESENT already present, ${#FAILED[@]} failed"

if [ ${#FAILED[@]} -gt 0 ]; then
  warn "These extensions could not be installed:"
  for ext in "${FAILED[@]}"; do
    echo "      - $ext"
  done
  warn "They are usually renamed, unpublished or retired."
  warn "Verify the IDs, then remove the dead ones from vscode/extensions.json."
fi

# Deliberately exit 0: a dead extension ID is not a reason to fail the
# whole bootstrap. The summary above is the signal.
ok "Extension step complete."
