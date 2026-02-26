#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "${dest}.bak.$(date +%s)"
  fi
  ln -s "$src" "$dest"
  echo "linked $dest -> $src"
}

# Shell
link "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

# Git
link "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

# Starship config
link "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"

# Brew packages (optional: only runs if brew exists)
if command -v brew >/dev/null 2>&1; then
  echo "Running brew bundle..."
  brew bundle --file "$DOTFILES_DIR/Brewfile"
else
  echo "Homebrew not found. Install it first, then run this script again."
fi

echo "Done. Restart your terminal."
