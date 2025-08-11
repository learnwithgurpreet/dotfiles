#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

# for folder in $(echo $DOT_FOLDERS | sed "s/,/ /g"); do
#     echo "[+] Folder :: $folder"
#     stow --ignore=README.md --ignore=LICENSE \
#         -t $HOME -D $folder
#     stow -v -t $HOME $folder
# done

# # Reload shell once installed
# echo "[+] Reloading shell..."
# exec $SHELL -l