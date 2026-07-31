#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    # Already points to our dotfiles — no backup needed, just replace
    if [ "$(readlink "$dest")" = "$src" ]; then
      echo "already linked $dest -> $src"
      return
    fi
    # Symlink to somewhere else — copy the real content, then remove
    if [ -e "$dest" ]; then
      cp -L "$dest" "${dest}.bak.$(date +%s)"
    fi
    rm "$dest"
  elif [ -e "$dest" ]; then
    mv "$dest" "${dest}.bak.$(date +%s)"
  fi
  ln -s "$src" "$dest"
  echo "linked $dest -> $src"
}

# Shell
# zshenv first: it is the only one zsh reads for NON-login shells, which is what
# GUI apps (Conductor, IDEs) spawn. Without it such a shell has no PATH at all
# and cannot even find `ls`.
link "$DOTFILES_DIR/zshenv" "$HOME/.zshenv"
link "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

# Git
link "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

# Starship config
link "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"

# SSH config
link "$DOTFILES_DIR/config/ssh/config" "$HOME/.ssh/config"

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

echo
echo "Done. Restart your terminal."
echo
echo "One manual step remains — the login keychain does not sync over iCloud,"
echo "so this machine has no Claude Code token yet. Copy the SAME token used on"
echo "your other Macs (see the comment in zshenv for why one token, not one per"
echo "machine) and store it with:"
echo
echo "  security add-generic-password -U -a \"$USER\" -s claude-code-oauth-token -w"
echo
echo "Until then Claude Code falls back to normal interactive login."