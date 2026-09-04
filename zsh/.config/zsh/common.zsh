# Shared across macOS and Linux

export LANG=en_US.UTF-8
export EDITOR="${EDITOR:-code --wait}"
export PATH="$HOME/.local/bin:$PATH"

# Starship prompt
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
command -v starship > /dev/null && eval "$(starship init zsh)"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY

# alt + left/right: jump one word backward/forward
bindkey '^[^[[D' emacs-backward-word
bindkey '^[^[[C' emacs-forward-word
bindkey '^[[1;3D' emacs-backward-word
bindkey '^[[1;3C' emacs-forward-word

# fzf keybindings (path differs per platform, both are checked)
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# nvm: auto switch based on .nvmrc
if command -v nvm > /dev/null; then
  if [ -f "$PWD/.nvmrc" ]; then
    nvm use --silent
  else
    nvm use --silent default 2> /dev/null
  fi
fi

# Puppeteer: use the system chromium instead of downloading one
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
command -v chromium > /dev/null && export PUPPETEER_EXECUTABLE_PATH="$(command -v chromium)"

# Extra tool paths, only added when present
[ -d "$HOME/.pub-cache/bin" ] && export PATH="$PATH:$HOME/.pub-cache/bin"
[ -d "$HOME/flutter/bin" ] && export PATH="$PATH:$HOME/flutter/bin"
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"
[ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
