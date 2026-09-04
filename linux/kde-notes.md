# KDE Plasma equivalents for the macOS apps

TUXEDO OS ships KDE Plasma, so a few macOS tools are simply not needed.

| macOS (cask)      | Linux equivalent                        | Install method            |
| ----------------- | --------------------------------------- | ------------------------- |
| iTerm2            | Konsole                                 | preinstalled              |
| Rectangle         | KWin tiling and window shortcuts        | built in, see below       |
| Raycast/Spotlight | KRunner (Alt + Space)                   | preinstalled              |
| brave-browser     | brave-browser                           | Brave apt repo            |
| visual-studio-code| code                                    | Microsoft apt repo        |
| zoom              | us.zoom.Zoom                            | Flathub                   |
| font-hack-nerd-font | Hack Nerd Font                        | `linux/fonts.sh`          |

## Rectangle style window snapping

No extra package needed. Set it once under
**System Settings > Keyboard > Shortcuts > KWin**:

- Quick Tile Left / Right: `Meta + Left` / `Meta + Right` (default)
- Quick Tile Top / Bottom: `Meta + Up` / `Meta + Down` (default)
- Quick Tile Top Left, Top Right, Bottom Left, Bottom Right: assign to
  `Meta + U`, `Meta + I`, `Meta + J`, `Meta + K` to mimic Rectangle
- Maximize Window: `Meta + Enter`

If you want the config version controlled later, add
`~/.config/kglobalshortcutsrc` and `~/.config/kwinrc` as a `kde` stow package.
They are machine specific, so they are deliberately left out for now.

## Konsole

Set the profile font to **MesloLGS Nerd Font 14** so the starship prompt
glyphs render the same as in iTerm2:
**Settings > Edit Current Profile > Appearance > Font**.
