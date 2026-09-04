#!/usr/bin/env bash
# Entry point. Detects the OS and hands over to the platform bootstrap.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
export DOTFILES_DIR="$SCRIPT_DIR"

# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/scripts/common.sh"

OS="$(detect_os)"
info "Detected platform: $OS"

case "$OS" in
  macos)
    bash "$SCRIPT_DIR/macos/install.sh"
    ;;
  linux)
    bash "$SCRIPT_DIR/linux/install.sh"
    ;;
  *)
    err "Unsupported platform: $OS"
    exit 1
    ;;
esac

# Shared steps for every platform
bash "$SCRIPT_DIR/scripts/stow.sh"
bash "$SCRIPT_DIR/scripts/install-ext.sh"

ok "Done. Open a new terminal or run: exec zsh -l"
