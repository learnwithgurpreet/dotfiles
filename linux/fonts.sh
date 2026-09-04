#!/usr/bin/env bash
# Nerd Fonts are not in the Ubuntu repos, so they are installed per user
# into ~/.local/share/fonts (the native XDG font location).
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
# shellcheck source=../scripts/common.sh
source "$DOTFILES_DIR/scripts/common.sh"

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Hack = brew cask font-hack-nerd-font
# Meslo = the terminal font referenced in vscode/settings.json
FONTS=(Hack Meslo)

for font in "${FONTS[@]}"; do
  if fc-list 2> /dev/null | grep -qi "$font Nerd Font"; then
    echo "    -> $font Nerd Font already installed"
    continue
  fi
  info "Installing $font Nerd Font"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/$font.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip"
  unzip -qo "$tmp/$font.zip" -d "$FONT_DIR/$font-NerdFont"
  rm -rf "$tmp"
done

fc-cache -f > /dev/null
ok "Fonts installed. Set 'MesloLGS Nerd Font' in Konsole profile if needed."
