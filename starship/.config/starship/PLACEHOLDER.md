# starship configs go here

Copy your two existing files into this folder, unchanged:

- `starship.toml`
- `starship_catppuccin_mocha.toml`

They are not reproduced by the generator because they contain Nerd Font glyphs
that do not survive copy and paste reliably. Both files are platform neutral,
so the macOS versions work on Linux as they are.

Two things worth knowing:

1. `starship.toml` already defines `[os.symbols]` for Ubuntu, Debian, Linux and
   friends, so the prompt renders correctly on TUXEDO OS with no change.
   TUXEDO OS reports itself as an Ubuntu derivative, so the Ubuntu glyph is used.
2. `zsh/.config/zsh/common.zsh` points `STARSHIP_CONFIG` at
   `~/.config/starship/starship.toml` on both platforms. To use the Catppuccin
   layout instead, either swap the file names or override the variable in
   `~/.zshrc.local`.

Delete this file once you have copied yours in.
