# Dotfiles

## Installation

```sh
# install Stow
brew install stow

# to map zsh directory
stow -t $HOME -v zsh
```

## Stowing files

```sh
## First time
$ ./install.sh

## If you want to run it again, remove old files first
rm ~/.zshrc
rm -rf ~/.config/starship
rm "$HOME/Library/Application Support/Code/User/settings.json"
```
