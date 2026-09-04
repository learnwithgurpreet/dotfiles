# Linux only (TUXEDO OS / Ubuntu base)

# Completion system, needed before the plugins below
autoload -Uz compinit && compinit -C

# Plugins from the native apt packages
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
  && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# nvm (upstream install, not apt)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Java from apt (update-alternatives keeps the default in sync)
if [ -z "${JAVA_HOME:-}" ] && command -v javac > /dev/null; then
  export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")"
fi

# pnpm (XDG location on Linux)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Flatpak apps in PATH and in the KDE menu
export PATH="$PATH:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin"

# Clipboard helpers, close to macOS pbcopy / pbpaste
if command -v wl-copy > /dev/null; then
  alias pbcopy="wl-copy"
  alias pbpaste="wl-paste"
elif command -v xclip > /dev/null; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi

# "open" like on macOS
command -v xdg-open > /dev/null && alias open="xdg-open"
