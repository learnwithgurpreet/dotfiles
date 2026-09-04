#!/usr/bin/env bash
# Shared helpers used by every install script.

info() { printf '\033[1;34m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; }
ok()   { printf '\033[1;32m[✓]\033[0m %s\n' "$*"; }

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}

# Distro id, e.g. tuxedo, ubuntu, debian
detect_distro() {
  if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    echo "${ID:-unknown}"
  else
    echo "unknown"
  fi
}

has() { command -v "$1" &> /dev/null; }

# Reads a package list file, ignoring blank lines and # comments
read_list() {
  local file="$1"
  [ -f "$file" ] || return 0
  sed -e 's/#.*$//' -e 's/[[:space:]]*$//' "$file" | grep -v '^$' || true
}

apt_available() {
  apt-cache policy "$1" 2> /dev/null | grep -q 'Candidate: [^(]'
}
