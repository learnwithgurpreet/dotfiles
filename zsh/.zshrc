# ~/.zshrc - thin loader. Everything real lives in ~/.config/zsh/
ZDOTDIR_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# 1. platform specific bits first (paths, package manager env)
case "$(uname -s)" in
  Darwin) [ -f "$ZDOTDIR_CONF/macos.zsh" ] && source "$ZDOTDIR_CONF/macos.zsh" ;;
  Linux)  [ -f "$ZDOTDIR_CONF/linux.zsh" ] && source "$ZDOTDIR_CONF/linux.zsh" ;;
esac

# 2. shared config
for f in common.zsh aliases.zsh; do
  [ -f "$ZDOTDIR_CONF/$f" ] && source "$ZDOTDIR_CONF/$f"
done

# 3. machine local overrides, never committed
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
