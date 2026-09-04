# Projects
alias cb="cd ~/codebase/work/projects/project-1901-app-code"
alias dotfiles="cd ~/codebase/personal/git/dotfiles"

# Directory listing: lsd on macOS, lsd or eza on Linux
if command -v lsd > /dev/null; then
  alias ls="lsd"
  alias ll="lsd -l"
  alias lla="lsd -l -a"
elif command -v eza > /dev/null; then
  alias ls="eza --icons"
  alias ll="eza -l --icons"
  alias lla="eza -la --icons"
fi

# Git
alias ga="git add"
alias gaa="git add --all"
alias gst="git status --short"
alias gcf="git config --list"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gs="git switch"
alias glg="git log --oneline --graph --all --decorate"
