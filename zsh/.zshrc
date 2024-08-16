eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh My Posh
eval "$(oh-my-posh init zsh)"

# Prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/catppuccin_frappe.json)"

# Auto Suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Alias Section
alias work="cd ~/codebase/work"
alias status="git status"
alias pull="git pull origin"
alias checkout="git checkout "
alias cb="cd ~/codebase/work/projects/PS_frontend_1901"
alias ls="lsd"
alias ll="lsd -l"
alias l="lsd -l -a"

# alt + left/right: jump one word backward/forward
bindkey '^[^[[D' emacs-backward-word
bindkey '^[^[[C' emacs-forward-word

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.0.1.jdk/Contents/Home
# export _JAVA_OPTIONS=-Xmx512M
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
