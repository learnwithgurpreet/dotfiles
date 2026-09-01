#!/usr/bin/env bash

set -euo pipefail

# =============================================================================
# Homebrew cleanup
#
# Usage:
#   ./cleanup-brew.sh          # preview only
#   ./cleanup-brew.sh --apply  # actually uninstall
#
# Philosophy:
#   - Keep only software we intentionally want.
#   - Do NOT manually uninstall Homebrew dependency libraries.
#   - Let `brew autoremove` clean unused dependencies afterward.
# =============================================================================

APPLY=false

if [[ "${1:-}" == "--apply" ]]; then
  APPLY=true
fi

# -----------------------------------------------------------------------------
# Formulae we intentionally want on the Mac.
#
# Edit this list whenever you decide a tool belongs on every fresh Mac.
# -----------------------------------------------------------------------------

KEEP=(
  curl
  fastfetch
  ffmpeg
  fzf
  git
  gnupg
  lsd
  maven
  nvm
  openjdk
  pnpm
  ripgrep
  shfmt
  starship
  stow
  tesseract
  zsh
  zsh-autosuggestions
)

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

is_kept() {
  local package="$1"
  local kept

  for kept in "${KEEP[@]}"; do
    if [[ "$package" == "$kept" ]]; then
      return 0
    fi
  done

  return 1
}

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed."
  exit 1
fi

echo
echo "============================================================"
echo " Homebrew cleanup"
echo "============================================================"
echo

if "$APPLY"; then
  echo "Mode: APPLY"
else
  echo "Mode: DRY RUN"
  echo
  echo "Nothing will be removed."
  echo "Run with --apply after reviewing the output."
fi

echo

# -----------------------------------------------------------------------------
# Look only at top-level formulae.
#
# This is important:
# We don't want to individually remove things like libpng, openssl, cairo,
# freetype, x264, etc. Homebrew knows whether those are still required.
# -----------------------------------------------------------------------------

mapfile_support=false

# macOS ships an older bash, so don't rely on mapfile/readarray.
LEAVES="$(brew leaves)"

TO_REMOVE=()

while IFS= read -r package; do
  [[ -z "$package" ]] && continue

  if ! is_kept "$package"; then
    TO_REMOVE+=("$package")
  fi
done <<< "$LEAVES"

echo "Packages explicitly kept:"
echo

for package in "${KEEP[@]}"; do
  if brew list --formula "$package" >/dev/null 2>&1; then
    printf '  ✓ %s\n' "$package"
  else
    printf '  - %s (not installed)\n' "$package"
  fi
done

echo
echo "------------------------------------------------------------"
echo "Top-level packages not on the keep list:"
echo "------------------------------------------------------------"
echo

if [[ ${#TO_REMOVE[@]} -eq 0 ]]; then
  echo "  Nothing."
else
  for package in "${TO_REMOVE[@]}"; do
    printf '  ✗ %s\n' "$package"
  done
fi

echo

# -----------------------------------------------------------------------------
# Preview mode
# -----------------------------------------------------------------------------

if ! "$APPLY"; then
  echo "No changes made."
  echo
  echo "Review the packages marked ✗."
  echo
  echo "If the list looks correct, run:"
  echo
  echo "  $0 --apply"
  echo
  exit 0
fi

# -----------------------------------------------------------------------------
# Remove unwanted top-level packages
# -----------------------------------------------------------------------------

if [[ ${#TO_REMOVE[@]} -gt 0 ]]; then
  echo "Removing unwanted top-level formulae..."
  echo

  for package in "${TO_REMOVE[@]}"; do
    echo "→ brew uninstall $package"

    # Don't use --ignore-dependencies.
    #
    # If Homebrew says something still needs this package,
    # we WANT it to refuse removal.
    brew uninstall "$package"
  done
fi

# -----------------------------------------------------------------------------
# Remove dependencies that are no longer needed
# -----------------------------------------------------------------------------

echo
echo "Removing orphaned Homebrew dependencies..."
echo

brew autoremove

# -----------------------------------------------------------------------------
# Normal Homebrew cleanup
# -----------------------------------------------------------------------------

echo
echo "Cleaning old downloads and package versions..."
echo

brew cleanup

echo
echo "============================================================"
echo " Cleanup complete"
echo "============================================================"
echo
echo "Remaining top-level formulae:"
echo

brew leaves