#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Ensure zsh is default shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "[!] Changing default shell to zsh..."
    chsh -s /bin/zsh
fi

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "[!] Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

# Ensure stow is installed
if ! command -v stow &> /dev/null; then
    echo "[!] GNU Stow is not installed. Installing with Homebrew..."
    brew install stow
fi

# Ensure starship is installed
if ! command -v starship &> /dev/null; then
    echo "[!] Starship is not installed. Installing with Homebrew..."
    brew install starship
fi

# Ensure fastfetch is installed
if ! command -v fastfetch &> /dev/null; then
    echo "[!] Fastfetch is not installed. Installing with Homebrew..."
    brew install fastfetch
fi

# Ensure nvm is installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "[!] NVM is not installed. Installing with Homebrew..."
    brew install nvm
    mkdir -p "$HOME/.nvm"
fi

# Dotfolders from repo root (flattened vscode layout, no Library/ path)
DOT_FOLDERS="vscode,zsh"

# VS Code user folder base (macOS)
VSCODE_BASE="$HOME/Library/Application Support/Code/User"

# Collect VS Code profiles: default + named profiles
VSCODE_PROFILES=("$VSCODE_BASE")
if [ -d "$VSCODE_BASE/profiles" ]; then
    while IFS= read -r -d '' dir; do
        VSCODE_PROFILES+=("$dir")
    done < <(find "$VSCODE_BASE/profiles" -mindepth 1 -maxdepth 1 -type d -print0)
fi

for folder in $(echo $DOT_FOLDERS | sed "s/,/ /g"); do
    if [ "$folder" = "vscode" ]; then
        echo "[+] Applying VSCode config to all profiles..."
        for profile_path in "${VSCODE_PROFILES[@]}"; do
            echo "    -> $profile_path"
            stow --ignore=README.md --ignore=extensions.json --ignore=LICENSE \
                -d "$SCRIPT_DIR/$folder" -t "$profile_path" -D .
            stow -v --ignore=README.md --ignore=extensions.json --ignore=LICENSE \
                -d "$SCRIPT_DIR/$folder" -t "$profile_path" .
        done
    else
        # Normal dotfolder handling
        echo "[+] Applying dotfiles for: $folder"
        stow --ignore=README.md --ignore=LICENSE -t "$HOME" -D "$folder"
        stow -v -t "$HOME" "$folder"
    fi
done

# Reload shell
echo "[+] Reloading shell..."
exec $SHELL -l
