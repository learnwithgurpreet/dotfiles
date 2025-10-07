eval "$(/opt/homebrew/bin/brew shellenv)"

# Starship Setup
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Auto Suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Aliases: Projects
alias cb="cd ~/codebase/work/projects/project-1901-app-code"
alias dotfiles="cd ~/codebase/personal/git/dotfiles"

# Aliases: Directory listing with lsd
alias ls="lsd"
alias ll="lsd -l"
alias lla="lsd -l -a"

# Aliases: Git
alias status="git status --short"

alias pull="git pull"

alias log="git log --oneline --graph --all --decorate"

# alt + left/right: jump one word backward/forward
bindkey '^[^[[D' emacs-backward-word
bindkey '^[^[[C' emacs-forward-word

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export PATH=/Users/gursingh7/development/apache-maven-3.8.4/bin:$PATH

# Importing Python
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"

# Chromium path for Puppeteer
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# Flutter
export PATH="$PATH:$HOME/flutter/bin"
export PATH=$(yarn global bin):$PATH

if [ -f $PWD/.nvmrc ]; then
  # Load the version specified in .nvmrc if it exists
  nvm use --silent
else
  # Fallback to default
  nvm use --silent default
fi

# pnpm
export PNPM_HOME="/Users/gursingh7/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
