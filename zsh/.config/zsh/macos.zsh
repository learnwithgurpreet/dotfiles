# macOS only

eval "$(/opt/homebrew/bin/brew shellenv)"

# Auto suggestions (Homebrew path)
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Java + Maven
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home"
export PATH="$HOME/development/apache-maven-3.8.4/bin:$PATH"

# Python framework build
export PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
