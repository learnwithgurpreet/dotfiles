#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Ensure zsh is default shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "[!] Changing default shell to zsh..."
    chsh -s /bin/zsh
fi

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "[!] Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session if needed
    if [ -d "/opt/homebrew/bin" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
    elif [ -d "/usr/local/bin" ]; then
        export PATH="/usr/local/bin:$PATH"
    fi
    if ! command -v brew &> /dev/null; then
        echo "[!] Homebrew installation failed. Please install manually."
        exit 1
    fi
fi

# Install all brew packages from brew-packages.txt
BREW_PACKAGES_FILE="$SCRIPT_DIR/brew-packages.txt"
if [ -f "$BREW_PACKAGES_FILE" ]; then
    echo "[+] Installing Homebrew packages from $BREW_PACKAGES_FILE..."
    while IFS= read -r pkg; do
        if [ -n "$pkg" ]; then
            if ! brew list "$pkg" &> /dev/null; then
                echo "    -> Installing $pkg..."
                brew install "$pkg"
            else
                echo "    -> $pkg already installed."
            fi
        fi
    done < "$BREW_PACKAGES_FILE"
else
    echo "[!] brew-packages.txt not found. Skipping bulk Homebrew package install."
fi

# Install all brew casks from brew-casks.txt
BREW_CASKS_FILE="$SCRIPT_DIR/brew-casks.txt"
if [ -f "$BREW_CASKS_FILE" ]; then
    echo "[+] Installing Homebrew casks from $BREW_CASKS_FILE..."
    while IFS= read -r cask; do
        if [ -n "$cask" ]; then
            if ! brew list --cask "$cask" &> /dev/null; then
                echo "    -> Installing $cask (cask)..."
                brew install --cask "$cask"
            else
                echo "    -> $cask (cask) already installed."
            fi
        fi
    done < "$BREW_CASKS_FILE"
else
    echo "[!] brew-casks.txt not found. Skipping bulk Homebrew cask install."
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
