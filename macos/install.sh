#!/usr/bin/env bash
# Bootstrap for macOS. Same logic as before, only the stow and extension
# steps moved to scripts/ so both platforms share them.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
# shellcheck source=../scripts/common.sh
source "$DOTFILES_DIR/scripts/common.sh"

# Homebrew
if ! has brew; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Formulae
info "Installing Homebrew packages"
while IFS= read -r pkg; do
  if brew list "$pkg" &> /dev/null; then
    echo "    -> $pkg already installed"
  else
    echo "    -> installing $pkg"
    brew install "$pkg" < /dev/null
  fi
done < <(read_list "$SCRIPT_DIR/brew-packages.txt")

# Casks
info "Installing Homebrew casks"
while IFS= read -r cask; do
  if brew list --cask "$cask" &> /dev/null; then
    echo "    -> $cask already installed"
  else
    echo "    -> installing $cask"
    brew install --cask "$cask" < /dev/null
  fi
done < <(read_list "$SCRIPT_DIR/brew-casks.txt")

# Default shell
if [ "${SHELL:-}" != "/bin/zsh" ]; then
  info "Setting zsh as default shell"
  chsh -s /bin/zsh
fi

ok "macOS bootstrap finished."
