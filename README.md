# dotfiles

One repo, two platforms: macOS (Homebrew) and TUXEDO OS / Ubuntu (apt).
Config packages are shared, only the package installation differs.

## Install

```bash
git clone <your-repo-url> ~/codebase/personal/git/dotfiles
cd ~/codebase/personal/git/dotfiles
./install.sh
```

`install.sh` detects the OS and runs the right bootstrap, then applies the
shared stow packages and the VS Code extensions.

## Layout

```
dotfiles/
├── install.sh              # OS detection, single entry point
├── scripts/
│   ├── common.sh           # logging, detect_os, detect_distro, helpers
│   ├── stow.sh             # symlinks zsh + starship to $HOME, vscode to all profiles
│   └── install-ext.sh      # VS Code extensions from vscode/extensions.json
├── macos/
│   ├── install.sh          # Homebrew bootstrap
│   ├── brew-packages.txt
│   └── brew-casks.txt
├── linux/
│   ├── install.sh          # apt bootstrap, Brave + VS Code repos, flatpak, starship, nvm
│   ├── apt-packages.txt    # native packages, mirrors brew-packages.txt
│   ├── flatpak-apps.txt    # only what has no good deb
│   ├── fonts.sh            # Nerd Fonts into ~/.local/share/fonts
│   └── kde-notes.md        # Rectangle, iTerm2 and Spotlight equivalents
├── vscode/                 # stow package -> VS Code User dir (all profiles)
│   ├── settings.json
│   └── extensions.json
├── zsh/                    # stow package -> $HOME
│   ├── .zshrc              # loader only
│   └── .config/zsh/
│       ├── common.zsh      # shared
│       ├── aliases.zsh     # shared
│       ├── macos.zsh       # brew, nvm from brew, Library paths
│       └── linux.zsh       # apt plugin paths, XDG pnpm, flatpak, clipboard aliases
└── starship/               # stow package -> $HOME
    └── .config/starship/   # copy your two toml files here
```

## Why one repo

The parts that actually differ are the package lists and roughly 30 lines of
shell. Everything else (VS Code settings, extensions, starship, aliases, git
shortcuts, keybindings) is identical. Two repos would mean maintaining those in
two places and they would drift within weeks. The split is by directory, not by
repository.

Split into a second repo only if the machines diverge hard, for example a
work-managed Linux box with different credentials and project aliases. Even
then, prefer a private `~/.zshrc.local` (already sourced, never committed) over
a fork.

## Package mapping, macOS to Linux

| brew                | apt / native Linux                      | Note                                |
| ------------------- | --------------------------------------- | ----------------------------------- |
| curl, git, gnupg    | curl, git, gnupg                        | same names                          |
| fzf, ripgrep, stow  | fzf, ripgrep, stow                      | same names                          |
| zsh-autosuggestions | zsh-autosuggestions                     | plus zsh-syntax-highlighting        |
| lsd                 | lsd, fallback eza                       | aliases pick whichever exists       |
| fastfetch           | fastfetch, fallback neofetch            | fastfetch lands in Ubuntu 24.10+    |
| ffmpeg              | ffmpeg                                  | same                                |
| tesseract           | tesseract-ocr + language packs          | deu and eng included                |
| openjdk             | openjdk-21-jdk                          | JAVA_HOME derived at shell startup  |
| maven               | maven                                   | same                                |
| shfmt               | shfmt, fallback `go install`            | not in every release                |
| starship            | official installer to ~/.local/bin      | not packaged in Ubuntu              |
| nvm                 | upstream nvm install script             | apt nodejs deliberately not used    |
| pnpm                | corepack                                | ships with Node, no extra package   |

## Notes

- The scripts are idempotent, running `./install.sh` again is safe.
- `apt_available` checks each package before installing, so a name that is
  missing on your release prints a warning instead of aborting the run.
- `linhmtran168.mac-ca-vscode` and `ukoloff.win-ca` in `extensions.json` are
  platform specific certificate helpers. They install harmlessly on Linux but
  do nothing, remove them if you want a clean extension list.
- Machine specific values belong in `~/.zshrc.local`, which is sourced last.
