#!/usr/bin/env bash
# Symlinks the config packages with GNU stow.
# zsh + starship go to $HOME, vscode goes to every VS Code profile folder.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

if ! has stow; then
  err "GNU stow is not installed. Run the platform install script first."
  exit 1
fi

STOW_IGNORE=(--ignore=README.md --ignore=LICENSE --ignore=extensions.json)

# ---- HOME packages ----------------------------------------------------------
for pkg in zsh starship; do
  info "Stowing $pkg -> $HOME"
  stow "${STOW_IGNORE[@]}" -d "$DOTFILES_DIR" -t "$HOME" -D "$pkg" 2> /dev/null || true
  stow -v "${STOW_IGNORE[@]}" -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
done

# ---- VS Code ----------------------------------------------------------------
case "$(detect_os)" in
  macos) VSCODE_BASE="$HOME/Library/Application Support/Code/User" ;;
  linux) VSCODE_BASE="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User" ;;
esac

if [ -d "$VSCODE_BASE" ]; then
  VSCODE_PROFILES=("$VSCODE_BASE")
  if [ -d "$VSCODE_BASE/profiles" ]; then
    while IFS= read -r -d '' dir; do
      VSCODE_PROFILES+=("$dir")
    done < <(find "$VSCODE_BASE/profiles" -mindepth 1 -maxdepth 1 -type d -print0)
  fi

  info "Applying VS Code config to ${#VSCODE_PROFILES[@]} profile(s)"
  for profile_path in "${VSCODE_PROFILES[@]}"; do
    echo "    -> $profile_path"
    stow "${STOW_IGNORE[@]}" -d "$DOTFILES_DIR/vscode" -t "$profile_path" -D . 2> /dev/null || true
    stow -v "${STOW_IGNORE[@]}" -d "$DOTFILES_DIR/vscode" -t "$profile_path" .
  done
else
  warn "VS Code user folder not found at $VSCODE_BASE. Start VS Code once, then re-run."
fi

ok "Stow complete."
