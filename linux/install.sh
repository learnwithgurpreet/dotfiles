#!/usr/bin/env bash
# Bootstrap for TUXEDO OS (Ubuntu LTS base, KDE Plasma).
# Prefers native apt packages, falls back to Flathub or upstream installers
# only where no maintained deb exists.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
# shellcheck source=../scripts/common.sh
source "$DOTFILES_DIR/scripts/common.sh"

DISTRO="$(detect_distro)"
info "Distro: $DISTRO"

# -----------------------------------------------------------------------------
# 1. apt packages
# -----------------------------------------------------------------------------
info "Updating apt index"
sudo apt-get update -qq

MISSING=()
while IFS= read -r pkg; do
  if apt_available "$pkg"; then
    MISSING+=("$pkg")
  else
    warn "apt package not available, will handle via fallback: $pkg"
  fi
done < <(read_list "$SCRIPT_DIR/apt-packages.txt")

if [ ${#MISSING[@]} -gt 0 ]; then
  info "Installing ${#MISSING[@]} apt packages"
  sudo apt-get install -y "${MISSING[@]}"
fi

# Fallbacks for packages that are not in every Ubuntu release
has lsd    || { apt_available eza && sudo apt-get install -y eza; }
has fastfetch || { apt_available neofetch && sudo apt-get install -y neofetch; }

# -----------------------------------------------------------------------------
# 2. Brave browser (official apt repo, native deb)
# -----------------------------------------------------------------------------
if ! has brave-browser; then
  info "Adding Brave apt repository"
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
  sudo apt-get update -qq && sudo apt-get install -y brave-browser
fi

# -----------------------------------------------------------------------------
# 3. VS Code (Microsoft apt repo, native deb)
# -----------------------------------------------------------------------------
if ! has code; then
  info "Adding Microsoft VS Code apt repository"
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  sudo apt-get update -qq && sudo apt-get install -y code
fi

# -----------------------------------------------------------------------------
# 4. Flatpak apps
# -----------------------------------------------------------------------------
if has flatpak; then
  flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
  while IFS= read -r app; do
    if flatpak info "$app" &> /dev/null; then
      echo "    -> $app already installed"
    else
      info "Installing flatpak $app"
      flatpak install -y --user flathub "$app"
    fi
  done < <(read_list "$SCRIPT_DIR/flatpak-apps.txt")
fi

# -----------------------------------------------------------------------------
# 5. Tools with no native package
# -----------------------------------------------------------------------------
# starship: not packaged in Ubuntu, use the official installer into ~/.local/bin
if ! has starship; then
  info "Installing starship"
  mkdir -p "$HOME/.local/bin"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
fi

# nvm: upstream script (the apt "npm" package is intentionally not used)
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  info "Installing nvm"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if has nvm && ! nvm ls default &> /dev/null; then
  info "Installing Node LTS as default"
  nvm install --lts
  nvm alias default 'lts/*'
fi

# pnpm via corepack (ships with Node, no extra package needed)
if has corepack; then
  corepack enable
  corepack prepare pnpm@latest --activate || true
fi

# shfmt fallback
has shfmt || warn "shfmt not installed. Optional: go install mvdan.cc/sh/v3/cmd/shfmt@latest"

# -----------------------------------------------------------------------------
# 6. Fonts
# -----------------------------------------------------------------------------
bash "$SCRIPT_DIR/fonts.sh"

# -----------------------------------------------------------------------------
# 7. Default shell
# -----------------------------------------------------------------------------
ZSH_PATH="$(command -v zsh)"
if [ "${SHELL:-}" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell"
  chsh -s "$ZSH_PATH" "$USER" || warn "chsh failed, run it manually"
fi

ok "Linux bootstrap finished."
