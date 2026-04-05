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

# Claude Code
link "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Running brew bundle..."
brew update
brew bundle --file "$DOTFILES_DIR/Brewfile"
brew upgrade --cask
brew cleanup

echo "Done. Restart your terminal."